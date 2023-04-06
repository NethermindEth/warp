import {
  BinaryOperation,
  FunctionCall,
  Identifier,
  UnaryOperation,
  UncheckedBlock,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { NotSupportedYetError } from '../../utils/errors';
import { createCallToFunction } from '../../utils/functionGeneration';
import { WARPLIB_MATHS } from '../../utils/importPaths';
import { createNumberLiteral, createUint256TypeName } from '../../utils/nodeTemplates';
import { functionaliseBitwiseNot } from '../../warplib/implementations/maths/bitwiseNot';
import { functionaliseNegate } from '../../warplib/implementations/maths/negate';

/* Note we also include mulmod and add mod here */
export class MathsOperationToFunction extends ASTMapper {
  inUncheckedBlock = false;

  visitUncheckedBlock(node: UncheckedBlock, ast: AST): void {
    this.inUncheckedBlock = true;
    this.commonVisit(node, ast);
    this.inUncheckedBlock = false;
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.commonVisit(node, ast);
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    this.commonVisit(node, ast);
    const operatorMap: Map<string, () => void> = new Map([
      ['-', () => functionaliseNegate(node, ast)],
      ['~', () => functionaliseBitwiseNot(node, ast)],
      ['!', () => replaceNot(node, ast)],
      [
        'delete',
        () => {
          return;
        },
      ],
    ]);

    const thunk = operatorMap.get(node.operator);
    if (thunk === undefined) {
      throw new NotSupportedYetError(`${node.operator} not supported yet`);
    }

    thunk();
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);

    if (
      node.vExpression instanceof Identifier &&
      node.vExpression.vReferencedDeclaration === undefined
    ) {
      if (['mulmod', 'addmod'].includes(node.vExpression.name)) {
        const name = `warp_${node.vExpression.name}`;
        const importedFunc = ast.registerImport(
          node,
          [...WARPLIB_MATHS, node.vExpression.name],
          name,
          [
            ['x', createUint256TypeName(ast)],
            ['y', createUint256TypeName(ast)],
          ],
          [['res', createUint256TypeName(ast)]],
        );
        const replacement = createCallToFunction(importedFunc, node.vArguments, ast);
        ast.replaceNode(node, replacement);
      }
    }
  }
}

function replaceNot(node: UnaryOperation, ast: AST): void {
  ast.replaceNode(
    node,
    new BinaryOperation(
      ast.reserveId(),
      node.src,
      node.typeString,
      '-',
      createNumberLiteral(1, ast, node.typeString),
      node.vSubExpression,
      node.raw,
    ),
  );
}
