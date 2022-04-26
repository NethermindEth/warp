import {
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  getNodeType,
  TypeNode,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { typeNameFromTypeNode, mapRange } from '../../utils/utils';
import { add, StringIndexedFuncGen } from '../base';

export class StorageDeleteGen extends StringIndexedFuncGen {
  gen(node: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const nodeType = getNodeType(node, this.ast.compilerVersion);
    const functionName = this.getOrCreate(nodeType);

    const functionStub = createCairoFunctionStub(
      functionName,
      [['loc', typeNameFromTypeNode(nodeType, this.ast), DataLocation.Storage]],
      [],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
    );

    return createCallToFunction(functionStub, [node], this.ast);
  }

  private getOrCreate(type: TypeNode): string {
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation);
    const key = cairoType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `WS${this.generatedFunctions.size}_DELETE`;

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> ():`,
        ...mapRange(cairoType.width, (n) => `    WARP_STORAGE.write(${add('loc', n)}, 0)`),
        `    return ()`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }
}
