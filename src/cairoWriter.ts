import assert = require('assert');
import {
  ASTNode,
  ASTNodeConstructor,
  DataLocation,
  FunctionKind,
  LiteralKind,
  Mutability,
  StateVariableVisibility,
  TypeName,
  ContractDefinition,
  ContractKind,
  EnumDefinition,
  EnumValue,
  ErrorDefinition,
  EventDefinition,
  FunctionDefinition,
  ModifierDefinition,
  StructDefinition,
  VariableDeclaration,
  Assignment,
  BinaryOperation,
  Conditional,
  ElementaryTypeNameExpression,
  FunctionCall,
  FunctionCallOptions,
  Identifier,
  IndexAccess,
  IndexRangeAccess,
  Literal,
  MemberAccess,
  NewExpression,
  TupleExpression,
  UnaryOperation,
  IdentifierPath,
  ImportDirective,
  InheritanceSpecifier,
  ModifierInvocation,
  OverrideSpecifier,
  ParameterList,
  PragmaDirective,
  SourceUnit,
  StructuredDocumentation,
  UsingForDirective,
  Block,
  Break,
  Continue,
  DoWhileStatement,
  EmitStatement,
  ExpressionStatement,
  ForStatement,
  IfStatement,
  InlineAssembly,
  PlaceholderStatement,
  Return,
  RevertStatement,
  Statement,
  Throw,
  TryCatchClause,
  TryStatement,
  UncheckedBlock,
  VariableDeclarationStatement,
  WhileStatement,
  ArrayTypeName,
  ElementaryTypeName,
  FunctionTypeName,
  Mapping,
  UserDefinedTypeName,
  PrettyFormatter,
  LatestCompilerVersion,
  ASTNodeWriter,
  ASTWriter,
  FunctionVisibility,
  FunctionStateMutability,
  SrcDesc,
  FunctionCallKind,
} from 'solc-typed-ast';
import { Imports } from './ast/visitor';
import { CairoStorageVariable, CairoStorageVariableKind } from './ast/cairoStorageVariable';
import { primitiveTypeToCairo, divmod, importsWriter } from './utils/utils';
import { getMappingTypes } from './utils/mappings';
import CairoAssert from './ast/cairoAssert';

export abstract class CairoASTNodeWriter extends ASTNodeWriter {
  imports: Imports;
  constructor(imports?: Imports) {
    super();
    this.imports = imports;
  }
}

class StructDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: StructDefinition, writer: ASTWriter): SrcDesc {
    return [
      [
        `struct ${node.name}:`,
        ...node.vMembers.map((value) => `  member ${value.name} : ${writer.write(value.vType)}`),
        `end`,
      ].join('\n'),
    ];
  }
}

class ElementaryTypeNameWriter extends CairoASTNodeWriter {
  writeInner(node: ElementaryTypeName, _: ASTWriter): SrcDesc {
    return [primitiveTypeToCairo(node.name)];
  }
}

class ArrayTypeNameWriter extends CairoASTNodeWriter {
  writeInner(node: ArrayTypeName, writer: ASTWriter): SrcDesc {
    const baseType = writer.write(node.vBaseType);
    return [`${baseType}*`];
  }
}

class UserDefinedTypeNameWriter extends CairoASTNodeWriter {
  writeInner(node: UserDefinedTypeName, writer: ASTWriter): SrcDesc {
    return [`${(node.vReferencedDeclaration as StructDefinition).name}`];
  }
}

class MappingTypeNameWriter extends CairoASTNodeWriter {
  writeInner(_node: Mapping, _writer: ASTWriter): SrcDesc {
    return [`felt*`];
  }
}

class VariableDeclarationWriter extends CairoASTNodeWriter {
  writeInner(node: VariableDeclaration, writer: ASTWriter): SrcDesc {
    if (node.stateVariable) {
      let vals = [];
      if (node.vType instanceof Mapping) {
        vals = getMappingTypes(node.vType);
      } else {
        vals.push(writer.write(node.vType));
      }
      vals = vals.map((value) => writer.write(value));
      const keys = vals.slice(0, vals.length - 1);
      const returns = vals.slice(vals.length - 1, vals.length);
      return [
        [
          `@storage_var`,
          `func ${node.name}(${keys.join(', ')}) -> (res: ${returns[0]}):`,
          `end`,
        ].join('\n'),
      ];
    }

    return [`${node.name} : ${writer.write(node.vType)}`];
  }
}

