import {
  BinaryOperation,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  Identifier,
  IntType,
} from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { typeNameFromTypeNode } from '../../../utils/utils';
import { safeGetNodeType } from '../../../utils/nodeTypeProcessing';
import assert from 'assert';
import { printNode, printTypeNode } from '../../../utils/astPrinter';
import { getIntOrFixedByteBitWidth } from '../../../warplib/utils';

export function functionaliseUncheckedAdd(node: BinaryOperation, ast: AST) {
  IntxIntUncheckedFunction(node, 'add', ast);
}

export function functionaliseUncheckedSub(node: BinaryOperation, ast: AST) {
  IntxIntUncheckedFunction(node, 'sub', ast);
}

function IntxIntUncheckedFunction(node: BinaryOperation, name: string, ast: AST) {
  const lhsType = typeNameFromTypeNode(safeGetNodeType(node.vLeftExpression, ast.inference), ast);
  const rhsType = typeNameFromTypeNode(safeGetNodeType(node.vRightExpression, ast.inference), ast);
  const retType = safeGetNodeType(node, ast.inference);
  assert(
    retType instanceof IntType || retType instanceof FixedBytesType,
    `${printNode(node)} has type ${printTypeNode(retType)}, which is not compatible with ${name}`,
  );
  const width = getIntOrFixedByteBitWidth(retType);

  const fullName = ['u', `${width}`, `_overflow$ing`, `_${name}`].join('');

  const importName = ['integer'];

  const importedFunc = ast.registerImport(
    node,
    importName,
    fullName,
    [
      ['lhs', lhsType],
      ['rhs', rhsType],
    ],
    [['res', typeNameFromTypeNode(retType, ast)]],
  );

  const call = new FunctionCall(
    ast.reserveId(),
    node.src,
    node.typeString,
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      `function (${node.typeString}, ${node.typeString}) returns (${node.typeString})`,
      fullName,
      importedFunc.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
}
