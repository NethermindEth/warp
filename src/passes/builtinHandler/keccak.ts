import { DataLocation, ExternalReferenceType, FunctionCall } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCallToFunction } from '../../utils/functionGeneration';
import { warpKeccakImport } from '../../utils/importPaths';
import {
  createArrayTypeName,
  createBytesNTypeName,
  createUintNTypeName,
} from '../../utils/nodeTemplates';

export class Keccak extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      !(
        node.vFunctionName === 'keccak256' &&
        node.vFunctionCallType === ExternalReferenceType.Builtin
      )
    ) {
      return this.commonVisit(node, ast);
    }

    const warpKeccak = ast.registerImport(
      node,
      ...warpKeccakImport(),
      [['input', createArrayTypeName(createUintNTypeName(8, ast), ast), DataLocation.Memory]],
      [['hash', createBytesNTypeName(32, ast)]],
    );

    ast.replaceNode(node, createCallToFunction(warpKeccak, node.vArguments, ast));

    this.commonVisit(node, ast);
  }
}
