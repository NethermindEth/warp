import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  generalizeType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { getElementType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from '../storage/dynArray';
import { StorageWriteGen } from '../storage/storageWrite';

export class CalldataToStorageGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageWriteGen: StorageWriteGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  gen(
    storageLocation: Expression,
    calldataLocation: Expression,
    nodeInSourceUnit?: ASTNode,
  ): FunctionCall {
    const storageType = generalizeType(safeGetNodeType(storageLocation, this.ast.inference))[0];
    const calldataType = generalizeType(safeGetNodeType(calldataLocation, this.ast.inference))[0];
    const funcDef = this.getOrCreateFuncDef(calldataType, storageType);

    return createCallToFunction(funcDef, [storageLocation, calldataLocation], this.ast);
  }

  getOrCreateFuncDef(calldataType: TypeNode, storageType: TypeNode) {
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
      // ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
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
      (type) => this.createStructCopyFunction(type),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
  }

  private createStructCopyFunction(structType: UserDefinedType): GeneratedFunctionInfo {
    assert(structType.definition instanceof StructDefinition);
    const structDef = structType.definition;
    const cairoStruct = CairoType.fromSol(
      structType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const funcsCalled: FunctionDefinition[] = [];
    const structName = `struct_${cairoStruct.toString()}`;

    const members = structDef.vMembers.map((varDecl) => `${structName}.${varDecl.name}`);
    const copyInstructions = this.generateStructCopyInstructions(
      structDef.vMembers.map((varDecl) => safeGetNodeType(varDecl, this.ast.inference)),
      members,
      funcsCalled,
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `cd_struct_${cairoStruct.toString()}_to_storage`;
    const code = [
      `func ${funcName}${implicits}(loc : felt, ${structName} : ${cairoStruct.toString()}) -> (loc : felt){`,
      `   alloc_locals;`,
      ...copyInstructions,
      `   return (loc,);`,
      `}`,
    ].join('\n');

    const funcInfo = { name: funcName, code: code, functionsCalled: funcsCalled };
    return funcInfo;
  }

  private createStaticArrayCopyFunction(arrayType: ArrayType): GeneratedFunctionInfo {
    assert(arrayType.size !== undefined);

    const funcsCalled: FunctionDefinition[] = [];

    const cairoType = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);

    const len = narrowBigIntSafe(arrayType.size);

    const elems = mapRange(len, (n) => `static_array[${n}]`);
    const copyInstructions = this.generateStructCopyInstructions(
      mapRange(len, () => arrayType.elementT),
      elems,
      funcsCalled,
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `cd_static_array_to_storage${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}${implicits}(loc : felt, static_array : ${cairoType.toString()}) -> (loc : felt){`,
      `   alloc_locals;`,
      ...copyInstructions,
      `   return (loc,);`,
      `}`,
    ].join('\n');

    const funcInfo = { name: funcName, code: code, functionsCalled: funcsCalled };
    return funcInfo;
  }

  private createDynamicArrayCopyFunction(
    arrayType: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const elementT = getElementType(arrayType);
    const structDef = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);
    assert(structDef instanceof CairoDynArray);

    const funcsCalled: FunctionDefinition[] = [];

    const arrayDef = this.dynArrayGen.getOrCreateFuncDef(elementT);
    funcsCalled.push(arrayDef);
    const lenName = arrayDef.name + '_LENGTH';
    const cairoElementType = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const writeDef = this.storageWriteGen.getOrCreateFuncDef(elementT);
    funcsCalled.push(writeDef);
    const copyCode = `${writeDef.name}(elem_loc, elem[index]);`;

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const pointerType = `${cairoElementType.toString()}*`;

    funcsCalled.push(this.requireImport('warplib.maths.int_conversions', 'warp_uint256'));
    const funcName = `cd_dynamic_array_to_storage${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}_write${implicits}(loc : felt, index : felt, len : felt, elem: ${pointerType}){`,
      `   alloc_locals;`,
      `   if (index == len){`,
      `       return ();`,
      `   }`,
      `   let (index_uint256) = warp_uint256(index);`,
      `   let (elem_loc) = ${arrayDef.name}.read(loc, index_uint256);`,
      `   if (elem_loc == 0){`,
      `       let (elem_loc) = WARP_USED_STORAGE.read();`,
      `       WARP_USED_STORAGE.write(elem_loc + ${cairoElementType.width});`,
      `       ${arrayDef.name}.write(loc, index_uint256, elem_loc);`,
      `       ${copyCode}`,
      `       return ${funcName}_write(loc, index + 1, len, elem);`,
      `   }else{`,
      `       ${copyCode}`,
      `       return ${funcName}_write(loc, index + 1, len, elem);`,
      `   }`,
      `}`,

      `func ${funcName}${implicits}(loc : felt, dyn_array_struct : ${structDef.name}) -> (loc : felt){ `,
      `   alloc_locals;`,
      `   let (len_uint256) = warp_uint256(dyn_array_struct.len);`,
      `   ${lenName}.write(loc, len_uint256);`,
      `   ${funcName}_write(loc, 0, dyn_array_struct.len, dyn_array_struct.ptr);`,
      `   return (loc,);`,
      `}`,
    ].join('\n');

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: code,
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private generateStructCopyInstructions(
    varTypes: TypeNode[],
    names: string[],
    funcsCalled: FunctionDefinition[],
  ): string[] {
    let offset = 0;
    const copyInstructions = varTypes.map((varType, index) => {
      const varCairoTypeWidth = CairoType.fromSol(
        varType,
        this.ast,
        TypeConversionContext.CallDataRef,
      ).width;

      const writeDef = this.storageWriteGen.getOrCreateFuncDef(varType);
      funcsCalled.push(writeDef);
      const location = add('loc', offset);

      offset += varCairoTypeWidth;

      return `    ${writeDef.name}(${location}, ${names[index]});`;
    });

    return copyInstructions;
  }
}
