import { AST } from '../../ast/ast';
import { MemberAccess, FunctionCall, DataLocation, generalizeType } from 'solc-typed-ast';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase } from '../base';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';

export class MemoryDynArrayLengthGen extends CairoUtilFuncGenBase {
  getGeneratedCode(): string {
    return '';
  }

  gen(node: MemberAccess, ast: AST): FunctionCall {
    const arrayType = generalizeType(safeGetNodeType(node.vExpression, ast.compilerVersion))[0];
    const arrayTypeName = typeNameFromTypeNode(arrayType, ast);
    // TODO: Check how this should be handled
    const functionStub = createCairoFunctionStub(
      'wm_dyn_array_length',
      [['arrayLoc', arrayTypeName, DataLocation.Memory]],
      [['len', createUint256TypeName(this.ast)]],
      ['warp_memory'],
      this.ast,
      node,
    );
    const call = createCallToFunction(functionStub, [node.vExpression], this.ast);
    this.ast.registerImport(call, 'warplib.memory', 'wm_dyn_array_length');
    return call;
  }
}
