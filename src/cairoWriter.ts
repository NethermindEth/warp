import assert from 'assert';
import {
  ArrayType,
  ArrayTypeName,
  Assignment,
  ASTNode,
  ASTNodeConstructor,
  ASTNodeWriter,
  ASTWriter,
  BinaryOperation,
  Block,
  Break,
  Conditional,
  Continue,
  ContractDefinition,
  ContractKind,
  DataLocation,
  DoWhileStatement,
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  EmitStatement,
  EnumDefinition,
  EnumValue,
  ErrorDefinition,
  EventDefinition,
  ExpressionStatement,
  ForStatement,
  FunctionCall,
  FunctionCallKind,
  FunctionCallOptions,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionTypeName,
  FunctionVisibility,
  generalizeType,
  getNodeType,
  Identifier,
  IdentifierPath,
  IfStatement,
  ImportDirective,
  IndexAccess,
  IndexRangeAccess,
  InheritanceSpecifier,
  InlineAssembly,
  Literal,
  LiteralKind,
  Mapping,
  MappingType,
  MemberAccess,
  ModifierDefinition,
  ModifierInvocation,
  NewExpression,
  OverrideSpecifier,
  ParameterList,
  PlaceholderStatement,
  PointerType,
  Return,
  RevertStatement,
  SourceUnit,
  SrcDesc,
  StructDefinition,
  StructuredDocumentation,
  Throw,
  TryCatchClause,
  TryStatement,
  TupleExpression,
  UnaryOperation,
  UncheckedBlock,
  UserDefinedType,
  UserDefinedTypeName,
  UsingForDirective,
  VariableDeclaration,
  VariableDeclarationStatement,
  WhileStatement,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from './ast/ast';
import {
  CairoAssert,
  CairoContract,
  CairoFunctionDefinition,
  FunctionStubKind,
} from './ast/cairoNodes';
import { printNode } from './utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from './utils/cairoTypeSystem';
import { NotSupportedYetError, TranspileFailedError } from './utils/errors';
import { error, removeExcessNewlines } from './utils/formatting';
import { implicitOrdering, implicitTypes } from './utils/implicits';
import { getMappingTypes } from './utils/mappings';
import { isDynamicCallDataArray } from './utils/nodeTypeProcessing';
import { notNull, notUndefined } from './utils/typeConstructs';
import {
  canonicalMangler,
  divmod,
  isCairoConstant,
  isExternallyVisible,
  mangleOwnContractInterface,
  primitiveTypeToCairo,
} from './utils/utils';

const INDENT = ' '.repeat(4);
export const INCLUDE_CAIRO_DUMP_FUNCTIONS = false;

function getDocumentation(
  documentation: string | StructuredDocumentation | undefined,
  writer: ASTWriter,
): string {
  return documentation !== undefined
    ? typeof documentation === 'string'
      ? `# ${documentation.split('\n').join('\n#')}`
      : writer.write(documentation)
    : '';
}

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
        `struct ${canonicalMangler(node.name)}:`,
        ...node.vMembers
          .map(
            (value) =>
              `member ${value.name} : ${CairoType.fromSol(
                getNodeType(value, writer.targetCompilerVersion),
                this.ast,
                TypeConversionContext.StorageAllocation,
              )}`,
          )
          .map((v) => INDENT + v),
        `end`,
      ].join('\n'),
    ];
  }
}

class StructuredDocumentationWriter extends CairoASTNodeWriter {
  writeInner(node: StructuredDocumentation, _writer: ASTWriter): SrcDesc {
    return [`# ${node.text.split('\n').join('\n#')}`];
  }
}

class VariableDeclarationWriter extends CairoASTNodeWriter {
  writeInner(node: VariableDeclaration, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    if ((node.stateVariable || node.parent instanceof SourceUnit) && isCairoConstant(node)) {
      assert(node.vValue !== undefined, 'Constant should have a defined value.');
      const constantValue = writer.write(node.vValue);
      return [[documentation, `const ${node.name} = ${constantValue}`].join('\n')];
    }
    // TODO check that this can be removed
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
      vals = vals.map((value) => CairoType.fromSol(value, this.ast).toString());
      const keys = vals.slice(0, vals.length - 1).map((t, i) => `key${i}: ${t}`);
      const returns = vals.slice(vals.length - 1, vals.length);

      return [
        [
          documentation,
          `@storage_var`,
          `func ${node.name}(${keys.join(', ')}) -> (res: ${returns[0]}):`,
          `end`,
        ].join('\n'),
      ];
    }

