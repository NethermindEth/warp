import {
  ASTNode,
  TypeName,
  ElementaryTypeName,
  VariableDeclarationStatement,
  Literal,
  LiteralKind,
  ArrayTypeName,
  FunctionCall,
  FunctionCallKind,
  Identifier,
  UserDefinedTypeName,
  Mapping,
  StructDefinition,
  Expression,
} from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';

export class VariableDeclarationInitialiser extends ASTMapper {
  visitVariableDeclarationStatement(node: VariableDeclarationStatement): ASTNode {
    if (node.vInitialValue) {
      return node;
    }

    // We assume the declaration list is only one long in the case it hasn't been initialised.
    if (node.vDeclarations.length > 1) {
      throw new Error("Can't instantiate multiple arguments");
    }
    const declaration = node.vDeclarations[0];
    if (!declaration.vType) {
      throw new Error('Please specify all types');
    }
    const initialValue = zeroValue(declaration.vType);

    return new VariableDeclarationStatement(
      this.genId(),
      node.src,
      node.type,
      node.assignments,
      node.vDeclarations,
      initialValue,
      node.documentation,
      node.raw,
    );
  }

  getPassName(): string {
    return 'Variable Declaration Initialiser';
  }
}

function zeroValue(node: TypeName): Expression {
  switch (node.constructor) {
    case ElementaryTypeName:
      return new Literal(
        this.genId(),
        node.src,
        'ElementaryTypeName',
        node.typeString,
        LiteralKind.Number,
        '0',
        '0',
      );
    case Mapping:
      throw new Error('Mappings should not be uninitialised');
    case ArrayTypeName:
      return new FunctionCall(
        this.genId(),
        node.src,
        'FunctionCall',
        node.typeString,
        FunctionCallKind.FunctionCall,
        new Identifier(node.id, node.src, 'Identifier', node.typeString, 'alloc', -1),
        [],
      );
    case UserDefinedTypeName:
      const tDec = (node as UserDefinedTypeName).vReferencedDeclaration as StructDefinition;
      const identifier = new Identifier(
        this.genId(),
        node.src,
        'Identifier',
        node.typeString,
        tDec.name,
        tDec.id,
      );
      const args = tDec.vMembers.map((v) => zeroValue(v.vType));

      return new FunctionCall(
        this.genId(),
        node.src,
        'FunctionCall',
        node.typeString,
        FunctionCallKind.StructConstructorCall,
        identifier,
        args,
      );
  }
}
