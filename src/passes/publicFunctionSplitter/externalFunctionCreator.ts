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

export class ExternalFunctionCreator extends ASTMapper {
  suffix = '_internal';

  constructor(
    public publicToExternalFunctionMap: Map<FunctionDefinition, FunctionDefinition>,
    public publicToInernalFunctionMap: Map<FunctionDefinition, string>,
  ) {
    super();
  }
  /*
  This class will visit each function definition. If the function is public it will
  create an external counterpart that will call the internal public function that is now modified to be internal. 

  The public and external functions are added to a Map that will be used in the next pass to change function calls to
  to the public functions to now call the external function.
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (FunctionVisibility.Public === node.visibility && node.kind !== FunctionKind.Constructor) {
      this.modifyPublicFunction(node);
      const newExternalFunction = this.createExternalFunction(node, ast);
      //node.visibility = FunctionVisibility.Internal;
      // Changes the orginal function from public to internal
      this.publicToExternalFunctionMap.set(node, newExternalFunction);
    }
    this.commonVisit(node, ast);
  }

  private modifyPublicFunction(node: FunctionDefinition): FunctionDefinition {
    node.visibility = FunctionVisibility.Internal;
    this.publicToInernalFunctionMap.set(node, node.name + this.suffix);
    node.name = node.name + this.suffix;
    return node;
  }

  private createExternalFunction(node: FunctionDefinition, ast: AST): FunctionDefinition {
    // Creating the Function
    //const newExternalFunction = cloneASTNode(node, ast);

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

    // Creating the Function Call to be placed in return
    const internalFunctionCallArguments: Expression[] =
      newExternalFunction.vParameters.vParameters.map((parameter) => {
        return createIdentifier(parameter, ast);
      });
    const internalFunctionCall = createCallToFunction(node, internalFunctionCallArguments, ast);

    // Creating return that the function call will sit in.
    const newReturnFunctionCall = new Return(
      ast.reserveId(),
      '',
      'Return',
      newExternalFunction.vReturnParameters.id,
      internalFunctionCall,
    );

    //const newExternalFunctionBody = new Block(ast.reserveId(), '', 'Block', []);
    newExternalFunction.vBody?.appendChild(newReturnFunctionCall);
    //newExternalFunction.vBody !== undefined
    //  ? ast.replaceNode(newExternalFunction.vBody, newExternalFunctionBody)
    //  : (newExternalFunction.vBody = newExternalFunctionBody);
    //newExternalFunction.vBody?.appendChild(newExternalFunctionBody);
    node.getClosestParentByType(ContractDefinition)?.appendChild(newExternalFunction);
    ast.setContextRecursive(newExternalFunction);

    return newExternalFunction;
  }
}