    return [node.name];
  }
}

class VariableDeclarationStatementWriter extends CairoASTNodeWriter {
  writeInner(node: VariableDeclarationStatement, writer: ASTWriter): SrcDesc {
    assert(
      node.vInitialValue !== undefined,
      'Variables should be initialised. Did you use VariableDeclarationInitialiser?',
    );

    const documentation = getDocumentation(node.documentation, writer);
    const declarations = node.assignments.flatMap((id) => {
      if (id === null)
        throw new NotSupportedYetError(
          `VariableDeclarationStatements with gaps not implemented yet`,
        );
      const declaration = node.vDeclarations.find((decl) => decl.id === id);
      assert(declaration !== undefined, `Unable to find variable declaration for assignment ${id}`);
      const type = generalizeType(getNodeType(declaration, this.ast.compilerVersion))[0];
      if (
        type instanceof ArrayType &&
        type.size === undefined &&
        node.vInitialValue instanceof FunctionCall &&
        node.vInitialValue.vReferencedDeclaration instanceof FunctionDefinition &&
        node.vInitialValue.vReferencedDeclaration.visibility === FunctionVisibility.External
      ) {
        assert(
          declaration.storageLocation === DataLocation.CallData,
          `WARNING: declaration receiving calldata dynarray has location ${declaration.storageLocation}`,
        );
        const writtenVar = writer.write(declaration);
        return [`${writtenVar}_len`, writtenVar];
      } else {
        return [writer.write(declaration)];
      }
    });
    if (
      node.vInitialValue instanceof FunctionCall &&
      node.vInitialValue.vReferencedDeclaration instanceof CairoFunctionDefinition &&
      node.vInitialValue.vReferencedDeclaration.functionStubKind === FunctionStubKind.StructDefStub
    ) {
      // This local statement is needed since Cairo is not supporting member access of structs with let.
      // The type hint also needs to be placed there since Cairo's default type hint is a felt.
      return [
        [
          documentation,
          `local ${declarations.join(', ')} : ${
            node.vInitialValue.vReferencedDeclaration.name
          } = ${writer.write(node.vInitialValue)}`,
        ].join('\n'),
      ];
    } else if (declarations.length > 1 || node.vInitialValue instanceof FunctionCall) {
      return [
        [
          documentation,
          `let (${declarations.join(', ')}) = ${writer.write(node.vInitialValue)}`,
        ].join('\n'),
      ];
    }
    return [
      [documentation, `let ${declarations[0]} = ${writer.write(node.vInitialValue)}`].join('\n'),
    ];
  }
}

