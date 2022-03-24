import assert = require('assert');
import {
  Block,
  ContractDefinition,
  FunctionDefinition,
  FunctionVisibility,
  Identifier,
  Expression,
  Return,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createCallToFunction } from '../../utils/functionStubbing';

export class ExternalFunctionCreator extends ASTMapper {
  constructor(
    //public publicFunctionIdMap: Map<number, number>,
    //public publicFunctionNamesMap: Map<string, string>,
    public publicToExternalFunctionMapMaster: Map<FunctionDefinition, FunctionDefinition>,
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
    if (FunctionVisibility.Public === node.visibility) {
      const newExternalFunction = this.createExternalFunction(node, ast);
      //node.visibility = FunctionVisibility.Internal;
      this.modifyPublicFunction(node);
      // Changes the orginal function from public to internal
      this.publicToExternalFunctionMapMaster.set(node, newExternalFunction);
    }
    this.commonVisit(node, ast);
  }

  private modifyPublicFunction(node: FunctionDefinition): FunctionDefinition {
    node.visibility = FunctionVisibility.Internal;
    return node;
  }

  private createExternalFunction(node: FunctionDefinition, ast: AST): FunctionDefinition {
    // Creating the Function
    const newExternalFunction = cloneASTNode(node, ast);
    newExternalFunction.visibility = FunctionVisibility.External;
    newExternalFunction.name = node.name + '_external';

    // Creating the Function Call to be placed in return
    const FunctionCallArguments: Expression[] = node.vParameters.vParameters.map((parameter) => {
      return new Identifier(
        ast.reserveId(),
        '',
        'Identifier',
        parameter.typeString,
        parameter.name,
        parameter.id,
      );
    });
    const internalFunctionCall = createCallToFunction(node, FunctionCallArguments, ast);

    // Creating return that the function call will sit in.
    const newExternalFunctionCall = new Return(
      ast.reserveId(),
      '',
      'Return',
      newExternalFunction.vReturnParameters.id,
      internalFunctionCall,
    );
    const newExternalFunctionBody = new Block(ast.reserveId(), '', 'Block', []);
    newExternalFunctionBody.appendChild(newExternalFunctionCall);
    newExternalFunction.vBody !== undefined
      ? ast.replaceNode(newExternalFunction.vBody, newExternalFunctionBody)
      : (newExternalFunction.vBody = newExternalFunctionBody);
    //newExternalFunction.vBody?.appendChild(newExternalFunctionBody);
    node.getClosestParentByType(ContractDefinition)?.appendChild(newExternalFunction);
    const contractNode = node.getClosestParentByType(ContractDefinition);
    assert(contractNode !== undefined);
    ast.setContextRecursive(newExternalFunction);

    return newExternalFunction;
  }
}
