import {
  Block,
  ContractDefinition,
  FunctionDefinition,
  FunctionVisibility,
  Expression,
  Return,
  FunctionKind,
  ContractKind,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createCallToFunction } from '../../utils/functionStubbing';
import { createIdentifier } from '../../utils/nodeTemplates';
export class ExternalFunctionCreator extends ASTMapper {
  suffix = '_internal';

  constructor(
    public InternalToExternalFunctionMap: Map<FunctionDefinition, FunctionDefinition>,
    public internalFunctionCallSet: Set<FunctionDefinition>,
  ) {
    super();
  }
  /*
  This class will visit each function definition. If the function definition is public it will
  create an external counterpart. The visited function will then be changed to internal and have 
  the suffix _internal added to the name. 

  The internal and external functions will be added to the Maps above to be used in the next pass 
  to modify the function calls. All internal function calls to the original function will need to 
  be renamed and all contract to contract calls need to have their referenced changed to the external 
  function (Still not supported yet). 
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (node.vScope instanceof ContractDefinition && node.vScope.kind === ContractKind.Interface) {
      return;
    }

    if (
      FunctionVisibility.Public === node.visibility &&
      node.kind !== FunctionKind.Constructor &&
      this.internalFunctionCallSet.has(node)
    ) {
      const newExternalFunction = this.createExternalFunctionDefintion(node, ast);
      this.insertReturnStatement(node, newExternalFunction, ast);
      this.modifyPublicFunction(node);
      this.InternalToExternalFunctionMap.set(node, newExternalFunction);
    }
    this.commonVisit(node, ast);
  }

  private modifyPublicFunction(node: FunctionDefinition): void {
    node.visibility = FunctionVisibility.Internal;
    node.name = node.name + this.suffix;
  }

  private createExternalFunctionDefintion(node: FunctionDefinition, ast: AST): FunctionDefinition {
    const newBlock = new Block(ast.reserveId(), '', []);
    const internalFunctionBody = node.vBody;
    node.vBody = undefined;
    const externalFunction = cloneASTNode(node, ast);

    externalFunction.vBody = newBlock;
    externalFunction.acceptChildren();
    externalFunction.visibility = FunctionVisibility.External;

    node.vBody = internalFunctionBody;
    return externalFunction;
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
      externalFunction.vReturnParameters.id,
      internalFunctionCall,
    );

    externalFunction.vBody?.appendChild(newReturnFunctionCall);
    node.getClosestParentByType(ContractDefinition)?.appendChild(externalFunction);
    ast.setContextRecursive(externalFunction);
  }
}
