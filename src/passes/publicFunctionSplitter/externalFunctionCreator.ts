import {
  Block,
  ContractDefinition,
  FunctionDefinition,
  FunctionVisibility,
  Expression,
  Return,
  FunctionKind,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createCallToFunction } from '../../utils/functionStubbing';
import { createIdentifier } from '../../utils/nodeTemplates';
import { CairoFunctionDefinition } from '../../ast/cairoNodes';
export class ExternalFunctionCreator extends ASTMapper {
  suffix = '_internal';

  constructor(
    public publicToExternalFunctionMap: Map<FunctionDefinition, FunctionDefinition>,
    public publicToInternalFunctionMap: Map<FunctionDefinition, string>,
  ) {
    super();
  }
  /*
  This class will visit each function definition. If the function definition is public it will
  create an external counterpart that will call the internal public function that is now modified to be internal and has the suffix _internal. 

  The internal and external functions will be added to the Maps above to be used in the next pass to modify the function calls,
  since now all internal functions need to point to the newly named internal function and all contract to contract calls need to 
  be repointed to the external function.
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (FunctionVisibility.Public === node.visibility && node.kind !== FunctionKind.Constructor) {
      this.modifyPublicFunction(node);
      const newExternalFunction = this.createExternalFunctionDefintion(node, ast);
      this.insertReturnStatement(node, newExternalFunction, ast);
      this.publicToExternalFunctionMap.set(node, newExternalFunction);
    }
    this.commonVisit(node, ast);
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    if (FunctionVisibility.Public === node.visibility && node.kind !== FunctionKind.Constructor) {
      this.modifyPublicFunction(node);
      const newExternalCairoFunction = this.createExternalCairoFunctionDefinition(node, ast);
      this.insertReturnStatement(node, newExternalCairoFunction, ast);
      this.publicToExternalFunctionMap.set(node, newExternalCairoFunction);
    }
    this.commonVisit(node, ast);
  }

  private modifyPublicFunction(node: FunctionDefinition): FunctionDefinition {
    node.visibility = FunctionVisibility.Internal;
    this.publicToInternalFunctionMap.set(node, node.name + this.suffix);
    node.name = node.name + this.suffix;
    return node;
  }

  private createExternalFunctionDefintion(node: FunctionDefinition, ast: AST): FunctionDefinition {
    const newBlock = new Block(ast.reserveId(), '', 'Block', []);

    const newExternalFunction = new FunctionDefinition(
      ast.reserveId(),
      '',
      'FunctionDefinition',
      node.scope,
      node.kind,
      node.name.replace(this.suffix, ''),
      node.virtual,
      FunctionVisibility.External,
      node.stateMutability,
      node.isConstructor,
      cloneASTNode(node.vParameters, ast),
      cloneASTNode(node.vReturnParameters, ast),
      node.vModifiers.map((m) => cloneASTNode(m, ast)),
      node.vOverrideSpecifier && cloneASTNode(node.vOverrideSpecifier, ast),
      newBlock,
      node.documentation,
      node.nameLocation,
      node.raw,
    );
    return newExternalFunction;
  }

  private createExternalCairoFunctionDefinition(
    node: CairoFunctionDefinition,
    ast: AST,
  ): CairoFunctionDefinition {
    const newBlock = new Block(ast.reserveId(), '', 'Block', []);

    const newExternalFunction = new CairoFunctionDefinition(
      ast.reserveId(),
      '',
      'CairoFunctionDefinition',
      node.scope,
      node.kind,
      node.name.replace(this.suffix, ''),
      node.virtual,
      FunctionVisibility.External,
      node.stateMutability,
      node.isConstructor,
      cloneASTNode(node.vParameters, ast),
      cloneASTNode(node.vReturnParameters, ast),
      node.vModifiers.map((m) => cloneASTNode(m, ast)),
      node.implicits,
      node.isStub,
      node.vOverrideSpecifier && cloneASTNode(node.vOverrideSpecifier, ast),
      newBlock,
      node.documentation,
      node.nameLocation,
      node.raw,
    );

    return newExternalFunction;
  }

  private insertReturnStatement(
    node: FunctionDefinition,
    externalFunction: FunctionDefinition,
    ast: AST,
  ): void {
    const internalFunctionCallArguments: Expression[] =
      externalFunction.vParameters.vParameters.map((parameter) => {
        return createIdentifier(parameter, ast);
      });
    const internalFunctionCall = createCallToFunction(node, internalFunctionCallArguments, ast);

    const newReturnFunctionCall = new Return(
      ast.reserveId(),
      '',
      'Return',
      externalFunction.vReturnParameters.id,
      internalFunctionCall,
    );

    externalFunction.vBody?.appendChild(newReturnFunctionCall);
    node.getClosestParentByType(ContractDefinition)?.appendChild(externalFunction);
    ast.setContextRecursive(externalFunction);
  }
}