class IfStatementWriter extends CairoASTNodeWriter {
  writeInner(node: IfStatement, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    return [
      [
        documentation,
        `if ${writer.write(node.vCondition)} != 0:`,
        writer.write(node.vTrueBody),
        ...(node.vFalseBody ? ['else:', writer.write(node.vFalseBody)] : []),
        'end',
      ]
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

function writeImports(imports: Map<string, Set<string>>): string {
  return [...imports.entries()]
    .map(
      ([location, importedSymbols]) =>
        `from ${location} import ${[...importedSymbols.keys()].join(', ')}`,
    )
    .join('\n');
}

class SourceUnitWriter extends CairoASTNodeWriter {
  writeInner(node: SourceUnit, writer: ASTWriter): SrcDesc {
    const structs = [...node.vStructs, ...node.vContracts.flatMap((c) => c.vStructs)].map((v) =>
      writer.write(v),
    );

    const userDefinedConstants = node.vVariables
      .filter((v) => isCairoConstant(v))
      .map((value) => writer.write(value));

    const functions = node.vFunctions.map((v) => writer.write(v));

    const contracts = node.vContracts.map((v) => writer.write(v));

    const generatedUtilFunctions = this.ast.getUtilFuncGen(node).getGeneratedCode();
    const imports = writeImports(this.ast.getImports(node));
    return [
      removeExcessNewlines(
        [
          '%lang starknet',
          [imports],
          ...structs,
          ...userDefinedConstants,
          generatedUtilFunctions,
          ...functions,
          ...contracts,
        ].join('\n\n\n'),
        3,
      ),
    ];
  }
}

function writeContractInterface(node: ContractDefinition, writer: ASTWriter): SrcDesc {
  const documentation = getDocumentation(node.documentation, writer);
  const functions = node.vFunctions.map((v) =>
    writer
      .write(v)
      .split('\n')
      .filter((line) => line.trim().startsWith('func') || line.trim().startsWith('end'))
      .map((l) => INDENT + l)
      .join('\n'),
  );
  // Handle the workaround of genContractInterface function of externalContractInterfaceInserter.ts
  // Remove `@interface` to get the actual contract interface name
  const name = node.name.replace('@interface', '');
  return [
    [
      documentation,
      [`@contract_interface`, `namespace ${name}:`, ...functions, `end`].join('\n'),
    ].join('\n'),
  ];
}

class CairoContractWriter extends CairoASTNodeWriter {
  writeInner(node: CairoContract, writer: ASTWriter): SrcDesc {
    if (node.kind == ContractKind.Interface) {
      return writeContractInterface(node, writer);
    }
    if (node.abstract)
      return [
        `# This contract may be abstract, it may not implement an abstract parent's methods\n# completely or it may not invoke an inherited contract's constructor correctly.\n`,
      ];

    const dynamicVariables = [...node.dynamicStorageAllocations.entries()].map(
      ([decl, loc]) => `const ${decl.name} = ${loc}`,
    );
    const staticVariables = [...node.staticStorageAllocations.entries()].map(
      ([decl, loc]) => `const ${decl.name} = ${loc}`,
    );
    const variables = [
      `# Dynamic variables - Arrays and Maps`,
      ...dynamicVariables,
      `# Static variables`,
      ...staticVariables,
    ];

    const documentation = getDocumentation(node.documentation, writer);

    // Don't need to write structs, SourceUnitWriter so already

    const enums = node.vEnums.map((value) => writer.write(value));

    const userDefinedConstants = node.vStateVariables
      .filter((sv) => isCairoConstant(sv))
      .map((value) => writer.write(value));

    const functions = node.vFunctions.map((value) => writer.write(value));

    const events = node.vEvents.map((value) => writer.write(value));

    const body = [...variables, ...enums, ...userDefinedConstants, ...functions]
      .join('\n\n')
      .split('\n')
      .map((l) => (l.length > 0 ? INDENT + l : l))
      .join('\n');

    const storageCode =
      node.usedStorage > 0 || node.usedIds > 0
        ? [
            '@storage_var',
            'func WARP_STORAGE(index: felt) -> (val: felt):',
            'end',
            '@storage_var',
            'func WARP_USED_STORAGE() -> (val: felt):',
            'end',
            '@storage_var',
            'func WARP_NAMEGEN() -> (name: felt):',
            'end',
            'func readId{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (val: felt):',
            '    alloc_locals',
            '    let (id) = WARP_STORAGE.read(loc)',
            '    if id == 0:',
            '        let (id) = WARP_NAMEGEN.read()',
            '        WARP_NAMEGEN.write(id + 1)',
            '        WARP_STORAGE.write(loc, id + 1)',
            '        return (id + 1)',
            '    else:',
            '        return (id)',
            '    end',
            'end',
            ...(INCLUDE_CAIRO_DUMP_FUNCTIONS
              ? [
                  'func DUMP_WARP_STORAGE_ITER{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(length : felt, ptr: felt*):',
                  '    alloc_locals',
                  '    if length == 0:',
                  '        return ()',
                  '    end',
                  '    let index = length - 1',
                  '    let (read) = WARP_STORAGE.read(index)',
                  '    assert ptr[index] = read',
                  '    DUMP_WARP_STORAGE_ITER(index, ptr)',
                  '    return ()',
                  'end',
                  '@external',
                  'func DUMP_WARP_STORAGE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(length : felt) -> (data_len : felt, data: felt*):',
                  '    alloc_locals',
                  '    let (p: felt*) = alloc()',
                  '    DUMP_WARP_STORAGE_ITER(length, p)',
                  '    return (length, p)',
                  'end',
                ]
              : []),
          ].join('\n')
        : '';

    return [
      [documentation, ...events, storageCode, `namespace ${node.name}:\n\n${body}\n\nend`].join(
        '\n\n',
      ),
    ];
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
    const defContext =
      node.parent instanceof FunctionDefinition && isExternallyVisible(node.parent)
        ? TypeConversionContext.CallDataRef
        : TypeConversionContext.Ref;

    const params = node.vParameters.map((value) => {
      const varTypeConversionContext =
        value.storageLocation === DataLocation.CallData
          ? TypeConversionContext.CallDataRef
          : defContext;

      const tp = CairoType.fromSol(
        getNodeType(value, writer.targetCompilerVersion),
        this.ast,
        varTypeConversionContext,
      );
      if (tp instanceof CairoDynArray && node.parent instanceof FunctionDefinition) {
        return isExternallyVisible(node.parent)
          ? `${value.name}_len : ${tp.vLen.toString()}, ${value.name} : ${tp.vPtr.toString()}`
          : `${value.name} : ${tp.toString()}`;
      }
      return `${value.name} : ${tp}`;
    });
    return [params.join(', ')];
  }
}

class CairoFunctionDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: CairoFunctionDefinition, writer: ASTWriter): SrcDesc {
    if (node.functionStubKind !== FunctionStubKind.None) return [''];

    const documentation = getDocumentation(node.documentation, writer);
    const name = this.getName(node);
    const decorator = this.getDecorator(node);
    const args =
      node.kind !== FunctionKind.Fallback
        ? writer.write(node.vParameters)
        : 'selector : felt, calldata_size : felt, calldata : felt*';
    const body = this.getBody(node, writer);
    const returns = this.getReturns(node, writer);
    const implicits = this.getImplicits(node);

    return [
      [documentation, ...decorator, `func ${name}${implicits}(${args})${returns}:`, body, `end`]
        .filter(notNull)
        .join('\n'),
    ];
  }

  private getDecorator(node: CairoFunctionDefinition): string[] {
    if (node.kind === FunctionKind.Constructor) return ['@constructor'];
    const decorators: string[] = [];
    if (node.kind === FunctionKind.Fallback) {
      decorators.push('@raw_input');
      if (node.vParameters.vParameters.length > 0) decorators.push('@raw_output');
    }

    if (node.visibility === FunctionVisibility.External) {
      if (
        [FunctionStateMutability.Pure, FunctionStateMutability.View].includes(node.stateMutability)
      )
        decorators.push('@view');
      else decorators.push('@external');
    }

    return decorators;
  }

  private getName(node: CairoFunctionDefinition): string {
    if (node.kind === FunctionKind.Constructor) return 'constructor';
    if (node.kind === FunctionKind.Fallback) return '__default__';
    return node.name;
  }

  private getBody(node: CairoFunctionDefinition, writer: ASTWriter): string | null {
    if (node.vBody === undefined) return null;

    if (!isExternallyVisible(node) || !node.implicits.has('warp_memory')) {
      return ['alloc_locals', this.getConstructorStorageAllocation(node), writer.write(node.vBody)]
        .filter(notNull)
        .join('\n');
    }

    assert(node.vBody.children.length > 0, error(`${printNode(node)} has an empty body`));

    return [
      'alloc_locals',
      this.getConstructorStorageAllocation(node),
      'let (local warp_memory : DictAccess*) = default_dict_new(0)',
      'local warp_memory_start: DictAccess* = warp_memory',
      'dict_write{dict_ptr=warp_memory}(0,1)',
      'with warp_memory:',
      writer.write(node.vBody),
      'end',
    ]
      .flat()
      .filter(notNull)
      .join('\n');
  }

  private getReturns(node: CairoFunctionDefinition, writer: ASTWriter): string {
    if (node.kind === FunctionKind.Constructor) return '';
    return `-> (${writer.write(node.vReturnParameters)})`;
  }

  private getImplicits(node: CairoFunctionDefinition): string {
    // Function in interfaces should not have implicit arguments written out
    if (node.vScope instanceof ContractDefinition && node.vScope.kind === ContractKind.Interface) {
      return '';
    }

    const implicits = [...node.implicits.values()].filter(
      // External functions should not print the warp_memory implicit argument, even
      // if they use warp_memory internally. Instead their contents are wrapped
      // in code to initialise warp_memory
      (i) => !isExternallyVisible(node) || i !== 'warp_memory',
    );
    if (implicits.length === 0) return '';
    return `{${implicits
      .sort(implicitOrdering)
      .map((implicit) => `${implicit} : ${implicitTypes[implicit]}`)
      .join(', ')}}`;
  }

  private getConstructorStorageAllocation(node: CairoFunctionDefinition): string | null {
    if (node.kind === FunctionKind.Constructor) {
      const contract = node.vScope;
      assert(contract instanceof CairoContract);
      if (contract.usedStorage === 0 && contract.usedIds === 0) {
        return null;
      }
      return [
        contract.usedStorage === 0 ? '' : `WARP_USED_STORAGE.write(${contract.usedStorage})`,
        contract.usedIds === 0 ? '' : `WARP_NAMEGEN.write(${contract.usedIds})`,
      ].join(`\n`);
    }
    return null;
  }
}

class BlockWriter extends CairoASTNodeWriter {
  writeInner(node: Block, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    return [
      [
        documentation,
        node.vStatements
          .map((value) => writer.write(value))
          .map((v) =>
            v
              .split('\n')
              .map((line) => INDENT + line)
              .join('\n'),
          )
          .join('\n'),
      ].join('\n'),
    ];
  }
}

class ReturnWriter extends CairoASTNodeWriter {
  writeInner(node: Return, writer: ASTWriter): SrcDesc {
    let returns = '()';
    const documentation = getDocumentation(node.documentation, writer);
    if (node.vExpression) {
      const expWriten = writer.write(node.vExpression);
      returns =
        node.vExpression instanceof TupleExpression ||
        (node.vExpression instanceof FunctionCall &&
          node.vExpression.kind !== FunctionCallKind.StructConstructorCall)
          ? expWriten
          : `(${expWriten})`;
    }

    const finalizeWarpMemory = this.usesWarpMemory(node)
      ? 'default_dict_finalize(warp_memory_start, warp_memory, 0)\n'
      : '';

    return [[documentation, finalizeWarpMemory, `return ${returns}`].join('\n')];
  }

