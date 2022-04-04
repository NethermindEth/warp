import assert from 'assert';
import {
  ContractDefinition,
  ContractKind,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  IdentifierPath,
  MemberAccess,
  UserDefinedTypeName,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { error } from '../utils/formatting';

const Star = null;
type Star = typeof Star;

export class UsingForResolver extends ASTMapper {
  typeToLibrary: Map<string | Star, UserDefinedTypeName | IdentifierPath> = new Map();

  visitContractDefinition(node: ContractDefinition, ast: AST) {
    node.vUsingForDirectives.forEach((usingForNode) => {
      assert(
        usingForNode.vLibraryName !== undefined,
        error(
          `UsingForResolver expects all using directives to have a library name. ${printNode(
            usingForNode,
          )} does not`,
        ),
      );
      this.typeToLibrary.set(
        usingForNode?.vTypeName?.typeString || Star,
        usingForNode.vLibraryName,
      );
    });

    this.commonVisit(node, ast);
    // Clear the mapping from type to library for the next contract definition
    this.typeToLibrary.clear();
  }

  visitFunctionCall(node: FunctionCall, ast: AST) {
    this.commonVisit(node, ast);

    const memberAccessNode = node.vExpression;
    if (!(memberAccessNode instanceof MemberAccess)) return;

    const libraryReference =
      this.typeToLibrary.get(memberAccessNode.vExpression.typeString) ||
      this.typeToLibrary.get(Star);
    if (libraryReference === undefined) {
      // No library attached to this type
      return;
    }

    const libraryFunction = memberAccessNode.vReferencedDeclaration;
    if (!(libraryFunction instanceof FunctionDefinition)) return;

    const contract = libraryFunction.vScope;
    if (!(contract instanceof ContractDefinition && contract?.kind === ContractKind.Library))
      return;
    assert(
      libraryReference?.name === contract.name,
      `Library from UsingForDirective does not match this ContractDefinition ${contract.name}`,
    );

    const libraryIdentifier = new Identifier(
      ast.reserveId(),
      '',
      `type(library ${contract.name})`,
      contract.name,
      contract.id,
    );

    node.vArguments.unshift(memberAccessNode.vExpression);
    ast.registerChild(memberAccessNode.vExpression, node);

    memberAccessNode.vExpression = libraryIdentifier;
    memberAccessNode.memberName = libraryFunction.name;
    memberAccessNode.referencedDeclaration = libraryFunction.id;
    ast.registerChild(libraryIdentifier, memberAccessNode);
  }
}