class VariableDeclarationStatementWriter extends CairoASTNodeWriter {
  writeInner(node: VariableDeclarationStatement, writer: ASTWriter): SrcDesc {
    const declarations = node.vDeclarations.map((value) => writer.write(value));
    if (node.vDeclarations.length > 1) {
      return [`let (${declarations.join(', ')}) = ${writer.write(node.vInitialValue)}`];
    }

    return [`let ${declarations[0]} = ${writer.write(node.vInitialValue)}`];
  }
}

class TupleExpressionWriter extends CairoASTNodeWriter {
  writeInner(node: TupleExpression, writer: ASTWriter): SrcDesc {
    return [`(${node.vComponents.map((value) => writer.write(value)).join(', ')})`];
  }
}

class ContractInterfaceWriter extends CairoASTNodeWriter {
  writeInner(node: SourceUnit, writer: ASTWriter): SrcDesc {
    return [``];
  }
}

class ContractDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: ContractDefinition, writer: ASTWriter): SrcDesc {
    // @ts-ignore
    if (node.kind == ContractKind.Interface) {
      return [`Interfaces not implemented yet`];
    }

    const imports = importsWriter(this.imports);

    const structs = node.vStructs.map((value) => writer.write(value));

    const stateVars = node.vStateVariables.map((value) => writer.write(value));

    const functions = node.vFunctions.map((value) => writer.write(value));
    // todo create these structs
    return [[[imports], ...structs, ...stateVars, ...functions].join('\n\n\n')];
  }

  writeWhole(node: ContractDefinition, writer: ASTWriter): SrcDesc {
    return [`# Contract Def ${node.name}\n\n${this.writeInner(node, writer)}`];
  }
}

class NotImplementedWriter extends CairoASTNodeWriter {
  writeInner(node: ASTNode, _: ASTWriter): SrcDesc {
    console.log(`${node.type} not implemented yet`);
    return [``];
  }
}

class ParameterListWriter extends CairoASTNodeWriter {
  writeInner(node: ParameterList, writer: ASTWriter): SrcDesc {
    const params = node.vParameters.map((value) =>
      value.name ? `${value.name} : ${writer.write(value.vType)}` : `${writer.write(value.vType)}`,
    );
    return [params.join(', ')];
  }
}

class FunctionDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: FunctionDefinition, writer: ASTWriter): SrcDesc {
    let name = node.name;
    let decorator = [FunctionVisibility.Public, FunctionVisibility.External].includes(
      node.visibility,
    )
      ? [FunctionStateMutability.Pure, FunctionStateMutability.View].includes(node.stateMutability)
        ? '@view'
        : '@external'
      : '';
    const args = writer.write(node.vParameters);
    const body = node.vBody ? writer.write(node.vBody) : [];
    const returns = writer.write(node.vReturnParameters);
    switch (node.kind) {
      case FunctionKind.Constructor:
        decorator = '@constructor';
        name = 'constructor';
    }
    return [
      [
        ...(decorator ? [decorator] : []),
        `func ${name}(${args}) -> (${returns}):`,
        ...(body ? [body] : []),
        `end`,
      ].join('\n'),
    ];
  }
}

class BlockWriter extends CairoASTNodeWriter {
  writeInner(node: Block, writer: ASTWriter): SrcDesc {
    const INDENT = ' '.repeat(4);
    return [
      node.vStatements
        .map((value) => writer.write(value))
        .map((v) => INDENT + v)
        .join('\n'),
    ];
  }
}

class ReturnWriter extends CairoASTNodeWriter {
  writeInner(node: Return, writer: ASTWriter): SrcDesc {
    let returns =  "()";
    if (node.vExpression) {
      const expWriten = writer.write(node.vExpression);
      returns = node.vExpression instanceof TupleExpression ? expWriten : `(${expWriten})`
    }
    return [`return ${returns}`];
  }
}

