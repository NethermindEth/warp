import { PublicFunctionCallModifier } from './publicFunctionCallModifier';
import { ExternalFunctionCreator } from './externalFunctionCreator';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { FunctionDefinition } from 'solc-typed-ast';

export class PublicFunctionSplitter extends ASTMapper {
  static map(ast: AST): AST {
    const publicToExternalFunctionMap = new Map<FunctionDefinition, FunctionDefinition>();
    ast.roots.forEach((root) => {
      new ExternalFunctionCreator(publicToExternalFunctionMap).dispatchVisit(root, ast);
      new PublicFunctionCallModifier(publicToExternalFunctionMap).dispatchVisit(root, ast);
    });
    return ast;
  }
}
