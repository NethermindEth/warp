import { EnumDefinition, Expression, getNodeType, UserDefinedType } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { generateExpressionTypeString } from '../utils/getTypeString';

export class TypestringRegenerator extends ASTMapper {
  visitExpression(node: Expression, ast: AST): void {
    this.commonVisit(node, ast);
    const nType = getNodeType(node, ast.compilerVersion);
    if (nType instanceof UserDefinedType) {
      const tDef = nType.definition;
      if (tDef instanceof EnumDefinition) {
        node.typeString = generateExpressionTypeString(nType);
      }
    }
  }
}