class ExpressionStatementWriter extends CairoASTNodeWriter {
  writeInner(node: ExpressionStatement, writer: ASTWriter): SrcDesc {
    return [`${writer.write(node.vExpression)}`];
  }
}

class LiteralWriter extends CairoASTNodeWriter {
  writeInner(node: Literal, writer: ASTWriter): SrcDesc {
    switch (node.kind) {
      case LiteralKind.Number:
        switch (primitiveTypeToCairo(node.typeString)) {
          case 'Uint256':
            const [high, low] = divmod(parseInt(node.value, 10), Math.pow(2, 128));
            return [`Uint256(low=${low}, high=${high})`];
          case 'felt':
            return [`${parseInt(node.value, 10)}`];
        }
      case LiteralKind.Bool:
        return [node.value === 'true' ? '1' : '0'];
      case LiteralKind.String:
      case LiteralKind.UnicodeString:
        const cairoString = node.value
          .split('')
          .filter((v) => v.charCodeAt(0) < 127)
          .join('')
          .substring(0, 32);
        return [`"${cairoString}"`];
      case LiteralKind.HexString:
        console.log('HexStr not implemented yet');
        return ['<hexStr>'];
      // throw Error("Hexstring not implemented yet");
    }
  }
}

class IdentifierWriter extends CairoASTNodeWriter {
  writeInner(node: Identifier, _: ASTWriter): SrcDesc {
    return [`${node.name}`];
  }
}

class FunctionCallWriter extends CairoASTNodeWriter {
  writeInner(node: FunctionCall, writer: ASTWriter): SrcDesc {
    switch (node.kind) {
      case FunctionCallKind.FunctionCall:
      case FunctionCallKind.TypeConversion:
        const args = node.vArguments.map((v) => writer.write(v)).join(', ');
        const func = writer.write(node.vExpression);
        return [`${func}(${args})`];
      case FunctionCallKind.StructConstructorCall:
        console.log('StructConstructorCall is not implemented yet');
        return ['<FuntionallCall.StructConstructorCall>'];
    }
  }
}

class IndexAccessWriter extends CairoASTNodeWriter {
  writeInner(node: IndexAccess, writer: ASTWriter): SrcDesc {
    return [`${writer.write(node.vBaseExpression)}+${writer.write(node.vIndexExpression)}`];
  }
}

class UncheckedBlockWriter extends CairoASTNodeWriter {
  writeInner(node: UncheckedBlock, writer: ASTWriter): SrcDesc {
    const sttms = node.vStatements.map((v) => writer.write(v));
    return [`${sttms}`];
  }
}

class MemberAccessWriter extends CairoASTNodeWriter {
  writeInner(node: MemberAccess, writer: ASTWriter): SrcDesc {
    return [`${writer.write(node.vExpression)}.${node.memberName}`];
  }
}

class BinaryOperationWriter extends CairoASTNodeWriter {
  writeInner(node: BinaryOperation, writer: ASTWriter): SrcDesc {
    const args = [node.vLeftExpression, node.vRightExpression].map((v) => writer.write(v));
    return [`${args[0]} ${node.operator} ${args[1]}`];
  }
}

class AssignmentWriter extends CairoASTNodeWriter {
  writeInner(node: Assignment, writer: ASTWriter): SrcDesc {
    assert(node.operator === '=', `Unexpected operator ${node.operator}`);
    const nodes = [node.vLeftHandSide, node.vRightHandSide].map((v) => writer.write(v));
    return [`${nodes[0]} ${node.operator} ${nodes[1]}`];
  }
}

class CairoStorageVariableWriter extends CairoASTNodeWriter {
  writeInner(node: CairoStorageVariable, writer: ASTWriter): SrcDesc {
    if (node.isEnum) {
      console.log('CairoStorageVariable.isEnum');
      return ['<CairoStorageVariable.isEnum>'];
    }

    const name = writer.write(node.name);
    const args = node.args.map((v) => writer.write(v)).join(', ');
    switch (node.kind) {
      case CairoStorageVariableKind.Read:
        return [`${name}.read(${args})`];

      case CairoStorageVariableKind.Write:
        return [`${name}.write(${args})`];
    }
  }
}

