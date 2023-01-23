import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionDefinition,
  generalizeType,
  IntType,
  PointerType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { isDynamicStorageArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, CairoFunction, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { getBaseType } from '../memory/implicitConversion';
import { DynArrayGen } from '../storage/dynArray';
import { DynArrayIndexAccessGen } from '../storage/dynArrayIndexAccess';
import { StorageWriteGen } from '../storage/storageWrite';

export class ImplicitArrayConversion extends StringIndexedFuncGen {
  private genNode: Expression = new Expression(0, '', '');
  private genNodeInSourceUnit?: ASTNode;
  constructor(
    private storageWriteGen: StorageWriteGen,
    private dynArrayGen: DynArrayGen,
    private dynArrayIndexAccessGen: DynArrayIndexAccessGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  genIfNecessary(
    targetExpression: Expression,
    sourceExpression: Expression,
  ): [Expression, boolean] {
    const targetType = generalizeType(safeGetNodeType(targetExpression, this.ast.inference))[0];
    const sourceType = generalizeType(safeGetNodeType(sourceExpression, this.ast.inference))[0];

    if (this.checkDims(targetType, sourceType) || this.checkSizes(targetType, sourceType)) {
      return [this.gen(targetExpression, sourceExpression), true];
    } else {
      return [sourceExpression, false];
    }
  }

  checkSizes(targetType: TypeNode, sourceType: TypeNode): boolean {
    const targetBaseType = getBaseType(targetType);
    const sourceBaseType = getBaseType(sourceType);
    if (targetBaseType instanceof IntType && sourceBaseType instanceof IntType) {
      return (
        (targetBaseType.nBits > sourceBaseType.nBits && sourceBaseType.signed) ||
        (!targetBaseType.signed && targetBaseType.nBits === 256 && 256 > sourceBaseType.nBits)
      );
    }
    if (targetBaseType instanceof FixedBytesType && sourceBaseType instanceof FixedBytesType) {
      return targetBaseType.size > sourceBaseType.size;
    }
    return false;
  }

  checkDims(targetType: TypeNode, sourceType: TypeNode): boolean {
    const targetArray = generalizeType(targetType)[0];
    const sourceArray = generalizeType(sourceType)[0];

    if (targetArray instanceof ArrayType && sourceArray instanceof ArrayType) {
      const targetArrayElm = generalizeType(targetArray.elementT)[0];
      const sourceArrayElm = generalizeType(sourceArray.elementT)[0];

      if (targetArray.size !== undefined && sourceArray.size !== undefined) {
        if (targetArray.size > sourceArray.size) {
          return true;
        } else if (targetArrayElm instanceof ArrayType && sourceArrayElm instanceof ArrayType) {
          return this.checkDims(targetArrayElm, sourceArrayElm);
        } else {
          return false;
        }
      } else if (targetArray.size === undefined && sourceArray.size !== undefined) {
        return true;
      } else if (targetArray.size === undefined && sourceArray.size === undefined)
        if (targetArrayElm instanceof ArrayType && sourceArrayElm instanceof ArrayType) {
          return this.checkDims(targetArrayElm, sourceArrayElm);
        }
    }
    return false;
  }

  gen(lhs: Expression, rhs: Expression): FunctionCall {
    this.genNode = rhs;
    const lhsType = safeGetNodeType(lhs, this.ast.inference);
    const rhsType = safeGetNodeType(rhs, this.ast.inference);
    const funcDef = this.getOrCreateFuncDef(lhsType, rhsType);

    return createCallToFunction(
      funcDef,
      [cloneASTNode(lhs, this.ast), cloneASTNode(rhs, this.ast)],
      this.ast,
    );
  }

  getOrCreateFuncDef(targetType: TypeNode, sourceType: TypeNode) {
    const key = `implicitArrayConversion(${targetType.pp()},${sourceType.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(targetType, sourceType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['lhs', typeNameFromTypeNode(targetType, this.ast), DataLocation.Storage],
        ['rhs', typeNameFromTypeNode(sourceType, this.ast), DataLocation.CallData],
      ],
      [],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(targetType: TypeNode, sourceType: TypeNode): GeneratedFunctionInfo {
    const sourceRepForKey = CairoType.fromSol(
      generalizeType(sourceType)[0],
      this.ast,
      TypeConversionContext.CallDataRef,
    ).fullStringRepresentation;

    // Even though the target is in Storage, a unique key is needed to set the function.
    // Using Calldata here gives us the full representation instead of WarpId provided by Storage.
    // This is only for KeyGen and no further processing.
    const targetRepForKey = CairoType.fromSol(
      generalizeType(targetType)[0],
      this.ast,
      TypeConversionContext.CallDataRef,
    ).fullStringRepresentation;

    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    let funcInfo: GeneratedFunctionInfo;
    if (targetType.to.size === undefined && sourceType.to.size === undefined) {
      funcInfo = this.DynamicToDynamicConversion(targetType, sourceType);
    } else if (targetType.to.size === undefined && sourceType.to.size !== undefined) {
      funcInfo = this.staticToDynamicConversion(targetType, sourceType);
    } else {
      funcInfo = this.staticToStaticConversion(targetType, sourceType);
    }
    return funcInfo;
  }

  private staticToStaticConversion(
    targetType: TypeNode,
    sourceType: TypeNode,
  ): GeneratedFunctionInfo {
    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    const targetElmType = targetType.to.elementT;
    const sourceElmType = sourceType.to.elementT;

    const funcName = `CD_ST_TO_WS_ST${this.generatedFunctionsDef.size}`;
    const funcsCalled: FunctionDefinition[] = [];

    const cairoSourceType = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    assert(sourceType.to.size !== undefined);
    const sizeSource = narrowBigIntSafe(sourceType.to.size);

    const copyInstructions = this.generateS2SCopyInstructions(
      targetElmType,
      sourceElmType,
      sizeSource,
      funcsCalled,
    );

    const implicit =
      '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*}';
    const code = [
      `func ${funcName}${implicit}(storage_loc: felt, arg: ${cairoSourceType.toString()}){`,
      `alloc_locals;`,
      ...copyInstructions,
      '    return ();',
      '}',
    ].join('\n');
    this.addImports(targetElmType, sourceElmType);
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: code,
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private generateS2SCopyInstructions(
    targetElmType: TypeNode,
    sourceElmType: TypeNode,
    length: number,
    funcsCalled: FunctionDefinition[],
  ): string[] {
    const cairoTargetElementType = CairoType.fromSol(
      targetElmType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    let offset = 0;
    const instructions = mapRange(length, (index) => {
      let code;
      if (targetElmType instanceof IntType) {
        assert(sourceElmType instanceof IntType);
        if (targetElmType.nBits === sourceElmType.nBits) {
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          funcsCalled.push(writeDef);
          code = `     ${writeDef.name}(${add('storage_loc', offset)}, arg[${index}]);`;
        } else if (targetElmType.signed) {
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          code = [
            `    let (arg_${index}) = warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}(arg[${index}]);`,
            `${writeDef.name}(${add('storage_loc', offset)}, arg_${index});`,
          ].join('\n');
        } else {
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          code = [
            `    let (arg_${index}) = felt_to_uint256(arg[${index}]);`,
            `    ${writeDef.name}(${add('storage_loc', offset)}, arg_${index});`,
          ].join('\n');
        }
      } else if (
        targetElmType instanceof FixedBytesType &&
        sourceElmType instanceof FixedBytesType
      ) {
        if (targetElmType.size > sourceElmType.size) {
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          code = [
            `    let (arg_${index}) = warp_bytes_widen${
              targetElmType.size === 32 ? '_256' : ''
            }(arg[${index}], ${(targetElmType.size - sourceElmType.size) * 8});`,
            `    ${writeDef.name}(${add('storage_loc', offset)}, arg_${index});`,
          ].join('\n');
        } else {
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          code = `     ${writeDef.name}(${add('storage_loc', offset)}, arg[${index}]);`;
        }
      } else {
        if (isDynamicStorageArray(targetElmType)) {
          code = [
            `    let (ref_${index}) = readId(${add('storage_loc', offset)});`,
            `    ${this.getOrCreate(targetElmType, sourceElmType)}(ref_${index}, arg[${index}]);`,
          ].join('\n');
        } else {
          code = [
            `    ${this.getOrCreate(targetElmType, sourceElmType)}(${add(
              'storage_loc',
              offset,
            )}, arg[${index}]);`,
          ].join('\n');
        }
      }
      offset = offset + cairoTargetElementType.width;
      return code;
    });
    return instructions;
  }

  private staticToDynamicConversion(
    targetType: TypeNode,
    sourceType: TypeNode,
  ): GeneratedFunctionInfo {
    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    assert(targetType.to.size === undefined && sourceType.to.size !== undefined);

    const targetElmType = targetType.to.elementT;
    const sourceElmType = sourceType.to.elementT;

    const funcName = `CD_ST_TO_WS_DY${this.generatedFunctionsDef.size}`;
    const funcsCalled: FunctionDefinition[] = [];

    const cairoSourceType = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    const cairoSourceTypeString = cairoSourceType.toString();

    const sizeSource = narrowBigIntSafe(sourceType.to.size);

    assert(sizeSource !== undefined);

    const dynArrayDef = this.dynArrayGen.getOrCreateFuncDef(targetType.to.elementT);
    funcsCalled.push(dynArrayDef);
    const dynArrayLengthName = dynArrayDef.name + '_LENGTH';
    const copyInstructions = this.generateS2DCopyInstructions(
      targetElmType,
      sourceElmType,
      sizeSource,
      funcsCalled,
    );

    const implicit =
      '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*}';
    const code = [
      `func ${funcName}${implicit}(ref: felt, arg: ${cairoSourceTypeString}){`,
      `     alloc_locals;`,
      isDynamicStorageArray(targetType)
        ? `    ${dynArrayLengthName}.write(ref, ${uint256(sourceType.to.size)});`
        : '',
      ...copyInstructions,
      '    return ();',
      '}',
    ].join('\n');
    this.addImports(targetElmType, sourceElmType);
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: code,
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private generateS2DCopyInstructions(
    targetElmType: TypeNode,
    sourceElmType: TypeNode,
    length: number,
    funcsCalled: FunctionDefinition[],
  ): string[] {
    const instructions = mapRange(length, (index) => {
      if (targetElmType instanceof IntType) {
        assert(sourceElmType instanceof IntType);
        if (targetElmType.nBits === sourceElmType.nBits) {
          const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType);
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          funcsCalled.push(arrayDef, writeDef);
          return [
            `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `    ${writeDef}(storage_loc${index}, arg[${index}]);`,
          ].join('\n');
        } else if (targetElmType.signed) {
          const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType);
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          funcsCalled.push(arrayDef, writeDef);
          return [
            `    let (arg_${index}) = warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}(arg[${index}]);`,
            `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `    ${writeDef.name}(storage_loc${index}, arg_${index});`,
          ].join('\n');
        } else {
          const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType);
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          funcsCalled.push(arrayDef, writeDef);
          return [
            `    let (arg_${index}) = felt_to_uint256(arg[${index}]);`,
            `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `    ${writeDef.name}(storage_loc${index}, arg_${index});`,
          ].join('\n');
        }
      } else if (
        targetElmType instanceof FixedBytesType &&
        sourceElmType instanceof FixedBytesType
      ) {
        if (targetElmType.size > sourceElmType.size) {
          const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType);
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          funcsCalled.push(arrayDef, writeDef);
          return [
            `    let (arg_${index}) = warp_bytes_widen${
              targetElmType.size === 32 ? '_256' : ''
            }(arg[${index}], ${(targetElmType.size - sourceElmType.size) * 8});`,
            `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `    ${writeDef.name}(storage_loc${index}, arg_${index});`,
          ].join('\n');
        } else {
          const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType);
          const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
          funcsCalled.push(arrayDef, writeDef);
          return [
            `    let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `    ${writeDef.name}(storage_loc${index}, arg[${index}]);`,
          ].join('\n');
        }
      } else {
        if (isDynamicStorageArray(targetElmType)) {
          const dynArrayLengthName =
            this.dynArrayGen.getOrCreateFuncDef(targetElmType).name + '_LENGTH';
          const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType);
          funcsCalled.push(arrayDef);
          return [
            `     let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `     let (ref_${index}) = readId(storage_loc${index});`,
            `     ${dynArrayLengthName}.write(ref_${index}, ${uint256(length)});`,
            `     ${this.getOrCreate(targetElmType, sourceElmType)}(ref_${index}, arg[${index}]);`,
          ].join('\n');
        } else {
          const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType);
          funcsCalled.push(arrayDef);
          return [
            `     let (storage_loc${index}) = ${arrayDef.name}(ref, ${uint256(index)});`,
            `    ${this.getOrCreate(
              targetElmType,
              sourceElmType,
            )}(storage_loc${index}, arg[${index}]);`,
          ].join('\n');
        }
      }
    });
    return instructions;
  }

  private DynamicToDynamicConversion(
    targetType: TypeNode,
    sourceType: TypeNode,
  ): GeneratedFunctionInfo {
    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    assert(targetType.to.size === undefined && sourceType.to.size === undefined);

    const targetElmType = targetType.to.elementT;
    const sourceElmType = sourceType.to.elementT;

    const funcName = `CD_DY_TO_WS_DY${this.generatedFunctionsDef.size}`;
    const funcsCalled: FunctionDefinition[] = [];

    const cairoSourceType = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );
    assert(cairoSourceType instanceof CairoDynArray);

    const dynArrayDef = this.dynArrayGen.getOrCreateFuncDef(targetType.to.elementT);
    funcsCalled.push(dynArrayDef);
    const dynArrayLengthName = dynArrayDef.name + '_LENGTH';
    const implicit =
      '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*}';
    const loaderName = `DY_LOADER${this.generatedFunctionsDef.size}`;

    const copyInstructions = this.generateDynCopyInstructions(
      targetElmType,
      sourceElmType,
      funcsCalled,
    );

    const arrayDef = this.dynArrayIndexAccessGen.getOrCreateFuncDef(targetElmType);
    funcsCalled.push(arrayDef);
    const code = [
      `func ${loaderName}${implicit}(ref: felt, len: felt, ptr: ${cairoSourceType.ptr_member.toString()}*, target_index: felt){`,
      `    alloc_locals;`,
      `    if (len == 0){`,
      `      return ();`,
      `    }`,
      `    let (storage_loc) = ${arrayDef.name}(ref, Uint256(target_index, 0));`,
      copyInstructions,

      `    return ${loaderName}(ref, len - 1, ptr + ${cairoSourceType.ptr_member.width}, target_index+ 1 );`,
      `}`,
      ``,
      `func ${funcName}${implicit}(ref: felt, source: ${cairoSourceType.toString()}){`,
      `     alloc_locals;`,
      `    ${dynArrayLengthName}.write(ref, Uint256(source.len, 0));`,
      `    ${loaderName}(ref, source.len, source.ptr, 0);`,
      '    return ();',
      '}',
    ].join('\n');
    this.addImports(targetElmType, sourceElmType);
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: code,
      functionsCalled: [],
    };
    return funcInfo;
  }

  private generateDynCopyInstructions(
    targetElmType: TypeNode,
    sourceElmType: TypeNode,
    funcsCalled: FunctionDefinition[],
  ): string {
    if (sourceElmType instanceof IntType && targetElmType instanceof IntType) {
      const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
      funcsCalled.push(writeDef);
      return [
        sourceElmType.signed
          ? `    let (val) = warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}(ptr[0]);`
          : `    let (val) = felt_to_uint256(ptr[0]);`,
        `    ${writeDef.name}(storage_loc, val);`,
      ].join('\n');
    } else if (targetElmType instanceof FixedBytesType && sourceElmType instanceof FixedBytesType) {
      const writeDef = this.storageWriteGen.getOrCreateFuncDef(targetElmType);
      funcsCalled.push(writeDef);
      return [
        targetElmType.size === 32
          ? `    let (val) = warp_bytes_widen_256(ptr[0], ${
              (targetElmType.size - sourceElmType.size) * 8
            });`
          : `    let (val) = warp_bytes_widen(ptr[0], ${
              (targetElmType.size - sourceElmType.size) * 8
            });`,
        `    ${writeDef.name}(storage_loc, val);`,
      ].join('\n');
    } else {
      return isDynamicStorageArray(targetElmType)
        ? `    let (ref_name) = readId(storage_loc);
          ${this.getOrCreate(targetElmType, sourceElmType)}(ref_name, ptr[0]);`
        : `    ${this.getOrCreate(targetElmType, sourceElmType)}(storage_loc, ptr[0]);`;
    }
  }

  addImports(targetElmType: TypeNode, sourceElmType: TypeNode): void {
    if (targetElmType instanceof IntType) {
      assert(sourceElmType instanceof IntType);
      if (targetElmType.nBits > sourceElmType.nBits && targetElmType.signed) {
        this.requireImport(
          'warplib.maths.int_conversions',
          `warp_int${sourceElmType.nBits}_to_int${targetElmType.nBits}`,
        );
      } else {
        this.requireImport('warplib.maths.utils', 'felt_to_uint256');
      }
    } else if (targetElmType instanceof FixedBytesType) {
      this.requireImport(
        'warplib.maths.bytes_conversions',
        targetElmType.size === 32 ? 'warp_bytes_widen_256' : 'warp_bytes_widen',
      );
    }
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
  }
}
