import { PublicFunctionCallModifier } from './functionModifier';
import { ExternalFunctionCreator } from './externalFunctionCreator';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { FunctionDefinition } from 'solc-typed-ast';

export class PublicFunctionSplitter extends ASTMapper {
  static map(ast: AST): AST {
    const publicToExternalFunctionMapMaster = new Map<FunctionDefinition, FunctionDefinition>();
    ast.roots.forEach((root) => {
      //   const publicFunctionIdMap = new Map<number, number>();
      //   const publicFunctionNamesMap = new Map<string, string>();
      //   const FunctionCallSet = new Set<ASTNode>();
      //   const PublicToExternalFunctionMap = new Map<ASTNode, ASTNode>();
      new ExternalFunctionCreator(
        // publicFunctionIdMap,
        // publicFunctionNamesMap,
        publicToExternalFunctionMapMaster,
      ).dispatchVisit(root, ast);
      new PublicFunctionCallModifier(
        // publicFunctionIdMap,
        // publicFunctionNamesMap,
        // FunctionCallSet,
        publicToExternalFunctionMapMaster,
      ).dispatchVisit(root, ast);
    });
    return ast;
  }
}