class CairoAssertWriter extends CairoASTNodeWriter {
  writeInner(node: CairoAssert, writer: ASTWriter): SrcDesc {
    const args = [node.leftHandSide, node.rightHandSide].map((v) => writer.write(v));
    return [`${node.name} ${args[0]} ${node.assertEq ? '=' : '!='} ${args[1]}`];
  }
}

export const CairoASTMapping = (imports: Imports) =>
  new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([
    [ElementaryTypeName, new ElementaryTypeNameWriter()],
    [ArrayTypeName, new ArrayTypeNameWriter()],
    [Mapping, new MappingTypeNameWriter()],
    [UserDefinedTypeName, new UserDefinedTypeNameWriter()],
    [FunctionTypeName, new NotImplementedWriter()],
    [Literal, new LiteralWriter()],
    [Identifier, new IdentifierWriter()],
    [IdentifierPath, new NotImplementedWriter()],
    [FunctionCallOptions, new NotImplementedWriter()],
    [FunctionCall, new FunctionCallWriter()],
    [MemberAccess, new MemberAccessWriter()],
    [IndexAccess, new IndexAccessWriter()],
    [IndexRangeAccess, new NotImplementedWriter()],
    [UnaryOperation, new NotImplementedWriter()],
    [BinaryOperation, new BinaryOperationWriter()],
    [Conditional, new NotImplementedWriter()],
    [ElementaryTypeNameExpression, new NotImplementedWriter()],
    [NewExpression, new NotImplementedWriter()],
    [TupleExpression, new TupleExpressionWriter()],
    [ExpressionStatement, new ExpressionStatementWriter()],
    [Assignment, new AssignmentWriter()],
    [VariableDeclaration, new VariableDeclarationWriter()],
    [Block, new BlockWriter()],
    [UncheckedBlock, new UncheckedBlockWriter()],
    [VariableDeclarationStatement, new VariableDeclarationStatementWriter()],
    [IfStatement, new NotImplementedWriter()],
    [ForStatement, new NotImplementedWriter()],
    [WhileStatement, new NotImplementedWriter()],
    [DoWhileStatement, new NotImplementedWriter()],
    [Return, new ReturnWriter()],
    [EmitStatement, new NotImplementedWriter()],
    [RevertStatement, new NotImplementedWriter()],
    [PlaceholderStatement, new NotImplementedWriter()],
    [InlineAssembly, new NotImplementedWriter()],
    [TryCatchClause, new NotImplementedWriter()],
    [TryStatement, new NotImplementedWriter()],
    [Break, new NotImplementedWriter()],
    [Continue, new NotImplementedWriter()],
    [Throw, new NotImplementedWriter()],
    [ParameterList, new ParameterListWriter()],
    [ModifierInvocation, new NotImplementedWriter()],
    [OverrideSpecifier, new NotImplementedWriter()],
    [FunctionDefinition, new FunctionDefinitionWriter()],
    [ModifierDefinition, new NotImplementedWriter()],
    [ErrorDefinition, new NotImplementedWriter()],
    [EventDefinition, new NotImplementedWriter()],
    [StructDefinition, new StructDefinitionWriter()],
    [EnumValue, new NotImplementedWriter()],
    [EnumDefinition, new NotImplementedWriter()],
    [UsingForDirective, new NotImplementedWriter()],
    [InheritanceSpecifier, new NotImplementedWriter()],
    [ContractDefinition, new ContractDefinitionWriter(imports)],
    [StructuredDocumentation, new NotImplementedWriter()],
    [ImportDirective, new NotImplementedWriter()],
    [PragmaDirective, new NotImplementedWriter()],
    [SourceUnit, new NotImplementedWriter()],
    [CairoStorageVariable, new CairoStorageVariableWriter()],
    [CairoAssert, new CairoAssertWriter()],
  ]);
