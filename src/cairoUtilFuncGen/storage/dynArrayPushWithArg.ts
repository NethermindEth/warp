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
  Expression,
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
import { Func } from 'mocha';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes/cairoGeneratedFunctionDefinition';

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

  gen(push: FunctionCall): FunctionCall {
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

    const funcDef = this.getOrCreateFuncDef(arrayType, argType, argLoc);
    return createCallToFunction(
      funcDef,
      [push.vExpression.vExpression, push.vArguments[0]],
      this.ast,
    );
  }

  getOrCreateFuncDef(arrayType: TypeNode, argType: TypeNode, argLoc: DataLocation | undefined) {
    const key = `dynArrayPushWithArg(${arrayType.pp()},${argType.pp()},${argLoc})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(
      getElementType(arrayType),
      argType,
      argLoc ?? DataLocation.Default,
    );
    // const implicits: Implicits[] =
    //   argLoc === DataLocation.Memory
    //     ? ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory']
    //     : ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'bitwise_ptr'];

    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage],
        ['value', typeNameFromTypeNode(argType, this.ast), argLoc ?? DataLocation.Default],
      ],
      [],
      // implicits,
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
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

    let elementWriteDef: FunctionDefinition;
    let inputType: string;
    if (argLoc === DataLocation.Memory) {
      elementWriteDef = this.memoryToStorage.getOrCreateFuncDef(elementType);
      inputType = 'felt';
    } else if (argLoc === DataLocation.Storage) {
      elementWriteDef = this.storageToStorage.getOrCreateFuncDef(elementType, argType);
      inputType = 'felt';
    } else if (argLoc === DataLocation.CallData) {
      if (elementType.pp() !== argType.pp()) {
        elementWriteDef = this.calldataToStorageConversion.getOrCreateFuncDef(
          specializeType(elementType, DataLocation.Storage),
          specializeType(argType, DataLocation.CallData),
        );
      } else {
        elementWriteDef = this.calldataToStorage.getOrCreateFuncDef(elementType, argType);
      }
      inputType = CairoType.fromSol(
        argType,
        this.ast,
        TypeConversionContext.CallDataRef,
      ).toString();
    } else {
      elementWriteDef = this.storageWrite.getOrCreateFuncDef(elementType);
      inputType = CairoType.fromSol(elementType, this.ast).toString();
    }

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      elementWriteDef,
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add'),
    );

    const allocationCairoType = CairoType.fromSol(
      elementType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const arrayDef = this.dynArrayGen.getOrCreateFuncDef(elementType);
    const arrayName = arrayDef.name;
    const lengthName = arrayName + '_LENGTH';
    const funcName = `${arrayName}_PUSHV${this.generatedFunctions.size}`;
    const implicits =
      argLoc === DataLocation.Memory
        ? '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory: DictAccess*}'
        : '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr: BitwiseBuiltin*}';

    const callWriteFunc = (cairoVar: string) =>
      isDynamicArray(argType) || argType instanceof MappingType
        ? [`let (elem_id) = readId(${cairoVar});`, `${elementWriteDef.name}(elem_id, value);`]
        : [`${elementWriteDef.name}(${cairoVar}, value);`];

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc: felt, value: ${inputType}) -> (){`,
        `    alloc_locals;`,
        `    let (len) = ${lengthName}.read(loc);`,
        `    let (newLen, carry) = uint256_add(len, Uint256(1,0));`,
        `    assert carry = 0;`,
        `    ${lengthName}.write(loc, newLen);`,
        `    let (existing) = ${arrayName}.read(loc, len);`,
        `    if (existing == 0){`,
        `        let (used) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(used + ${allocationCairoType.width});`,
        `        ${arrayName}.write(loc, len, used);`,
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
