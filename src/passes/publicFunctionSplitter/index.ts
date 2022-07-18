import { PublicFunctionCallModifier } from './publicFunctionCallModifier';
import { ExternalFunctionCreator } from './externalFunctionCreator';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { FunctionDefinition } from 'solc-typed-ast';
import { InternalFunctionCallCollector } from './internalFunctionCallCollector';

export class PublicFunctionSplitter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    const internalFunctionCallSet = new Set<FunctionDefinition>();
    ast.roots.forEach((root) =>
      new InternalFunctionCallCollector(internalFunctionCallSet).dispatchVisit(root, ast),
    );
    const internalToExternalFunctionMap = new Map<FunctionDefinition, FunctionDefinition>();
    ast.roots.forEach((root) =>
      new ExternalFunctionCreator(
        internalToExternalFunctionMap,
        internalFunctionCallSet,
      ).dispatchVisit(root, ast),
    );
    ast.roots.forEach((root) =>
      new PublicFunctionCallModifier(internalToExternalFunctionMap).dispatchVisit(root, ast),
    );
    return ast;
  }
}
