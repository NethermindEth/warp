import assert = require('assert');
import {
  ASTNode,
  ASTNodeConstructor,
  FunctionKind,
  LiteralKind,
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
  ASTNodeWriter,
  ASTWriter,
  FunctionVisibility,
  FunctionStateMutability,
  SrcDesc,
  FunctionCallKind,
  getNodeType,
  MappingType,
  PointerType,
} from 'solc-typed-ast';
import { Imports } from './ast/visitor';
import {
  CairoAssert,
  CairoFunctionCall,
  CairoStorageVariable,
  CairoStorageVariableKind,
} from './ast/cairoNodes';
import { primitiveTypeToCairo, divmod, importsWriter, canonicalMangler } from './utils/utils';
import { getMappingTypes } from './utils/mappings';
import { cairoType, getCairoType } from './typeWriter';
import { writeImplicits } from './utils/implicits';
import { AST, FunctionImplicits } from './ast/mapper';

const INDENT = ' '.repeat(4);

type CairoWriterOptions = Omit<AST, 'ast'>;

export abstract class CairoASTNodeWriter extends ASTNodeWriter implements CairoWriterOptions {
  imports: Imports;
  functionImplicits: FunctionImplicits;
  compilerVersion: string;
  constructor(options: CairoWriterOptions) {
    super();
    Object.assign(this, options);
  }
}

class StructDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: StructDefinition, writer: ASTWriter): SrcDesc {
    return [
      [
        `struct ${canonicalMangler(node.canonicalName)}:`,
        ...node.vMembers
          .map(
            (value) =>
              `member ${value.name} : ${getCairoType(value, writer.targetCompilerVersion)}`,
          )
          .map((v) => INDENT + v),
        `end`,
      ].join('\n'),
    ];
  }
}

class VariableDeclarationWriter extends CairoASTNodeWriter {
  writeInner(node: VariableDeclaration, writer: ASTWriter): SrcDesc {
    if (node.stateVariable) {
      let vals = [];
      const nodeType = getNodeType(node.vType, writer.targetCompilerVersion);
      if (nodeType instanceof PointerType && nodeType.to instanceof MappingType) {
        vals = getMappingTypes(nodeType.to);
      } else {
        vals.push(nodeType);
      }
      vals = vals.map((value) => cairoType(value));
      const keys = vals.slice(0, vals.length - 1).map((t, i) => `key${i}: ${t}`);
      const returns = vals.slice(vals.length - 1, vals.length);
      return [
        [
          `@storage_var`,
          `func ${node.name}(${keys.join(', ')}) -> (res: ${returns[0]}):`,
          `end`,
        ].join('\n'),
      ];
    }

    return [`${node.name} : ${getCairoType(node, writer.targetCompilerVersion)}`];
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

class PragmaDirectiveWriter extends CairoASTNodeWriter {
  writeInner(_node: PragmaDirective, _writer: ASTWriter): SrcDesc {
    return [['%lang starknet', '%builtins pedersen range_check bitwise'].join('\n')];
  }
}

class SourceUnitWriter extends CairoASTNodeWriter {
  writeInner(node: SourceUnit, writer: ASTWriter): SrcDesc {
    const pragmas = node.vPragmaDirectives.map((v) => writer.write(v));

    const imports = importsWriter(this.imports);

    const contracts = node.vContracts.map((v) => writer.write(v));

    return [[...pragmas, [imports], ...contracts].join('\n\n\n')];
  }
}

function writeContractInterface(node: ContractDefinition, writer: ASTWriter): SrcDesc {
  const structs = node.vStructs.map((value) => writer.write(value));
  const functions = node.vFunctions.map((v) =>
    writer
      .write(v)
      .split('\n')
      .map((l) => INDENT + l)
      .join('\n'),
  );
  return [
    [
      ...structs,
      [`@contract_interface`, `namespace ${node.name}:`, ...functions, `end`].join('\n'),
    ].join('\n'),
  ];
}

class ContractDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: ContractDefinition, writer: ASTWriter): SrcDesc {
    if (node.kind == ContractKind.Interface) {
      return writeContractInterface(node, writer);
    }

    const structs = node.vStructs.map((value) => writer.write(value));

    const enums = node.vEnums.map((value) => writer.write(value));

    const stateVars = node.vStateVariables.map((value) => writer.write(value));

    const functions = node.vFunctions.map((value) => writer.write(value));
    // todo create these structs
    return [[...structs, ...enums, ...stateVars, ...functions].join('\n\n')];
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
    const params = node.vParameters.map((value, i) => {
      const tp = getCairoType(value, writer.targetCompilerVersion);
      return value.name ? `${value.name} : ${tp}` : `ret${i} : ${tp}`;
    });
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
    const writtenImplicits = writeImplicits(this.functionImplicits.get(node.name));
    const implicits = writtenImplicits ? `{${writtenImplicits}}` : '';
    switch (node.kind) {
      case FunctionKind.Constructor:
        decorator = '@constructor';
        name = 'constructor';
    }
    return [
      [
        ...(decorator ? [decorator] : []),
        `func ${name}${implicits}(${args}) -> (${returns}):`,
        `${INDENT}alloc_locals`,
        ...(body ? [body] : []),
        `end`,
      ].join('\n'),
    ];
  }
}

