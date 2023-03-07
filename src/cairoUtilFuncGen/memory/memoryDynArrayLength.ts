import { AST } from '../../ast/ast';
import { MemberAccess, FunctionCall, DataLocation, generalizeType } from 'solc-typed-ast';
import { createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { CairoUtilFuncGenBase } from '../base';
import { DYN_ARRAY_LENGTH } from '../../utils/importPaths';

export class MemoryDynArrayLengthGen extends CairoUtilFuncGenBase {
  gen(node: MemberAccess, ast: AST): FunctionCall {
    const arrayType = generalizeType(safeGetNodeType(node.vExpression, ast.inference))[0];
    const arrayTypeName = typeNameFromTypeNode(arrayType, ast);
    const funcDef = this.requireImport(
      ...DYN_ARRAY_LENGTH,
      [['arrayLoc', arrayTypeName, DataLocation.Memory]],
      [['len', createUint256TypeName(this.ast)]],
    );
    return createCallToFunction(funcDef, [node.vExpression], this.ast);
  }
}