  private usesWarpMemory(node: Return): boolean {
    const parentFunc = node.getClosestParentByType(CairoFunctionDefinition);
    return (
      parentFunc instanceof CairoFunctionDefinition &&
      parentFunc.implicits.has('warp_memory') &&
      isExternallyVisible(parentFunc)
    );
  }
}

class ExpressionStatementWriter extends CairoASTNodeWriter {
  newVarCounter = 0;
  writeInner(node: ExpressionStatement, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    if (
      (node.vExpression instanceof FunctionCall &&
        node.vExpression.kind !== FunctionCallKind.StructConstructorCall) ||
      node.vExpression instanceof Assignment ||
      node.vExpression instanceof CairoAssert
    ) {
      return [[documentation, `${writer.write(node.vExpression)}`].join('\n')];
    } else {
      return [
        [
          documentation,
          `let __warp_uv${this.newVarCounter++} = ${writer.write(node.vExpression)}`,
        ].join('\n'),
      ];
    }
  }
}

class LiteralWriter extends CairoASTNodeWriter {
  writeInner(node: Literal, _: ASTWriter): SrcDesc {
    switch (node.kind) {
      case LiteralKind.Number:
        switch (primitiveTypeToCairo(node.typeString)) {
          case 'Uint256': {
            const [high, low] = divmod(BigInt(node.value), BigInt(Math.pow(2, 128)));
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
        return [`'${cairoString}'`];
      }
      case LiteralKind.HexString:
        this.logNotImplemented('HexStr not implemented yet');
        return ['<hexStr>'];
    }
  }
}

class IndexAccessWriter extends CairoASTNodeWriter {
  writeInner(node: IndexAccess, writer: ASTWriter): SrcDesc {
    assert(node.vIndexExpression !== undefined);
    const baseWritten = writer.write(node.vBaseExpression);
    const indexWritten = writer.write(node.vIndexExpression);
    if (isDynamicCallDataArray(getNodeType(node.vBaseExpression, this.ast.compilerVersion))) {
      return [`${baseWritten}.ptr[${indexWritten}]`];
    }
    return [`${baseWritten}[${indexWritten}]`];
  }
}
class IdentifierWriter extends CairoASTNodeWriter {
  writeInner(node: Identifier, _: ASTWriter): SrcDesc {
    if (
      isDynamicCallDataArray(getNodeType(node, this.ast.compilerVersion)) &&
      ((node.getClosestParentByType(Return) !== undefined &&
        node.getClosestParentByType(IndexAccess) === undefined &&
        node.getClosestParentByType(FunctionDefinition)?.visibility ===
          FunctionVisibility.External &&
        node.getClosestParentByType(IndexAccess) === undefined &&
        node.getClosestParentByType(MemberAccess) === undefined) ||
        (node.parent instanceof FunctionCall &&
          node.parent.vReferencedDeclaration instanceof FunctionDefinition &&
          node.parent.vReferencedDeclaration.visibility === FunctionVisibility.External))
    ) {
      return [`${node.name}.len, ${node.name}.ptr`];
    }
    return [`${node.name}`];
  }
}

class FunctionCallWriter extends CairoASTNodeWriter {
  writeInner(node: FunctionCall, writer: ASTWriter): SrcDesc {
    const args = node.vArguments.map((v) => writer.write(v)).join(', ');
    const func = writer.write(node.vExpression);
    switch (node.kind) {
      case FunctionCallKind.FunctionCall: {
        if (node.vExpression instanceof MemberAccess) {
          // check if node.vExpression.vExpression.typeString includes "contract"
          const nodeType = getNodeType(node.vExpression.vExpression, writer.targetCompilerVersion);
          if (
            nodeType instanceof UserDefinedType &&
            nodeType.definition instanceof ContractDefinition
          ) {
            const currentContract = node.getClosestParentByType(ContractDefinition);
            const contractType = nodeType.definition.name;
            const memberName = node.vExpression.memberName;
            const contract = writer.write(node.vExpression.vExpression);
            return [
              `${
                currentContract?.name === contractType
                  ? mangleOwnContractInterface(currentContract)
                  : contractType
              }.${memberName}(${contract}${args ? ', ' : ''}${args})`,
            ];
          }
        } else if (
          node.vReferencedDeclaration instanceof CairoFunctionDefinition &&
          node.vReferencedDeclaration.acceptsRawDarray
        ) {
          return [`${func}(${args}_len, ${args})`];
        }
        return [`${func}(${args})`];
      }
      case FunctionCallKind.StructConstructorCall:
        return [`${func}(${args})`];

      case FunctionCallKind.TypeConversion: {
        const arg = node.vArguments[0];
        if (node.vFunctionName === 'address' && arg instanceof Literal) {
          const val = BigInt(arg.value);
          // Make sure literal < 2**251
          assert(val < BigInt('0x800000000000000000000000000000000000000000000000000000000000000'));
          return [`${args[0]}`];
        }
        const nodeType = getNodeType(node.vExpression, writer.targetCompilerVersion);
        if (
          nodeType instanceof UserDefinedType &&
          nodeType.definition instanceof ContractDefinition
        ) {
          return [`${args}`];
        }
        return [`${func}(${args})`];
      }
    }
  }
}

class UncheckedBlockWriter extends CairoASTNodeWriter {
  writeInner(node: UncheckedBlock, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    return [
      [
        documentation,
        node.vStatements
          .map((value) => writer.write(value))
          .map((v) =>
            v
              .split('\n')
              .map((line) => INDENT + line)
              .join('\n'),
          )
          .join('\n'),
      ].join('\n'),
    ];
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
    return [`let ${nodes[0]} ${node.operator} ${nodes[1]}`];
  }
}

class EnumDefinitionWriter extends CairoASTNodeWriter {
  writeInner(_node: EnumDefinition, _writer: ASTWriter): SrcDesc {
    // EnumDefinition nodes do not need to be printed because they would have been replaced by integer literals.
    return [``];
  }
}

class EventDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: EventDefinition, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    const args: string = writer.write(node.vParameters);
    return [
      [
        documentation,
        `@event`,
        `func ${node.name}_${node.canonicalSignatureHash(ABIEncoderVersion.V2)}(${args}):`,
        `end`,
      ].join('\n'),
    ];
  }
}

