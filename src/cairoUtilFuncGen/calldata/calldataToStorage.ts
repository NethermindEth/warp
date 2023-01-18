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

    const funcInfo = this.getOrCreate(calldataType);
    const functionStub = createCairoGeneratedFunction(
      funcInfo,
      [
        ['loc', typeNameFromTypeNode(storageType, this.ast), DataLocation.Storage],
        ['dynarray', typeNameFromTypeNode(calldataType, this.ast), DataLocation.CallData],
      ],
      [['loc', typeNameFromTypeNode(storageType, this.ast), DataLocation.Storage]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? storageLocation,
    );

    return createCallToFunction(functionStub, [storageLocation, calldataLocation], this.ast);
  }

  getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from calldata to storage is not supported yet`,
      );
    };

    return delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynamicArrayCopyFunction(key, type),
      (type) => this.createStaticArrayCopyFunction(key, type),
      (type) => this.createStructCopyFunction(key, type),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
  }

  private createStructCopyFunction(
    key: string,
    structType: UserDefinedType,
  ): GeneratedFunctionInfo {
    assert(structType.definition instanceof StructDefinition);
    const structDef = structType.definition;
    const cairoStruct = CairoType.fromSol(
      structType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const structName = `struct_${cairoStruct.toString()}`;

    const members = structDef.vMembers.map((varDecl) => `${structName}.${varDecl.name}`);
    const copyInstructions = this.generateStructCopyInstructions(
      structDef.vMembers.map((varDecl) => safeGetNodeType(varDecl, this.ast.inference)),
      members,
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

    const funcInfo = { name: funcName, code: code, functionsCalled: [] };
    this.generatedFunctions.set(key, { name: funcName, code: code, functionsCalled: [] });
    return funcInfo;
  }

  private createStaticArrayCopyFunction(key: string, arrayType: ArrayType): GeneratedFunctionInfo {
    assert(arrayType.size !== undefined);

    const cairoType = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);

    const len = narrowBigIntSafe(arrayType.size);

    const elems = mapRange(len, (n) => `static_array[${n}]`);
    const copyInstructions = this.generateStructCopyInstructions(
      mapRange(len, () => arrayType.elementT),
      elems,
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `cd_static_array_to_storage${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${implicits}(loc : felt, static_array : ${cairoType.toString()}) -> (loc : felt){`,
      `   alloc_locals;`,
      ...copyInstructions,
      `   return (loc,);`,
      `}`,
    ].join('\n');

    const funcInfo = { name: funcName, code: code, functionsCalled: [] };
    this.generatedFunctions.set(key, funcInfo);

    return funcInfo;
  }

  private createDynamicArrayCopyFunction(
    key: string,
    arrayType: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const elementT = getElementType(arrayType);
    const structDef = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);
    assert(structDef instanceof CairoDynArray);

    const arrayInfo = this.dynArrayGen.gen(
      CairoType.fromSol(elementT, this.ast, TypeConversionContext.StorageAllocation),
    );
    const lenName = arrayInfo.name + '_LENGTH';
    const cairoElementType = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const copyCode = `${this.storageWriteGen.getOrCreate(elementT)}(elem_loc, elem[index]);`;

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const pointerType = `${cairoElementType.toString()}*`;

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(this.requireImport('warplib.maths.int_conversions', 'warp_uint256'));
    const funcName = `cd_dynamic_array_to_storage${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}_write${implicits}(loc : felt, index : felt, len : felt, elem: ${pointerType}){`,
      `   alloc_locals;`,
      `   if (index == len){`,
      `       return ();`,
      `   }`,
      `   let (index_uint256) = warp_uint256(index);`,
      `   let (elem_loc) = ${arrayInfo.name}.read(loc, index_uint256);`,
      `   if (elem_loc == 0){`,
      `       let (elem_loc) = WARP_USED_STORAGE.read();`,
      `       WARP_USED_STORAGE.write(elem_loc + ${cairoElementType.width});`,
      `       ${arrayInfo.name}.write(loc, index_uint256, elem_loc);`,
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
    this.generatedFunctions.set(key, funcInfo);

    return funcInfo;
  }

  private generateStructCopyInstructions(varTypes: TypeNode[], names: string[]): string[] {
    let offset = 0;
    const copyInstructions = varTypes.map((varType, index) => {
      const varCairoTypeWidth = CairoType.fromSol(
        varType,
        this.ast,
        TypeConversionContext.CallDataRef,
      ).width;

      const funcName = this.storageWriteGen.getOrCreate(varType);
      const location = add('loc', offset);

      offset += varCairoTypeWidth;

      return `    ${funcName}(${location}, ${names[index]});`;
    });

    return copyInstructions;
  }
}
