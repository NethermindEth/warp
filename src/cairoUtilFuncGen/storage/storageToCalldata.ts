import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
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
import { ExternalDynArrayStructConstructor } from '../calldata/externalDynArray/externalDynArrayStructConstructor';
import { DynArrayGen } from './dynArray';
import { StorageReadGen } from './storageRead';

export class StorageToCalldataGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageReadGen: StorageReadGen,
    private externalDynArrayStructConstructor: ExternalDynArrayStructConstructor,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  gen(storageLocation: Expression) {
    const storageType = generalizeType(safeGetNodeType(storageLocation, this.ast.inference))[0];

    const funcInfo = this.getOrCreate(storageType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', typeNameFromTypeNode(storageType, this.ast), DataLocation.Storage]],
      [['obj', typeNameFromTypeNode(storageType, this.ast), DataLocation.CallData]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      storageLocation,
    );

    return createCallToFunction(funcDef, [storageLocation], this.ast);
  }

  private getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from storage to calldata is not supported yet`,
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

    const [copyInstructions, members] = this.generateStructCopyInstructions(
      structDef.vMembers.map((varDecl) => safeGetNodeType(varDecl, this.ast.inference)),
      'member',
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `ws_struct_${cairoStruct.toString()}_to_calldata`;
    const code = [
      `func ${funcName}${implicits}(loc : felt) -> (${structName} : ${cairoStruct.toString()}){`,
      `   alloc_locals;`,
      ...copyInstructions,
      `   return (${cairoStruct.toString()}(${members.join(', ')}),);`,
      `}`,
    ].join('\n');

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: code,
      functionsCalled: [],
    };
    this.generatedFunctions.set(key, funcInfo);

    return funcInfo;
  }

  private createStaticArrayCopyFunction(key: string, arrayType: ArrayType): GeneratedFunctionInfo {
    assert(arrayType.size !== undefined);

    const cairoType = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);

    const [copyInstructions, members] = this.generateStructCopyInstructions(
      mapRange(narrowBigIntSafe(arrayType.size), () => arrayType.elementT),
      'elem',
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `ws_static_array_to_calldata${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${implicits}(loc : felt) -> (static_array : ${cairoType.toString()}){`,
      `    alloc_locals;`,
      ...copyInstructions,
      `    return ((${members.join(', ')}),);`,
      `}`,
    ].join('\n');

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: code,
      functionsCalled: [],
    };
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

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('warplib.maths.int_conversions', 'warp_uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.alloc', 'alloc'),
    );

    this.externalDynArrayStructConstructor.getOrCreate(arrayType);
    const arrayInfo = this.dynArrayGen.gen(
      CairoType.fromSol(elementT, this.ast, TypeConversionContext.StorageAllocation),
    );
    const arrayLen = arrayInfo.name + '_LENGTH';
    const cairoElementType = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const ptrType = `${cairoElementType.toString()}*`;
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    const funcName = `ws_dynamic_array_to_calldata${this.generatedFunctions.size}`;
    const storageReadInfo = this.storageReadGen.genFuncName(elementT);
    funcsCalled.push(...storageReadInfo.functionsCalled);
    const code = [
      `func ${funcName}_write${implicits}(`,
      `   loc : felt,`,
      `   index : felt,`,
      `   len : felt,`,
      `   ptr : ${ptrType}) -> (ptr : ${ptrType}){`,
      `   alloc_locals;`,
      `   if (len == index){`,
      `       return (ptr,);`,
      `   }`,
      `   let (index_uint256) = warp_uint256(index);`,
      `   let (elem_loc) = ${arrayInfo.name}.read(loc, index_uint256);`, // elem_loc should never be zero
      `   let (elem) = ${storageReadInfo.name}(elem_loc);`,
      `   assert ptr[index] = elem;`,
      `   return ${funcName}_write(loc, index + 1, len, ptr);`,
      `}`,

      `func ${funcName}${implicits}(loc : felt) -> (dyn_array_struct : ${structDef.name}){`,
      `   alloc_locals;`,
      `   let (len_uint256) = ${arrayLen}.read(loc);`,
      `   let len = len_uint256.low + len_uint256.high*128;`,
      `   let (ptr : ${ptrType}) = alloc();`,
      `   let (ptr : ${ptrType}) = ${funcName}_write(loc, 0, len, ptr);`,
      `   let dyn_array_struct = ${structDef.name}(len, ptr);`,
      `   return (dyn_array_struct,);`,
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

  private generateStructCopyInstructions(
    varDeclarations: TypeNode[],
    tempVarName: string,
  ): [string[], string[]] {
    const members: string[] = [];
    let offset = 0;
    const copyInstructions = varDeclarations.map((varType, index) => {
      const varCairoTypeWidth = CairoType.fromSol(
        varType,
        this.ast,
        TypeConversionContext.CallDataRef,
      ).width;

      const funcName = this.storageReadGen.genFuncName(varType);
      const location = add('loc', offset);
      const memberName = `${tempVarName}_${index}`;

      members.push(memberName);
      offset += varCairoTypeWidth;

      return `    let (${memberName}) = ${funcName}(${location});`;
    });

    return [copyInstructions, members];
  }
}
