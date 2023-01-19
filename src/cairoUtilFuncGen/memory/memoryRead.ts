import {
  Expression,
  TypeName,
  ASTNode,
  FunctionCall,
  DataLocation,
  FunctionStateMutability,
  generalizeType,
  FunctionDefinition,
  TypeNode,
} from 'solc-typed-ast';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes/cairoGeneratedFunctionDefinition';
import { typeNameFromTypeNode } from '../../export';
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
  gen(memoryRef: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const valueType = generalizeType(safeGetNodeType(memoryRef, this.ast.inference))[0];
    const resultCairoType = CairoType.fromSol(valueType, this.ast);

    const args = [memoryRef];

    if (resultCairoType instanceof MemoryLocation) {
      // The size parameter represents how much space to allocate
      // for the contents of the newly accessed suboject
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
    const funcDef = this.getOrCreateFuncDef(valueType);
    return createCallToFunction(funcDef, args, this.ast);
  }

  getOrCreateFuncDef(typeToRead: TypeNode) {
    const typeToReadName = typeNameFromTypeNode(typeToRead, this.ast);
    const resultCairoType = CairoType.fromSol(typeToRead, this.ast);
    let funcDef: FunctionDefinition;
    if (resultCairoType instanceof MemoryLocation) {
      funcDef = this.requireImport('warplib.memory', 'wm_read_id');
    } else if (resultCairoType instanceof CairoFelt) {
      funcDef = this.requireImport('warplib.memory', 'wm_read_felt');
    } else if (resultCairoType.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
      funcDef = this.requireImport('warplib.memory', 'wm_read_256');
    } else {
      const params: [string, TypeName, DataLocation][] = [
        ['loc', cloneASTNode(typeToReadName, this.ast), DataLocation.Memory],
      ];
      if (resultCairoType instanceof MemoryLocation) {
        params.push(['size', createNumberTypeName(256, false, this.ast), DataLocation.Default]);
      }
      const funcInfo = this.getOrCreate(resultCairoType);
      funcDef = createCairoGeneratedFunction(
        funcInfo,
        params,
        [
          [
            'val',
            cloneASTNode(typeToReadName, this.ast),
            locationIfComplexType(typeToRead, DataLocation.Memory),
          ],
        ],
        ['range_check_ptr', 'warp_memory'],
        this.ast,
        this.sourceUnit,
        { mutability: FunctionStateMutability.View },
      );
    }
    return funcDef;
  }
  getOrCreate(typeToRead: CairoType): GeneratedFunctionInfo {
    const funcsCalled: FunctionDefinition[] = [];

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
