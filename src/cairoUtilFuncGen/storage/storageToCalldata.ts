import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
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

  public gen(storageLocation: Expression) {
    const storageType = generalizeType(safeGetNodeType(storageLocation, this.ast.inference))[0];

    const funcDef = this.getOrCreateFuncDef(storageType);
    return createCallToFunction(funcDef, [storageLocation], this.ast);
  }

  public getOrCreateFuncDef(type: TypeNode) {
    const key = type.pp();
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }
    const funcInfo = this.getOrCreate(type);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      [['obj', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from storage to calldata is not supported yet`,
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

    const structName = `struct_${cairoStruct.toString()}`;

    const [copyInstructions, members, funcsCalled] = this.generateStructCopyInstructions(
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
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private createStaticArrayCopyFunction(arrayType: ArrayType): GeneratedFunctionInfo {
    assert(arrayType.size !== undefined);

    const cairoType = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);

    const [copyInstructions, members, funcsCalled] = this.generateStructCopyInstructions(
      mapRange(narrowBigIntSafe(arrayType.size), () => arrayType.elementT),
      'elem',
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `ws_static_array_to_calldata${this.generatedFunctionsDef.size}`;
    const code = [
      `func ${funcName}${implicits}(loc : felt) -> (static_array : ${cairoType.toString()}){`,
      `    alloc_locals;`,
      ...copyInstructions,
      `    return ((${members.join(', ')}),);`,
      `}`,
    ].join('\n');

    return {
      name: funcName,
      code: code,
      functionsCalled: funcsCalled,
    };
  }

  private createDynamicArrayCopyFunction(
    arrayType: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const elementT = getElementType(arrayType);
    const structDef = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);
    assert(structDef instanceof CairoDynArray);

    const storageReadFunc = this.storageReadGen.getOrCreateFuncDef(elementT);
    const sturctDynArray = this.externalDynArrayStructConstructor.getOrCreateFuncDef(arrayType);
    const [dynArray, dynArrayLength] = this.dynArrayGen.getOrCreateFuncDef(elementT);

    const arrayName = dynArray.name;
    const lenName = dynArrayLength.name;
    const cairoElementType = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const ptrType = `${cairoElementType.toString()}*`;
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    const funcName = `ws_dynamic_array_to_calldata${this.generatedFunctionsDef.size}`;
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
      `   let (elem_loc) = ${arrayName}.read(loc, index_uint256);`, // elem_loc should never be zero
      `   let (elem) = ${storageReadFunc.name}(elem_loc);`,
      `   assert ptr[index] = elem;`,
      `   return ${funcName}_write(loc, index + 1, len, ptr);`,
      `}`,

      `func ${funcName}${implicits}(loc : felt) -> (dyn_array_struct : ${structDef.name}){`,
      `   alloc_locals;`,
      `   let (len_uint256) = ${lenName}.read(loc);`,
      `   let len = len_uint256.low + len_uint256.high*128;`,
      `   let (ptr : ${ptrType}) = alloc();`,
      `   let (ptr : ${ptrType}) = ${funcName}_write(loc, 0, len, ptr);`,
      `   let dyn_array_struct = ${structDef.name}(len, ptr);`,
      `   return (dyn_array_struct,);`,
      `}`,
    ].join('\n');

    const importedFuncs = [
      this.requireImport('warplib.maths.int_conversions', 'warp_uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.alloc', 'alloc'),
    ];

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: code,
      functionsCalled: [
        ...importedFuncs,
        sturctDynArray,
        dynArray,
        dynArrayLength,
        storageReadFunc,
      ],
    };
    return funcInfo;
  }

  // TODO: static arrays functions are going to be huge with big size. We should build
  // a copy function for them instead of reusing structs
  private generateStructCopyInstructions(
    varDeclarations: TypeNode[],
    tempVarName: string,
  ): [string[], string[], CairoFunctionDefinition[]] {
    const [members, copyInstructions, funcsCalled] = varDeclarations.reduce(
      ([members, copyInstructions, funcsCalled, offset], varType, index) => {
        const varCairoTypeWidth = CairoType.fromSol(
          varType,
          this.ast,
          TypeConversionContext.CallDataRef,
        ).width;

        const readFunc = this.storageReadGen.getOrCreateFuncDef(varType);
        const location = add('loc', offset);
        const memberName = `${tempVarName}_${index}`;

        const instruction = `    let (${memberName}) = ${readFunc.name}(${location});`;

        return [
          [...members, memberName],
          [...copyInstructions, instruction],
          [...funcsCalled, readFunc],
          offset + varCairoTypeWidth,
        ];
      },
      [new Array<string>(), new Array<string>(), new Array<CairoFunctionDefinition>(), 0],
    );

    return [copyInstructions, members, funcsCalled];
  }
}
