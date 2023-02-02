import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../export';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { getElementType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from '../storage/dynArray';
import { StorageWriteGen } from '../storage/storageWrite';

const IMPLICITS = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

export class CalldataToStorageGen extends StringIndexedFuncGen {
  public constructor(
    private dynArrayGen: DynArrayGen,
    private storageWriteGen: StorageWriteGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  public gen(storageLocation: Expression, calldataLocation: Expression): FunctionCall {
    const storageType = generalizeType(safeGetNodeType(storageLocation, this.ast.inference))[0];
    const calldataType = generalizeType(safeGetNodeType(calldataLocation, this.ast.inference))[0];
    const funcDef = this.getOrCreateFuncDef(calldataType, storageType);

    return createCallToFunction(funcDef, [storageLocation, calldataLocation], this.ast);
  }

  public getOrCreateFuncDef(calldataType: TypeNode, storageType: TypeNode) {
    const key = `calldataToStorage(${calldataType.pp()},${storageType.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(calldataType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['loc', typeNameFromTypeNode(storageType, this.ast), DataLocation.Storage],
        ['dynarray', typeNameFromTypeNode(calldataType, this.ast), DataLocation.CallData],
      ],
      [['loc', typeNameFromTypeNode(storageType, this.ast), DataLocation.Storage]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from calldata to storage is not supported yet`,
      );
    };

    return delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynamicArrayCopyFunction(type),
      (type) => this.createStaticArrayCopyFunction(type),
      (type, def) => this.createStructCopyFunction(type, def),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
  }

  private createStructCopyFunction(
    structType: UserDefinedType,
    structDef: StructDefinition,
  ): GeneratedFunctionInfo {
    const cairoStruct = CairoType.fromSol(
      structType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const structName = `struct_${structDef.name}`;
    const members = structDef.vMembers.map((varDecl) => `${structName}.${varDecl.name}`);

    const [copyInstructions, funcsCalled] = this.generateStructCopyInstructions(
      structDef.vMembers.map((varDecl) => safeGetNodeType(varDecl, this.ast.inference)),
      members,
    );

    const funcName = `cd_struct_${cairoStruct.toString()}_to_storage`;
    const code = [
      `func ${funcName}${IMPLICITS}(loc : felt, ${structName} : ${cairoStruct.toString()}) -> (loc : felt){`,
      `   alloc_locals;`,
      ...copyInstructions,
      `   return (loc,);`,
      `}`,
    ].join('\n');

    return { name: funcName, code: code, functionsCalled: funcsCalled };
  }

  // TODO: Check if funcion size can be reduced for big static arrays
  private createStaticArrayCopyFunction(arrayType: ArrayType): GeneratedFunctionInfo {
    assert(arrayType.size !== undefined);

    const len = narrowBigIntSafe(arrayType.size);
    const cairoType = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);

    const elems = mapRange(len, (n) => `static_array[${n}]`);
    const [copyInstructions, funcsCalled] = this.generateStructCopyInstructions(
      mapRange(len, () => arrayType.elementT),
      elems,
    );

    const funcName = `cd_static_array_to_storage${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}${IMPLICITS}(loc : felt, static_array : ${cairoType.toString()}) -> (loc : felt){`,
      `   alloc_locals;`,
      ...copyInstructions,
      `   return (loc,);`,
      `}`,
    ].join('\n');

    return { name: funcName, code: code, functionsCalled: funcsCalled };
  }

  private createDynamicArrayCopyFunction(
    arrayType: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const elementT = getElementType(arrayType);
    const structDef = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);
    assert(structDef instanceof CairoDynArray);

    const [dynArray, dynArrayLength] = this.dynArrayGen.getOrCreateFuncDef(elementT);
    const lenName = dynArrayLength.name;
    const cairoElementType = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const writeDef = this.storageWriteGen.getOrCreateFuncDef(elementT);
    const copyCode = `${writeDef.name}(elem_loc, elem[index]);`;

    const pointerType = `${cairoElementType.toString()}*`;

    const funcName = `cd_dynamic_array_to_storage${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}_write${IMPLICITS}(loc : felt, index : felt, len : felt, elem: ${pointerType}){`,
      `   alloc_locals;`,
      `   if (index == len){`,
      `       return ();`,
      `   }`,
      `   let (index_uint256) = warp_uint256(index);`,
      `   let (elem_loc) = ${dynArray.name}.read(loc, index_uint256);`,
      `   if (elem_loc == 0){`,
      `       let (elem_loc) = WARP_USED_STORAGE.read();`,
      `       WARP_USED_STORAGE.write(elem_loc + ${cairoElementType.width});`,
      `       ${dynArray.name}.write(loc, index_uint256, elem_loc);`,
      `       ${copyCode}`,
      `       return ${funcName}_write(loc, index + 1, len, elem);`,
      `   }else{`,
      `       ${copyCode}`,
      `       return ${funcName}_write(loc, index + 1, len, elem);`,
      `   }`,
      `}`,

      `func ${funcName}${IMPLICITS}(loc : felt, dyn_array_struct : ${structDef.name}) -> (loc : felt){ `,
      `   alloc_locals;`,
      `   let (len_uint256) = warp_uint256(dyn_array_struct.len);`,
      `   ${lenName}.write(loc, len_uint256);`,
      `   ${funcName}_write(loc, 0, dyn_array_struct.len, dyn_array_struct.ptr);`,
      `   return (loc,);`,
      `}`,
    ].join('\n');

    return {
      name: funcName,
      code: code,
      functionsCalled: [
        this.requireImport('warplib.maths.int_conversions', 'warp_uint256'),
        dynArray,
        dynArrayLength,
        writeDef,
      ],
    };
  }

  private generateStructCopyInstructions(
    varTypes: TypeNode[],
    names: string[],
  ): [string[], CairoFunctionDefinition[]] {
    const [copyInstructions, funcCalls] = varTypes.reduce(
      ([copyInstructions, funcCalls, offset], varType, index) => {
        const varCairoTypeWidth = CairoType.fromSol(
          varType,
          this.ast,
          TypeConversionContext.CallDataRef,
        ).width;

        const writeDef = this.storageWriteGen.getOrCreateFuncDef(varType);
        const location = add('loc', offset);
        return [
          [...copyInstructions, `    ${writeDef.name}(${location}, ${names[index]});`],
          [...funcCalls, writeDef],
          offset + varCairoTypeWidth,
        ];
      },
      [new Array<string>(), new Array<CairoFunctionDefinition>(), 0],
    );

    return [copyInstructions, funcCalls];
  }
}
