import assert = require('assert');
import {
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
  FunctionTypeName,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';

export class VariableDeclarationInitialiser extends ASTMapper {
  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    if (node.vInitialValue) return;

    // We assume the declaration list is only one long in the case it hasn't been initialised.
    // Tuple declarations must be initialised and the rhs cannot contain empty slots
    if (node.vDeclarations.length > 1) {
      throw new TranspileFailedError("Can't instantiate multiple arguments");
    }
    const declaration = node.vDeclarations[0];
    if (!declaration.vType) {
      // This could be transpile failed because a previous pass didn't specify a type,
      // or NotSupported because Solidity0.4 did not require specified types
      // TODO add solidity version guard to reject unsupported solidity versions
      throw new TranspileFailedError('Please specify all types');
    }
    node.vInitialValue = this.zeroValue(declaration.vType, ast);
    ast.registerChild(node.vInitialValue, node);
  }
  zeroValue(node: TypeName, ast: AST): Expression {
    switch (node.constructor) {
      case ElementaryTypeName:
        return new Literal(
          ast.reserveId(),
          node.src,
          'Literal',
          node.typeString,
          LiteralKind.Number,
          '0',
          '0',
        );
      case Mapping:
        throw new TranspileFailedError('Mappings should not be uninitialised');
      case ArrayTypeName:
        return new Literal(
          ast.reserveId(),
          node.src,
          'Literal',
          node.typeString,
          LiteralKind.Number,
          '0',
          '0',
        );
      case UserDefinedTypeName: {
        // TODO check if this always holds
        const tDec = (node as UserDefinedTypeName).vReferencedDeclaration as StructDefinition;
        const args = tDec.vMembers.map((v) => {
          assert(v.vType !== undefined, 'TypeNode should be defined for Solidity >0.4.x');
          return this.zeroValue(v.vType, ast);
        });

        return new FunctionCall(
          ast.reserveId(),
          node.src,
          'FunctionCall',
          node.typeString,
          FunctionCallKind.StructConstructorCall,
          new Identifier(
            ast.reserveId(),
            node.src,
            'Identifier',
            node.typeString,
            tDec.name,
            tDec.id,
          ),
          args,
        );
      }

      // TODO implement, in solidity calling an unitialised function object result in a panic error
      // This is equivalent to assert(false) in solidity, and not require(false)
      case FunctionTypeName:
        assert(false, 'Auto-initialising function objects not yet supported');
        break;

      default:
        assert(false, `Attempted to auto-initialise unexpected node type ${node.type}`);
    }
  }
}
