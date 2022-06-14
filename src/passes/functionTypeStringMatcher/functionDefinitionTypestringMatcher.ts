import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import {
  FunctionCallKind,
  ExternalReferenceType,
  FunctionCall,
  FunctionDefinition,
  PointerType,
  getNodeType,
  FunctionType,
  VariableDeclaration,
} from 'solc-typed-ast';

export class FunctionDefinitionMatcher extends ASTMapper {
  constructor(private declarations: Map<VariableDeclaration, boolean>) {
    super();
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const functionNodeType = getNodeType(node.vExpression, ast.compilerVersion);
    if (
      node.vArguments.length === 0 ||
      node.kind === FunctionCallKind.TypeConversion ||
      node.vFunctionCallType === ExternalReferenceType.Builtin ||
      !(node.vReferencedDeclaration instanceof FunctionDefinition) ||
      !(functionNodeType instanceof FunctionType)
    ) {
      this.commonVisit(node, ast);
      return;
    }

    const parameterTypes = functionNodeType.parameters;
    const returnsTypes = functionNodeType.returns;

    node.vReferencedDeclaration.vParameters.vParameters.forEach((parameter, index) => {
      // Solc 0.7.0 types push and pop as you would expect, 0.8.0 adds an extra initial argument
      // console.log(parameter.id);
      const paramIndex = index + parameterTypes.length - node.vArguments.length;
      const t = parameterTypes[paramIndex];
      if (t instanceof PointerType) {
        if (parameter.storageLocation !== t.location) {
          parameter.storageLocation = t.location;
          this.declarations.set(parameter, true);
        }
      }
    });

    node.vReferencedDeclaration.vReturnParameters.vParameters.forEach((parameter, index) => {
      const t = returnsTypes[index];
      if (t instanceof PointerType) {
        if (parameter.storageLocation !== t.location) {
          parameter.storageLocation = t.location;
          this.declarations.set(parameter, true);
        }
      }
    });
    this.commonVisit(node, ast);
  }
}
