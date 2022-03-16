import assert = require('assert');
import { IndexAccess, Expression, FunctionCall, getNodeType, ASTNode } from 'solc-typed-ast';
import { CairoType } from '../utils/cairoTypeSystem';
import { cloneASTNode } from '../utils/cloning';
import { createCairoFunctionStub, createCallToStub } from '../utils/functionStubbing';
import { createUint256TypeName } from '../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../utils/utils';
import { CairoFunction, CairoUtilFuncGenBase } from './base';

export class MemoryWriteGen extends CairoUtilFuncGenBase {
  // writeType -> code
  private generatedFunctions: Map<string, CairoFunction> = new Map();

  getGeneratedCode(): string {
    return [...this.generatedFunctions.values()].map((func) => func.code).join('\n\n');
  }

  gen(indexAccess: IndexAccess, writeValue: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const index = indexAccess.vIndexExpression;
    assert(index !== undefined);
    const assignedType = getNodeType(indexAccess, this.ast.compilerVersion);
    const assignedTypeName = typeNameFromTypeNode(assignedType, this.ast);
    const assignedCairoType = CairoType.fromSol(assignedType, this.ast);
    const name = this.getOrCreate(assignedCairoType);
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
        ['value', assignedTypeName],
      ],
      [['assignedValue', cloneASTNode(assignedTypeName, this.ast)]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      nodeInSourceUnit ?? indexAccess,
    );
    return createCallToStub(
      functionStub,
      [indexAccess.vBaseExpression, index, writeValue],
      this.ast,
    );
  }

  private getOrCreate(assignedCairoType: CairoType): string {
    const key = assignedCairoType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const name = `WM_WRITE${this.generatedFunctions.size}`;
    const valueTypeString = assignedCairoType.toString();
    const width = assignedCairoType.width;
    this.generatedFunctions.set(key, {
      name,
      code: [
        `func ${name}{range_check_ptr, warp_memory: MemCell*}(name: felt, index: Uint256, value: ${valueTypeString}) -> (val: ${valueTypeString}):`,
        ...assignedCairoType
          .serialiseMembers('value')
          .map((value, offset) =>
            [
              `    let (cell: Uint256) = warp_idx(index, ${width}, ${offset})`,
              `    warp_memory_write(name, cell, ${value})`,
            ].join('\n'),
          ),
        `    return (value)`,
        'end',
      ].join('\n'),
    });
    this.requireImport('warplib.memory', 'MemCell');
    this.requireImport('warplib.memory', 'warp_idx');
    this.requireImport('warplib.memory', 'warp_memory_write');
    return name;
  }
}
