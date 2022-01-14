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
import { CairoAssert, CairoContract, CairoFunctionDefinition } from './ast/cairoNodes';
import { primitiveTypeToCairo, divmod, importsWriter, canonicalMangler } from './utils/utils';
import { getMappingTypes } from './utils/mappings';
import { cairoType, getCairoType } from './typeWriter';
import { Implicits, writeImplicits } from './utils/implicits';
import { NotSupportedYetError, TranspileFailedError } from './utils/errors';
import { AST } from './ast/ast';
import { notUndefined } from './utils/typeConstructs';
import { printNode } from './utils/astPrinter';

const INDENT = ' '.repeat(4);

export abstract class CairoASTNodeWriter extends ASTNodeWriter {
  ast: AST;
  throwOnUnimplemented: boolean;
  constructor(ast: AST, throwOnUnimplemented: boolean) {
    super();
    this.ast = ast;
    this.throwOnUnimplemented = throwOnUnimplemented;
  }

  logNotImplemented(message: string) {
    if (this.throwOnUnimplemented) {
      throw new NotSupportedYetError(message);
    } else {
      console.log(message);
    }
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
      assert(
        node.vType !== undefined,
        'VariableDeclaration.vType should only be undefined for Solidity < 0.5.0',
      );
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
    assert(
      node.vInitialValue !== undefined,
      'Variables should be initialised. Did you use VariableDeclarationInitialiser?',
    );

    const declarations = node.vDeclarations.map((value) => writer.write(value));
    if (node.vDeclarations.length > 1 || node.vInitialValue instanceof FunctionCall) {
      return [`let (${declarations.join(', ')}) = ${writer.write(node.vInitialValue)}`];
    }

    return [`let ${declarations[0]} = ${writer.write(node.vInitialValue)}`];
  }
}

// This avoids revoked reference in simple situations, but not comprehensively
// TODO handle if reference revoking
class IfStatementWriter extends CairoASTNodeWriter {
  writeInner(node: IfStatement, writer: ASTWriter): SrcDesc {
    const saveImplicits = [...this.ast.getImplicitsAt(node)].map(
      (implicit: Implicits) => `${INDENT}tempvar ${implicit} = ${implicit}`,
    );
    const trueBody = writer.write(node.vTrueBody).split('\n');
    const falseBody =
      node.vFalseBody === undefined ? [] : writer.write(node.vFalseBody).split('\n');
    [trueBody, falseBody].forEach((statements) => {
      const last = statements.pop();
      if (last === undefined) {
        statements.push(...saveImplicits);
      } else if (last.trim().startsWith('return')) {
        statements.push(...saveImplicits);
        statements.push(last);
      } else {
        statements.push(last);
        statements.push(...saveImplicits);
      }
    });
    return [
      [`if ${writer.write(node.vCondition)} != 0:`, ...trueBody, 'else:', ...falseBody, 'end']
        .filter(notUndefined)
        .flat()
        .join('\n'),
    ];
  }
}

class TupleExpressionWriter extends CairoASTNodeWriter {
  writeInner(node: TupleExpression, writer: ASTWriter): SrcDesc {
    return [`(${node.vComponents.map((value) => writer.write(value)).join(', ')})`];
  }
}

class SourceUnitWriter extends CairoASTNodeWriter {
  writeInner(node: SourceUnit, writer: ASTWriter): SrcDesc {
    const builtins = this.ast.getRequiredBuiltins();
    const builtinsDirective =
      builtins.size === 0 ? '' : [...builtins].reduce((acc, b) => `${acc} ${b}`, '%builtins');

    const imports = importsWriter(this.ast.imports);

    const generatedUtilFunctions = this.ast.cairoUtilFuncGen.write();

    const structs = node.vStructs.map((v) => writer.write(v));

    const functions = node.vFunctions.map((v) => writer.write(v));

    const contracts = node.vContracts.map((v) => writer.write(v));

    return [
      [
        '%lang starknet',
        builtinsDirective,
        [imports],
        generatedUtilFunctions,
        ...structs,
        ...functions,
        ...contracts,
      ].join('\n\n\n'),
    ];
  }
}

