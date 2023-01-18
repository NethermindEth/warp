import {
  Expression,
  TypeName,
  ASTNode,
  FunctionCall,
  DataLocation,
  FunctionStateMutability,
  generalizeType,
  FunctionDefinition,
} from 'solc-typed-ast';
import {
  CairoFelt,
  CairoType,
  CairoUint256,
  MemoryLocation,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { createNumberLiteral, createNumberTypeName } from '../../utils/nodeTemplates';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { add, GeneratedFunctionInfo, locationIfComplexType, StringIndexedFuncGen } from '../base';
import { serialiseReads } from '../serialisation';

/*
  Produces functions that when given a start location in warp_memory, deserialise all necessary
  felts to produce a full value. For example, a function to read a Uint256 reads the given location
  and the next one, and combines them into a Uint256 struct
*/

export class MemoryReadGen extends StringIndexedFuncGen {
  gen(memoryRef: Expression, type: TypeName, nodeInSourceUnit?: ASTNode): FunctionCall {
    const valueType = generalizeType(safeGetNodeType(memoryRef, this.ast.inference))[0];
    const resultCairoType = CairoType.fromSol(valueType, this.ast);

    const params: [string, TypeName, DataLocation][] = [
      ['loc', cloneASTNode(type, this.ast), DataLocation.Memory],
    ];
    const args = [memoryRef];

    if (resultCairoType instanceof MemoryLocation) {
      // The size parameter represents how much space to allocate
      // for the contents of the newly accessed suboject
      params.push(['size', createNumberTypeName(256, false, this.ast), DataLocation.Default]);
      args.push(
        createNumberLiteral(
          isDynamicArray(valueType)
            ? 2
            : CairoType.fromSol(valueType, this.ast, TypeConversionContext.MemoryAllocation).width,
          this.ast,
          'uint256',
        ),
      );
    }

    const funcInfo = this.getOrCreate(resultCairoType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      params,
      [
        [
          'val',
          cloneASTNode(type, this.ast),
          locationIfComplexType(valueType, DataLocation.Memory),
        ],
      ],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      nodeInSourceUnit ?? memoryRef,
      { mutability: FunctionStateMutability.View },
    );

    return createCallToFunction(funcDef, args, this.ast);
  }

  getOrCreate(typeToRead: CairoType): GeneratedFunctionInfo {
    const funcsCalled: FunctionDefinition[] = [];

    // TODO: This cases need to be handled
    if (typeToRead instanceof MemoryLocation) {
      this.requireImport('warplib.memory', 'wm_read_id');
      return 'wm_read_id';
    } else if (typeToRead instanceof CairoFelt) {
      this.requireImport('warplib.memory', 'wm_read_felt');
      return 'wm_read_felt';
    } else if (typeToRead.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
      this.requireImport('warplib.memory', 'wm_read_256');
      return 'wm_read_256';
    }

    const key = typeToRead.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    funcsCalled.push(this.requireImport('starkware.cairo.common.dict', 'dict_read'));
    const funcName = `WM${this.generatedFunctions.size}_READ_${typeToRead.typeName}`;
    const resultCairoType = typeToRead.toString();
    const [reads, pack] = serialiseReads(typeToRead, readFelt, readFelt);
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(loc: felt) ->(val: ${resultCairoType}){`,
        `    alloc_locals;`,
        ...reads.map((s) => `    ${s}`),
        `    return (${pack},);`,
        '}',
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    this.generatedFunctions.set(key, funcInfo);
    return funcInfo;
  }
}

function readFelt(offset: number): string {
  return `let (read${offset}) = dict_read{dict_ptr=warp_memory}(${add('loc', offset)});`;
}
