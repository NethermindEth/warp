import assert from 'assert';
import {
  ArrayType,
  MappingType,
  ASTNode,
  BytesType,
  DataLocation,
  FunctionCall,
  generalizeType,
  MemberAccess,
  SourceUnit,
  StringType,
  TypeNode,
  FunctionDefinition,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { typeNameFromTypeNode } from '../../utils/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { MemoryToStorageGen } from '../memory/memoryToStorage';
import { DynArrayGen } from './dynArray';
import { StorageWriteGen } from './storageWrite';
import { StorageToStorageGen } from './copyToStorage';
import { CalldataToStorageGen } from '../calldata/calldataToStorage';
import { Implicits } from '../../utils/implicits';
import {
  getElementType,
  isDynamicArray,
  safeGetNodeType,
  specializeType,
} from '../../utils/nodeTypeProcessing';
import { ImplicitArrayConversion } from '../calldata/implicitArrayConversion';

export class DynArrayPushWithArgGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageWrite: StorageWriteGen,
    private memoryToStorage: MemoryToStorageGen,
    private storageToStorage: StorageToStorageGen,
    private calldataToStorage: CalldataToStorageGen,
    private calldataToStorageConversion: ImplicitArrayConversion,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  gen(push: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(push.vExpression instanceof MemberAccess);
    const arrayType = generalizeType(
      safeGetNodeType(push.vExpression.vExpression, this.ast.inference),
    )[0];
    assert(
      arrayType instanceof ArrayType ||
        arrayType instanceof BytesType ||
        arrayType instanceof StringType,
    );

    assert(
      push.vArguments.length > 0,
      `Attempted to treat push without argument as push with argument`,
    );
    const [argType, argLoc] = generalizeType(
      safeGetNodeType(push.vArguments[0], this.ast.inference),
    );

    const funcInfo = this.getOrCreate(
      getElementType(arrayType),
      argType,
      argLoc ?? DataLocation.Default,
    );
    const implicits: Implicits[] =
      argLoc === DataLocation.Memory
        ? ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory']
        : ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'bitwise_ptr'];

    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage],
        ['value', typeNameFromTypeNode(argType, this.ast), argLoc ?? DataLocation.Default],
      ],
      [],
      implicits,
      this.ast,
      nodeInSourceUnit ?? push,
    );

    return createCallToFunction(
      funcDef,
      [push.vExpression.vExpression, push.vArguments[0]],
      this.ast,
    );
  }

  private getOrCreate(
    elementType: TypeNode,
    argType: TypeNode,
    argLoc: DataLocation,
  ): GeneratedFunctionInfo {
    const key = `${elementType.pp()}->${argType.pp()}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    let elementWriteFuncInfo: GeneratedFunctionInfo;
    let inputType: string;
    if (argLoc === DataLocation.Memory) {
      elementWriteFuncInfo = this.memoryToStorage.getOrCreate(elementType);
      inputType = 'felt';
    } else if (argLoc === DataLocation.Storage) {
      elementWriteFuncInfo = this.storageToStorage.getOrCreate(elementType, argType);
      inputType = 'felt';
    } else if (argLoc === DataLocation.CallData) {
      if (elementType.pp() !== argType.pp()) {
        // TODO: change get or create under calldata scripts to return GeneratedFunctionInfo
        elementWriteFuncInfo = this.calldataToStorageConversion.getOrCreate(
          specializeType(elementType, DataLocation.Storage),
          specializeType(argType, DataLocation.CallData),
        );
      } else {
        elementWriteFuncInfo = this.calldataToStorage.getOrCreate(elementType);
      }
      inputType = CairoType.fromSol(
        argType,
        this.ast,
        TypeConversionContext.CallDataRef,
      ).toString();
    } else {
      elementWriteFuncInfo = this.storageWrite.getOrCreate(elementType);
      inputType = CairoType.fromSol(elementType, this.ast).toString();
    }

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      ...elementWriteFuncInfo.functionsCalled,
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add'),
    );

    const allocationCairoType = CairoType.fromSol(
      elementType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const arrayInfo = this.dynArrayGen.gen(allocationCairoType);
    const lengthName = arrayInfo.name + '_LENGTH';
    const funcName = `${arrayInfo.name}_PUSHV${this.generatedFunctions.size}`;
    const implicits =
      argLoc === DataLocation.Memory
        ? '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory: DictAccess*}'
        : '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr: BitwiseBuiltin*}';

    const callWriteFunc = (cairoVar: string) =>
      isDynamicArray(argType) || argType instanceof MappingType
        ? [`let (elem_id) = readId(${cairoVar});`, `${elementWriteFuncInfo.name}(elem_id, value);`]
        : [`${elementWriteFuncInfo.name}(${cairoVar}, value);`];

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc: felt, value: ${inputType}) -> (){`,
        `    alloc_locals;`,
        `    let (len) = ${lengthName}.read(loc);`,
        `    let (newLen, carry) = uint256_add(len, Uint256(1,0));`,
        `    assert carry = 0;`,
        `    ${lengthName}.write(loc, newLen);`,
        `    let (existing) = ${arrayInfo.name}.read(loc, len);`,
        `    if (existing == 0){`,
        `        let (used) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(used + ${allocationCairoType.width});`,
        `        ${arrayInfo.name}.write(loc, len, used);`,
        ...callWriteFunc('used'),
        `    }else{`,
        ...callWriteFunc('existing'),
        `    }`,
        `    return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    this.generatedFunctions.set(key, funcInfo);

    return funcInfo;
  }
}
