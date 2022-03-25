import {
  Expression,
  ArrayTypeName,
  FunctionCall,
  typeNameToTypeNode,
  ASTNode,
} from 'solc-typed-ast';
import { CairoType } from '../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../utils/functionStubbing';
import { createUint256TypeName } from '../utils/nodeTemplates';
import { CairoFunction, CairoUtilFuncGenBase } from './base';

export class MemoryNewGen extends CairoUtilFuncGenBase {
  // element cairoType -> code
  private generatedFunctions: Map<string, CairoFunction> = new Map();

  getGeneratedCode(): string {
    return [...this.generatedFunctions.values()].map((func) => func.code).join('\n\n');
  }

  gen(len: Expression, arrayType: ArrayTypeName, nodeInSourceUnit?: ASTNode): FunctionCall {
    const elementCairoType = CairoType.fromSol(typeNameToTypeNode(arrayType.vBaseType), this.ast);
    const name = this.getOrCreate(elementCairoType);
    const functionStub = createCairoFunctionStub(
      name,
      [['len', createUint256TypeName(this.ast)]],
      [['arr', arrayType]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      nodeInSourceUnit ?? len,
    );
    return createCallToFunction(functionStub, [len], this.ast);
  }

  private getOrCreate(elementType: CairoType): string {
    const key = elementType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const name = `WM_NEW${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, {
      name,
      code: [
        `func ${name}{range_check_ptr, warp_memory: MemCell*}(len: Uint256) -> (name: felt):`,
        `    let (feltLength: Uint256, _) = uint256_mul(len, Uint256(${elementType.width}, 0))`,
        `    return warp_create_array(feltLength)`,
        'end',
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.uint256', 'uint256_mul');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('warplib.memory', 'MemCell');
    this.requireImport('warplib.memory', 'warp_create_array');
    return name;
  }
}
