import assert = require('assert');
import { IndexAccess, FunctionCall, getNodeType, ASTNode } from 'solc-typed-ast';
import { CairoType } from '../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToStub } from '../utils/functionStubbing';
import { createUint256TypeName } from '../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../utils/utils';
import { CairoFunction, CairoUtilFuncGenBase } from './base';
import { serialiseReads } from './serialisation';

export class MemoryReadGen extends CairoUtilFuncGenBase {
  // readType -> code
  private generatedFunctions: Map<string, CairoFunction> = new Map();

  // Concatenate all the generated cairo code into a single string
  getGeneratedCode(): string {
    return [...this.generatedFunctions.values()].map((func) => func.code).join('\n\n');
  }

  gen(indexAccess: IndexAccess, nodeInSourceUnit?: ASTNode): FunctionCall {
    const index = indexAccess.vIndexExpression;
    assert(index !== undefined);
    const cairoTypeToRead = CairoType.fromSol(
      getNodeType(indexAccess, this.ast.compilerVersion),
      this.ast,
    );
    const name = this.getOrCreate(cairoTypeToRead);
    const functionStub = createCairoFunctionStub(
      name,
      [
        [
          'name',
          typeNameFromTypeNode(
            getNodeType(indexAccess.vBaseExpression, this.ast.compilerVersion),
            this.ast,
          ),
        ],
        ['index', createUint256TypeName(this.ast)],
      ],
      [['val', typeNameFromTypeNode(getNodeType(indexAccess, this.ast.compilerVersion), this.ast)]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      nodeInSourceUnit ?? indexAccess,
    );
    return createCallToStub(functionStub, [indexAccess.vBaseExpression, index], this.ast);
  }

  private getOrCreate(typeToRead: CairoType): string {
    const key = typeToRead.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `WM_READ${this.generatedFunctions.size}`;
    // TODO check whether IDs are needed to be separate from felts in memory
    const readFunc = readFelt(typeToRead.width);
    const [reads, pack] = serialiseReads(typeToRead, readFunc, readFunc);
    const resultCairoType = typeToRead.toString();
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory: MemCell*}(name: felt, offset: Uint256) ->(val: ${resultCairoType}):`,
        `    alloc_locals`,
        ...reads,
        `    return (${pack})`,
        'end',
      ].join('\n'),
    });
    this.requireImport('warplib.memory', 'MemCell');
    this.requireImport('warplib.memory', 'warp_idx');
    this.requireImport('warplib.memory', 'warp_memory_read');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    return funcName;
  }
}

function readFelt(width: number): (offset: number) => string {
  return (offset: number) => {
    return [
      `    let (idx) = warp_idx(offset, ${width}, ${offset})`,
      `    let (read${offset}) = warp_memory_read(warp_memory, name, idx)`,
    ].join('\n');
  };
}
