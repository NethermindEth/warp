import assert from 'assert';
import {
  ASTNode,
  ContractDefinition,
  ContractKind,
  FunctionDefinition,
  FunctionKind,
  getNodeType,
  Identifier,
  ImportDirective,
  StructDefinition,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { NotSupportedYetError } from '../utils/errors';
import { getContractTypeString, getFunctionTypeString } from '../utils/utils';

export class ImportDirectiveIdentifier extends ASTMapper {
  visitImportDirective(node: ImportDirective, ast: AST): void {
    console.log(node.vSymbolAliases);
    node.getChildrenByType(Identifier).forEach((identifier) => {
      assert(identifier.vReferencedDeclaration !== undefined);
      identifier.typeString = getTypestring(identifier.vReferencedDeclaration, ast);
    });
  }
}

function getTypestring(node: ASTNode, ast: AST): string {
  if (node instanceof ContractDefinition) {
    return getContractTypeString(node);
  }

  if (node instanceof FunctionDefinition) {
    return getFunctionTypeString(node, ast.compilerVersion);
  }

  // if (node instanceof StructDefinition){
  //   return `struct ${node.name}`
  // }
  throw new NotSupportedYetError(`Importing ${node.type} not implemented yet`);
}
