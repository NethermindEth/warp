import { PublicFunctionCallModifier } from './publicFunctionCallModifier';
import { ExternalFunctionCreator } from './externalFunctionCreator';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { FunctionDefinition } from 'solc-typed-ast';

export class PublicFunctionSplitter extends ASTMapper {
  static map(ast: AST): AST {
    const publicToExternalFunctionMap = new Map<FunctionDefinition, FunctionDefinition>();
    const publicToInternalFunctionMap = new Map<FunctionDefinition, string>();
    ast.roots.forEach((root) => {
      new ExternalFunctionCreator(
        publicToExternalFunctionMap,
        publicToInternalFunctionMap,
      ).dispatchVisit(root, ast);
      new PublicFunctionCallModifier(
        publicToExternalFunctionMap,
        publicToInternalFunctionMap,
      ).dispatchVisit(root, ast);
    });
    return ast;
  }
}