class EmitStatementWriter extends CairoASTNodeWriter {
  writeInner(node: EmitStatement, writer: ASTWriter): SrcDesc {
    const eventDef = node.vEventCall.vReferencedDeclaration;
    assert(eventDef instanceof EventDefinition, `Expected EventDefintion as referenced type`);

    const documentation = getDocumentation(node.documentation, writer);
    const args: string = node.vEventCall.vArguments.map((v) => writer.write(v)).join(', ');
    return [
      [
        documentation,
        `${node.vEventCall.vFunctionName}_${eventDef.canonicalSignatureHash(
          ABIEncoderVersion.V2,
        )}.emit(${args})`,
      ].join('\n'),
    ];
  }
}

class CairoAssertWriter extends CairoASTNodeWriter {
  writeInner(node: CairoAssert, writer: ASTWriter): SrcDesc {
    const assertExpr = `assert ${writer.write(node.vExpression)} = 1`;

    if (node.assertMessage === null) {
      return [assertExpr];
    } else {
      return [
        [`with_attr error_message("${node.assertMessage}"):`, `${INDENT}${assertExpr}`, `end`].join(
          '\n',
        ),
      ];
    }
  }
}

class ElementaryTypeNameExpressionWriter extends CairoASTNodeWriter {
  writeInner(_node: ElementaryTypeNameExpression, _writer: ASTWriter): SrcDesc {
    //ElementaryTypeNameExpressions left in the tree by this point being unreferenced expressions, and that this needs to work with out ineffectual statement handling
    return ['0'];
  }
}

