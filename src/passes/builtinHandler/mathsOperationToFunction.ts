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
import { createNumberLiteral, createUint256TypeName } from '../../utils/nodeTemplates';
import { functionaliseAdd } from '../../warplib/implementations/maths/add';
import { functionaliseAnd } from '../../warplib/implementations/maths/and';
import { functionaliseBitwiseAnd } from '../../warplib/implementations/maths/bitwiseAnd';
import { functionaliseBitwiseNot } from '../../warplib/implementations/maths/bitwiseNot';
import { functionaliseBitwiseOr } from '../../warplib/implementations/maths/bitwiseOr';
import { functionaliseDiv } from '../../warplib/implementations/maths/div';
import { functionaliseEq } from '../../warplib/implementations/maths/eq';
import { functionaliseExp } from '../../warplib/implementations/maths/exp';
import { functionaliseGe } from '../../warplib/implementations/maths/ge';
import { functionaliseGt } from '../../warplib/implementations/maths/gt';
import { functionaliseLe } from '../../warplib/implementations/maths/le';
import { functionaliseLt } from '../../warplib/implementations/maths/lt';
import { functionaliseMod } from '../../warplib/implementations/maths/mod';
import { functionaliseMul } from '../../warplib/implementations/maths/mul';
import { functionaliseNegate } from '../../warplib/implementations/maths/negate';
import { functionaliseNeq } from '../../warplib/implementations/maths/neq';
import { functionaliseOr } from '../../warplib/implementations/maths/or';
import { functionaliseShl } from '../../warplib/implementations/maths/shl';
import { functionaliseShr } from '../../warplib/implementations/maths/shr';
import { functionaliseSub } from '../../warplib/implementations/maths/sub';
import { functionaliseXor } from '../../warplib/implementations/maths/xor';

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
    const operatorMap: Map<string, () => void> = new Map([
      ['+', () => functionaliseAdd(node, this.inUncheckedBlock, ast)],
      ['-', () => functionaliseSub(node, this.inUncheckedBlock, ast)],
      ['*', () => functionaliseMul(node, this.inUncheckedBlock, ast)],
      ['/', () => functionaliseDiv(node, this.inUncheckedBlock, ast)],
      ['%', () => functionaliseMod(node, ast)],
      ['**', () => functionaliseExp(node, this.inUncheckedBlock, ast)],
      ['==', () => functionaliseEq(node, ast)],
      ['!=', () => functionaliseNeq(node, ast)],
      ['>=', () => functionaliseGe(node, ast)],
      ['>', () => functionaliseGt(node, ast)],
      ['<=', () => functionaliseLe(node, ast)],
      ['<', () => functionaliseLt(node, ast)],
      ['&', () => functionaliseBitwiseAnd(node, ast)],
      ['|', () => functionaliseBitwiseOr(node, ast)],
      ['^', () => functionaliseXor(node, ast)],
      ['<<', () => functionaliseShl(node, ast)],
      ['>>', () => functionaliseShr(node, ast)],
      ['&&', () => functionaliseAnd(node, ast)],
      ['||', () => functionaliseOr(node, ast)],
    ]);

    const thunk = operatorMap.get(node.operator);
    if (thunk === undefined) {
      throw new NotSupportedYetError(`${node.operator} not supported yet`);
    }

    thunk();
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
          ['warplib', 'maths', `${node.vExpression.name}`],
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