class BlockWriter extends CairoASTNodeWriter {
  writeInner(node: Block, writer: ASTWriter): SrcDesc {
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
    let returns = '()';
    if (node.vExpression) {
      const expWriten = writer.write(node.vExpression);
      returns = node.vExpression instanceof TupleExpression ? expWriten : `(${expWriten})`;
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
  writeInner(node: Literal, _: ASTWriter): SrcDesc {
    switch (node.kind) {
      case LiteralKind.Number:
        switch (primitiveTypeToCairo(node.typeString)) {
          case 'Uint256': {
            const [high, low] = divmod(parseInt(node.value, 10), Math.pow(2, 128));
            return [`Uint256(low=${low}, high=${high})`];
          }
          case 'felt':
            return [node.value];
          default:
            throw new Error('Attempted to write unexpected cairo type');
        }
      case LiteralKind.Bool:
        return [node.value === 'true' ? '1' : '0'];
      case LiteralKind.String:
      case LiteralKind.UnicodeString: {
        const cairoString = node.value
          .split('')
          .filter((v) => v.charCodeAt(0) < 127)
          .join('')
          .substring(0, 32);
        return [`"${cairoString}"`];
      }
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
    const exp = node.vExpression;
    if (exp instanceof Identifier) {
      if (
        exp.vIdentifierType === 'userDefined' &&
        exp.vReferencedDeclaration instanceof EnumDefinition
      ) {
        const defName = exp.vReferencedDeclaration.canonicalName;
        return [canonicalMangler(`${defName}.${node.memberName}`)];
      }
    }

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

class EnumDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: EnumDefinition, writer: ASTWriter): SrcDesc {
    return [
      [
        ...node.vMembers.map((v, i) => {
          const name = canonicalMangler(`${node.canonicalName}.${v.name}`);
          return `const ${name} = ${i}`;
        }),
      ].join('\n'),
    ];
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

export const CairoASTMapping = (options: CairoWriterOptions) =>
  new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([
    [ElementaryTypeName, new NotImplementedWriter(options)],
    [ArrayTypeName, new NotImplementedWriter(options)],
    [Mapping, new NotImplementedWriter(options)],
    [UserDefinedTypeName, new NotImplementedWriter(options)],
    [FunctionTypeName, new NotImplementedWriter(options)],
    [Literal, new LiteralWriter(options)],
    [Identifier, new IdentifierWriter(options)],
    [IdentifierPath, new NotImplementedWriter(options)],
    [FunctionCallOptions, new NotImplementedWriter(options)],
    [FunctionCall, new FunctionCallWriter(options)],
    [MemberAccess, new MemberAccessWriter(options)],
    [IndexAccess, new IndexAccessWriter(options)],
    [IndexRangeAccess, new NotImplementedWriter(options)],
    [UnaryOperation, new NotImplementedWriter(options)],
    [BinaryOperation, new BinaryOperationWriter(options)],
    [Conditional, new NotImplementedWriter(options)],
    [ElementaryTypeNameExpression, new NotImplementedWriter(options)],
    [NewExpression, new NotImplementedWriter(options)],
    [TupleExpression, new TupleExpressionWriter(options)],
    [ExpressionStatement, new ExpressionStatementWriter(options)],
    [Assignment, new AssignmentWriter(options)],
    [VariableDeclaration, new VariableDeclarationWriter(options)],
    [Block, new BlockWriter(options)],
    [UncheckedBlock, new UncheckedBlockWriter(options)],
    [VariableDeclarationStatement, new VariableDeclarationStatementWriter(options)],
    [IfStatement, new NotImplementedWriter(options)],
    [ForStatement, new NotImplementedWriter(options)],
    [WhileStatement, new NotImplementedWriter(options)],
    [DoWhileStatement, new NotImplementedWriter(options)],
    [Return, new ReturnWriter(options)],
    [EmitStatement, new NotImplementedWriter(options)],
    [RevertStatement, new NotImplementedWriter(options)],
    [PlaceholderStatement, new NotImplementedWriter(options)],
    [InlineAssembly, new NotImplementedWriter(options)],
    [TryCatchClause, new NotImplementedWriter(options)],
    [TryStatement, new NotImplementedWriter(options)],
    [Break, new NotImplementedWriter(options)],
    [Continue, new NotImplementedWriter(options)],
    [Throw, new NotImplementedWriter(options)],
    [ParameterList, new ParameterListWriter(options)],
    [ModifierInvocation, new NotImplementedWriter(options)],
    [OverrideSpecifier, new NotImplementedWriter(options)],
    [FunctionDefinition, new FunctionDefinitionWriter(options)],
    [ModifierDefinition, new NotImplementedWriter(options)],
    [ErrorDefinition, new NotImplementedWriter(options)],
    [EventDefinition, new NotImplementedWriter(options)],
    [StructDefinition, new StructDefinitionWriter(options)],
    [EnumValue, new NotImplementedWriter(options)],
    [EnumDefinition, new EnumDefinitionWriter(options)],
    [UsingForDirective, new NotImplementedWriter(options)],
    [InheritanceSpecifier, new NotImplementedWriter(options)],
    [ContractDefinition, new ContractDefinitionWriter(options)],
    [StructuredDocumentation, new NotImplementedWriter(options)],
    [ImportDirective, new NotImplementedWriter(options)],
    [PragmaDirective, new PragmaDirectiveWriter(options)],
    [SourceUnit, new SourceUnitWriter(options)],
    [CairoStorageVariable, new CairoStorageVariableWriter(options)],
    [CairoAssert, new CairoAssertWriter(options)],
    [CairoFunctionCall, new FunctionCallWriter(options)],
  ]);