export const CairoASTMapping = (ast: AST, throwOnUnimplemented: boolean) =>
  new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([
    [ArrayTypeName, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Assignment, new AssignmentWriter(ast, throwOnUnimplemented)],
    [BinaryOperation, new BinaryOperationWriter(ast, throwOnUnimplemented)],
    [Block, new BlockWriter(ast, throwOnUnimplemented)],
    [Break, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [CairoAssert, new CairoAssertWriter(ast, throwOnUnimplemented)],
    [CairoContract, new CairoContractWriter(ast, throwOnUnimplemented)],
    [CairoFunctionDefinition, new CairoFunctionDefinitionWriter(ast, throwOnUnimplemented)],
    [Conditional, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Continue, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [DoWhileStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [ElementaryTypeName, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [
      ElementaryTypeNameExpression,
      new ElementaryTypeNameExpressionWriter(ast, throwOnUnimplemented),
    ],
    [EmitStatement, new EmitStatementWriter(ast, throwOnUnimplemented)],
    [EnumDefinition, new EnumDefinitionWriter(ast, throwOnUnimplemented)],
    [EnumValue, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [ErrorDefinition, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [EventDefinition, new EventDefinitionWriter(ast, throwOnUnimplemented)],
    [ExpressionStatement, new ExpressionStatementWriter(ast, throwOnUnimplemented)],
    [ForStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [FunctionCall, new FunctionCallWriter(ast, throwOnUnimplemented)],
    [FunctionCallOptions, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [FunctionTypeName, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Identifier, new IdentifierWriter(ast, throwOnUnimplemented)],
    [IdentifierPath, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [IfStatement, new IfStatementWriter(ast, throwOnUnimplemented)],
    [ImportDirective, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [IndexAccess, new IndexAccessWriter(ast, throwOnUnimplemented)],
    [IndexRangeAccess, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [InheritanceSpecifier, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [InlineAssembly, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Literal, new LiteralWriter(ast, throwOnUnimplemented)],
    [Mapping, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [MemberAccess, new MemberAccessWriter(ast, throwOnUnimplemented)],
    [ModifierDefinition, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [ModifierInvocation, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [NewExpression, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [OverrideSpecifier, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [ParameterList, new ParameterListWriter(ast, throwOnUnimplemented)],
    [PlaceholderStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [Return, new ReturnWriter(ast, throwOnUnimplemented)],
    [RevertStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [SourceUnit, new SourceUnitWriter(ast, throwOnUnimplemented)],
    [StructDefinition, new StructDefinitionWriter(ast, throwOnUnimplemented)],
    [StructuredDocumentation, new StructuredDocumentationWriter(ast, throwOnUnimplemented)],
    [Throw, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [TryCatchClause, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [TryStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [TupleExpression, new TupleExpressionWriter(ast, throwOnUnimplemented)],
    [UnaryOperation, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [UncheckedBlock, new UncheckedBlockWriter(ast, throwOnUnimplemented)],
    [UserDefinedTypeName, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [UsingForDirective, new NotImplementedWriter(ast, throwOnUnimplemented)],
    [VariableDeclaration, new VariableDeclarationWriter(ast, throwOnUnimplemented)],
    [
      VariableDeclarationStatement,
      new VariableDeclarationStatementWriter(ast, throwOnUnimplemented),
    ],
    [WhileStatement, new NotImplementedWriter(ast, throwOnUnimplemented)],
  ]);
