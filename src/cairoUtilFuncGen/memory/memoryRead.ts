import {
  Expression,
  TypeName,
  ASTNode,
  FunctionCall,
  getNodeType,
  DataLocation,
  FunctionStateMutability,
  generalizeType,
  ArrayType,
} from 'solc-typed-ast';
import { CairoFelt, CairoType, CairoUint256, MemoryLocation } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import {
  createNumberLiteral,
  createNumberTypeName,
  createUint256TypeName,
} from '../../utils/nodeTemplates';
import { add, locationIfComplexType, StringIndexedFuncGen } from '../base';
import { serialiseReads } from '../serialisation';

/*
  Produces functions that when given a start location in warp_memory, deserialise all necessary
  felts to produce a full value. For example, a function to read a Uint256 reads the given location
  and the next one, and combines them into a Uint256 struct
*/

export class MemoryReadGen extends StringIndexedFuncGen {
  gen(memoryRef: Expression, type: TypeName, nodeInSourceUnit?: ASTNode): FunctionCall {
    const valueType = generalizeType(getNodeType(memoryRef, this.ast.compilerVersion))[0];
    const resultCairoType = CairoType.fromSol(valueType, this.ast);

    const params: [string, TypeName, DataLocation][] = [
      ['loc', cloneASTNode(type, this.ast), DataLocation.Memory],
    ];
    const args = [memoryRef];

    if (resultCairoType instanceof MemoryLocation) {
      params.push(['size', createNumberTypeName(8, false, this.ast), DataLocation.Default]);
      args.push(
        createNumberLiteral(
          valueType instanceof ArrayType && valueType.size === undefined
            ? 2
            : resultCairoType.width,
          this.ast,
          'uint256',
        ),
      );
    }

    const name = this.getOrCreate(resultCairoType);
    const functionStub = createCairoFunctionStub(
      name,
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
      FunctionStateMutability.View,
    );

    return createCallToFunction(functionStub, args, this.ast);
  }

  getOrCreate(typeToRead: CairoType): string {
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
      return existing.name;
    }

    const funcName = `WM${this.generatedFunctions.size}_READ_${typeToRead.typeName}`;
    const resultCairoType = typeToRead.toString();
    const [reads, pack] = serialiseReads(typeToRead, readFelt, readFelt);
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory : DictAccess*}(loc: felt) ->(val: ${resultCairoType}):`,
        `    alloc_locals`,
        ...reads.map((s) => `    ${s}`),
        `    return (${pack})`,
        'end',
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.dict', 'dict_read');
    return funcName;
  }
}

function readFelt(offset: number): string {
  return `let (read${offset}) = dict_read{dict_ptr=warp_memory}(${add('loc', offset)})`;
}
