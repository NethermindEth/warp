import assert = require('assert');

import {
  ArrayType,
  DataLocation,
  Expression,
  FunctionDefinition,
  getNodeType,
  PointerType,
  Return,
  TupleExpression,
  TypeNode,
} from 'solc-typed-ast';

import { AST } from '../../ast/ast';

import { ASTMapper } from '../../ast/mapper';
import { isExternallyVisible } from '../../utils/utils';
export class DynArrayReturner extends ASTMapper {
  /*
  This pass looks for expressions that are returning dynamic arrays from external functions. Once those expressions are found it makes sure that
  the correct StructDefinitions are created to hold the pointers of dynamic arrays.
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;

    if (isExternallyVisible(node) && body !== undefined) {
      const returnStatements = node
        .getChildren(true)
        .filter((n) => n instanceof Return && n.vExpression !== undefined);

      returnStatements.forEach((retStatement) => {
        assert(retStatement instanceof Return);
        const retExpression = retStatement.vExpression;
        assert(retExpression instanceof Expression);
        this.createDynArrayStructDefs(retExpression, ast);
      });
    }
  }

  createDynArrayStructDefs(node: Expression, ast: AST): void {
    const type = getNodeType(node, ast.compilerVersion);

    if (node instanceof TupleExpression) {
      node.vOriginalComponents.forEach((exp) => {
        if (exp !== null) {
          this.createDynArrayStructDefs(exp, ast);
        }
      });
    } else if (this.isDynamicMemoryArray(type)) {
      // Need to create the struct that the DynArray will sit in.
      ast.getUtilFuncGen(node).externalFunctions.inputs.darrayStructConstructor.gen(node, node);
    }
    return;
  }

  isDynamicMemoryArray(type: TypeNode): boolean {
    return (
      type instanceof PointerType &&
      type.location === DataLocation.Memory &&
      type.to instanceof ArrayType &&
      type.to.size === undefined
    );
  }
}
