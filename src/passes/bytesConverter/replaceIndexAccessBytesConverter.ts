import { FixedBytesType, generalizeType, TypeName, IndexAccess, Literal } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCallToFunction } from '../../utils/functionGeneration';
import { generateExpressionTypeString } from '../../utils/getTypeString';
import { typeNameFromTypeNode } from '../../utils/utils';
import {
  createNumberLiteral,
  createUint8TypeName,
  createUint256TypeName,
} from '../../utils/nodeTemplates';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { replaceBytesType } from './utils';

export class ReplaceIndexAccessBytesConverter extends ASTMapper {
  visitIndexAccess(node: IndexAccess, ast: AST): void {
    const baseNodeType = safeGetNodeType(node.vBaseExpression, ast.inference);
    const baseExprType = generalizeType(baseNodeType)[0];
    if (node.vIndexExpression === undefined || !(baseExprType instanceof FixedBytesType)) {
      this.visitExpression(node, ast);
      return;
    }

    const baseTypeName = typeNameFromTypeNode(baseNodeType, ast);

    const indexTypeName =
      node.vIndexExpression instanceof Literal
        ? createUint256TypeName(ast)
        : typeNameFromTypeNode(safeGetNodeType(node.vIndexExpression, ast.inference), ast);

    const stubParams: [string, TypeName][] = [
      ['base', baseTypeName],
      ['index', indexTypeName],
    ];
    const callArgs = [node.vBaseExpression, node.vIndexExpression];
    if (baseExprType.size !== 32) {
      stubParams.push(['width', createUint8TypeName(ast)]);
      callArgs.push(createNumberLiteral(baseExprType.size, ast, 'uint8'));
    }

    const importedFunc = ast.registerImport(
      node,
      'warplib.maths.bytes_access',
      selectWarplibFunction(baseTypeName, indexTypeName),
      stubParams,
      [['res', createUint8TypeName(ast)]],
    );

    const call = createCallToFunction(importedFunc, callArgs, ast);
    ast.replaceNode(node, call, node.parent);
    const callNodeType = replaceBytesType(safeGetNodeType(call, ast.inference));
    call.typeString = generateExpressionTypeString(callNodeType);
    this.commonVisit(call, ast);
  }
}

function selectWarplibFunction(baseTypeName: TypeName, indexTypeName: TypeName): string {
  if (indexTypeName.typeString === 'uint256' && baseTypeName.typeString === 'bytes32') {
    return 'byte256_at_index_uint256';
  }
  if (indexTypeName.typeString === 'uint256') {
    return 'byte_at_index_uint256';
  }
  if (baseTypeName.typeString === 'bytes32') {
    return 'byte256_at_index';
  }
  return 'byte_at_index';
}