function writeContractInterface(node: ContractDefinition, writer: ASTWriter): SrcDesc {
  const structs = node.vStructs.map((value) => writer.write(value));
  const functions = node.vFunctions.map((v) =>
    writer
      .write(v)
      .split('\n')
      .filter((line) => line.trim().startsWith('func') || line.trim().startsWith('end'))
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

class CairoContractWriter extends CairoASTNodeWriter {
  writeInner(node: CairoContract, writer: ASTWriter): SrcDesc {
    if (node.kind == ContractKind.Interface) {
      return writeContractInterface(node, writer);
    }

    // TODO handle cases where solidity contract defined a constructor
    const constructor = node.hasConstructor
      ? [
          '@constructor',
          'func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():',
          writer.write(node.initialisationBlock),
          '    return()',
          'end',
        ].join('\n')
      : '';

    const structs = node.vStructs.map((value) => writer.write(value));

    const enums = node.vEnums.map((value) => writer.write(value));

    const functions = node.vFunctions.map((value) => writer.write(value));
    // todo create these structs
    return [[constructor, ...structs, ...enums, ...functions].join('\n\n')];
  }

  writeWhole(node: CairoContract, writer: ASTWriter): SrcDesc {
    return [`# Contract Def ${node.name}\n\n${this.writeInner(node, writer)}`];
  }
}

class NotImplementedWriter extends CairoASTNodeWriter {
  writeInner(node: ASTNode, _: ASTWriter): SrcDesc {
    this.logNotImplemented(
      `${node.type} to cairo not implemented yet (found at ${printNode(node)})`,
    );
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

class CairoFunctionDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: CairoFunctionDefinition, writer: ASTWriter): SrcDesc {
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
    const warpMemory = node.implicits.has('warp_memory');
    if (warpMemory) node.implicits.delete('warp_memory');
    const writtenImplicits = writeImplicits(node.implicits);
    const implicits = writtenImplicits ? `{${writtenImplicits}}` : '';
    let returnClause = ` -> (${returns})`;
    switch (node.kind) {
      case FunctionKind.Constructor:
        decorator = '@constructor';
        name = 'constructor';
        returnClause = '';
    }
    return [
      [
        ...(decorator ? [decorator] : []),
        `func ${name}${implicits}(${args})${returnClause}:`,
        `${INDENT}alloc_locals`,
        ...(warpMemory
          ? ['let (local warp_memory : MemCell*) = warp_memory_init()', 'with warp_memory:']
          : []),
        ...(body ? [body] : []),
        ...(warpMemory ? ['end'] : []),
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
        .map((v) =>
          v
            .split('\n')
            .map((line) => INDENT + line)
            .join('\n'),
        )
        .join('\n'),
    ];
  }
}

class ReturnWriter extends CairoASTNodeWriter {
  writeInner(node: Return, writer: ASTWriter): SrcDesc {
    let returns = '()';
    if (node.vExpression) {
      const expWriten = writer.write(node.vExpression);
      returns =
        node.vExpression instanceof TupleExpression || node.vExpression instanceof FunctionCall
          ? expWriten
          : `(${expWriten})`;
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
            throw new TranspileFailedError('Attempted to write unexpected cairo type');
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
        this.logNotImplemented('HexStr not implemented yet');
        return ['<hexStr>'];
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
      case FunctionCallKind.TypeConversion: {
        const args = node.vArguments.map((v) => writer.write(v)).join(', ');
        const func = writer.write(node.vExpression);
        return [`${func}(${args})`];
      }
      case FunctionCallKind.StructConstructorCall:
        this.logNotImplemented('StructConstructorCall is not implemented yet');
        return ['<FuntionallCall.StructConstructorCall>'];
    }
  }
}

class UncheckedBlockWriter extends CairoASTNodeWriter {
  writeInner(node: UncheckedBlock, writer: ASTWriter): SrcDesc {
    return [
      node.vStatements
        .map((value) => writer.write(value))
        .map((v) =>
          v
            .split('\n')
            .map((line) => INDENT + line)
            .join('\n'),
        )
        .join('\n'),
    ];
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
    return [`let ${nodes[0]} ${node.operator} ${nodes[1]}`];
  }
}

class EnumDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: EnumDefinition, _writer: ASTWriter): SrcDesc {
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

class CairoAssertWriter extends CairoASTNodeWriter {
  writeInner(node: CairoAssert, writer: ASTWriter): SrcDesc {
    const args = [node.leftHandSide, node.rightHandSide].map((v) => writer.write(v));
    return [`${node.name} ${args[0]} ${node.assertEq ? '=' : '!='} ${args[1]}`];
  }
}

export const CairoASTMapping = (ast: AST, throwOnUnimplemented: boolean) =>
  new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([
    [ElementaryTypeName, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [ArrayTypeName, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Mapping, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [UserDefinedTypeName, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [FunctionTypeName, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Literal, new LiteralWriter(ast, throwOnUnimplemented)],
    [Identifier, new IdentifierWriter(ast, throwOnUnimplemented)],
    [IdentifierPath, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [FunctionCallOptions, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [FunctionCall, new FunctionCallWriter(ast, throwOnUnimplemented)],
    [MemberAccess, new MemberAccessWriter(ast, throwOnUnimplemented)],
    [IndexAccess, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [IndexRangeAccess, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [UnaryOperation, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [BinaryOperation, new BinaryOperationWriter(ast, throwOnUnimplemented)],
    [Conditional, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [ElementaryTypeNameExpression, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [NewExpression, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [TupleExpression, new TupleExpressionWriter(ast, throwOnUnimplemented)],
    [ExpressionStatement, new ExpressionStatementWriter(ast, throwOnUnimplemented)],
    [Assignment, new AssignmentWriter(ast, throwOnUnimplemented)],
    [VariableDeclaration, new VariableDeclarationWriter(ast, throwOnUnimplemented)],
    [Block, new BlockWriter(ast, throwOnUnimplemented)],
    [UncheckedBlock, new UncheckedBlockWriter(ast, throwOnUnimplemented)],
    [
      VariableDeclarationStatement,
      new VariableDeclarationStatementWriter(ast, throwOnUnimplemented),
    ],
    [IfStatement, new IfStatementWriter(ast, throwOnUnimplemented)],
    [ForStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [WhileStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [DoWhileStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Return, new ReturnWriter(ast, throwOnUnimplemented)],
    [EmitStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [RevertStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [PlaceholderStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [InlineAssembly, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [TryCatchClause, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [TryStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Break, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Continue, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Throw, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [ParameterList, new ParameterListWriter(ast, throwOnUnimplemented)],
    [ModifierInvocation, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [OverrideSpecifier, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [CairoFunctionDefinition, new CairoFunctionDefinitionWriter(ast, throwOnUnimplemented)],
    [ModifierDefinition, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [ErrorDefinition, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [EventDefinition, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [StructDefinition, new StructDefinitionWriter(ast, throwOnUnimplemented)],
    [EnumValue, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [EnumDefinition, new EnumDefinitionWriter(ast, throwOnUnimplemented)],
    [UsingForDirective, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [InheritanceSpecifier, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [CairoContract, new CairoContractWriter(ast, throwOnUnimplemented)],
    [StructuredDocumentation, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [ImportDirective, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [SourceUnit, new SourceUnitWriter(ast, throwOnUnimplemented)],
    [CairoAssert, new CairoAssertWriter(ast, throwOnUnimplemented)],
  ]);
