import { ExpressionStatement, FunctionDefinition, FunctionVisibility } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { createCallToFunction } from '../utils/functionStubbing';

export class PublicFunctionSplitter extends ASTMapper {
  /*
  This class will visit each function definition. If the function is public it will
  create an external function that will call the now internal public function. 

  The external function will apply the neccessary external input checks (added by later passes) 
  and proceed to call its internal function counterpart.

  The only change to the original public function is that it is now considered an internal
  function and therefor we do not need to update any of the functions that call it. 
  */
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (FunctionVisibility.Public === node.visibility) {
      this.createExternalFunction(node, ast);
      // Changes the orginal function from public to internal
      node.visibility = FunctionVisibility.Internal;
    }
    this.commonVisit(node, ast);
  }

  private createExternalFunction(node: FunctionDefinition, ast: AST): void {
    // External Function Definition
    const newExternalFunction = cloneASTNode(node, ast);
    newExternalFunction.visibility = FunctionVisibility.External;
    newExternalFunction.name = node.name + '_external';

    // External Function Block
    const internalFunctionCallArgs = cloneASTNode(node.vParameters, ast);
    const internalFunctionCall = createCallToFunction(
      node,
      internalFunctionCallArgs.vParameters,
      ast,
    );
    const newExternalFunctionBody = new ExpressionStatement(
      ast.reserveId(),
      '',
      'ExpressionStatement',
      internalFunctionCall,
    );
    const externalFunctionBlock = newExternalFunction.vBody;
    externalFunctionBlock?.children.forEach((child) => externalFunctionBlock.removeChild(child));
    externalFunctionBlock?.appendChild(newExternalFunctionBody);
    node.vScope.appendChild(newExternalFunction);
    ast.setContextRecursive(newExternalFunction);
  }
}
