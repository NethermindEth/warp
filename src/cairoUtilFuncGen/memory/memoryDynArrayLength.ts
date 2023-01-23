import { AST } from '../../ast/ast';
import { MemberAccess, FunctionCall, DataLocation, generalizeType } from 'solc-typed-ast';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase, StringIndexedFuncGen } from '../base';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';

export class MemoryDynArrayLengthGen extends StringIndexedFuncGen {
  getGeneratedCode(): string {
    return '';
  }

  gen(node: MemberAccess, ast: AST): FunctionCall {
    // const arrayType = generalizeType(safeGetNodeType(node.vExpression, ast.inference))[0];
    // const arrayTypeName = typeNameFromTypeNode(arrayType, ast);
    // const functionStub = createCairoFunctionStub(
    //   'wm_dyn_array_length',
    //   [['arrayLoc', arrayTypeName, DataLocation.Memory]],
    //   [['len', createUint256TypeName(this.ast)]],
    //   ['warp_memory'],
    //   this.ast,
    //   node,
    // );
    const funcDef = this.getOrCreateFuncGen();
    const call = createCallToFunction(funcDef, [node.vExpression], this.ast);
    return call;
  }

  getOrCreateFuncGen() {
    const funcDef = this.requireImport('warplib.memory', 'wm_dyn_array_length');
    return funcDef;
  }
}
