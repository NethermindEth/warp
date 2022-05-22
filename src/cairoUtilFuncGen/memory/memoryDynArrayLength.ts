import { AST } from '../../ast/ast';
import {
  MemberAccess,
  FunctionCall,
  DataLocation,
  getNodeType,
  generalizeType,
} from 'solc-typed-ast';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase } from '../base';

export class MemoryDynArrayLengthGen extends CairoUtilFuncGenBase {
  getGeneratedCode(): string {
    return '';
  }

  gen(node: MemberAccess, ast: AST): FunctionCall {
    const arrayType = generalizeType(getNodeType(node.vExpression, ast.compilerVersion))[0];
    const arrayTypeName = typeNameFromTypeNode(arrayType, ast);
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
