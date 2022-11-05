import assert from 'assert';
import {
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
  ExternalReferenceType,
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
  MemberAccess,
  ModifierDefinition,
  ModifierInvocation,
  NewExpression,
  OverrideSpecifier,
  ParameterList,
  PlaceholderStatement,
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
  TupleType,
  TypeNode,
  UnaryOperation,
  UncheckedBlock,
  UserDefinedType,
  UserDefinedTypeName,
  UsingForDirective,
  VariableDeclaration,
  VariableDeclarationStatement,
  WhileStatement,
} from 'solc-typed-ast';
import { AST } from './ast/ast';
import {
  CairoAssert,
  CairoContract,
  CairoFunctionDefinition,
  FunctionStubKind,
} from './ast/cairoNodes';
import { CairoTempVar } from './ast/cairoNodes/tempvar';
import { getStructsAndRemappings } from './freeStructWritter';
import { printNode } from './utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from './utils/cairoTypeSystem';
import { NotSupportedYetError, TranspileFailedError } from './utils/errors';
import { error, removeExcessNewlines } from './utils/formatting';
import { implicitOrdering, implicitTypes } from './utils/implicits';
import {
  isDynamicArray,
  isDynamicCallDataArray,
  safeGetNodeType,
} from './utils/nodeTypeProcessing';
import { notNull, notUndefined } from './utils/typeConstructs';
import {
  divmod,
  isCairoConstant,
  isExternallyVisible,
  mergeImports,
  primitiveTypeToCairo,
  isExternalCall,
  mangleStructName,
  isCalldataDynArrayStruct,
  isExternalMemoryDynArray,
} from './utils/utils';

const INDENT = ' '.repeat(4);
export const INCLUDE_CAIRO_DUMP_FUNCTIONS = false;

function getDocumentation(
  documentation: string | StructuredDocumentation | undefined,
  writer: ASTWriter,
): string {
  return documentation !== undefined
    ? typeof documentation === 'string'
      ? `// ${documentation.split('\n').join('\n//')}`
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
        `struct ${mangleStructName(node)}{`,
        ...node.vMembers
          .map(
            (value) =>
              `${value.name} : ${CairoType.fromSol(
                safeGetNodeType(value, writer.targetCompilerVersion),
                this.ast,
                TypeConversionContext.StorageAllocation,
              )},`,
          )
          .map((v) => INDENT + v),
        `}`,
      ].join('\n'),
    ];
  }
}

class StructuredDocumentationWriter extends CairoASTNodeWriter {
  writeInner(node: StructuredDocumentation, _writer: ASTWriter): SrcDesc {
    return [`// ${node.text.split('\n').join('\n//')}`];
  }
}

class VariableDeclarationWriter extends CairoASTNodeWriter {
  writeInner(node: VariableDeclaration, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    if ((node.stateVariable || node.parent instanceof SourceUnit) && isCairoConstant(node)) {
      assert(node.vValue !== undefined, 'Constant should have a defined value.');
      const constantValue = writer.write(node.vValue);
      return [[documentation, `const ${node.name} = ${constantValue};`].join('\n')];
    }

    return [node.name];
  }
}

class VariableDeclarationStatementWriter extends CairoASTNodeWriter {
  gapVarCounter = 0;
  writeInner(node: VariableDeclarationStatement, writer: ASTWriter): SrcDesc {
    assert(
      node.vInitialValue !== undefined,
      'Variables should be initialised. Did you use VariableDeclarationInitialiser?',
    );

    const documentation = getDocumentation(node.documentation, writer);
    const initialValueType = safeGetNodeType(node.vInitialValue, this.ast.compilerVersion);

    const getValueN = (n: number): TypeNode => {
      if (initialValueType instanceof TupleType) {
        return initialValueType.elements[n];
      } else if (n === 0) return initialValueType;
      throw new TranspileFailedError(
        `Attempted to extract value at index ${n} of non-tuple return`,
      );
    };

    const getDeclarationForId = (id: number): VariableDeclaration => {
      const declaration = node.vDeclarations.find((decl) => decl.id === id);
      assert(declaration !== undefined, `Unable to find variable declaration for assignment ${id}`);
      return declaration;
    };

    const declarations = node.assignments.flatMap((id, index) => {
      const type = generalizeType(getValueN(index))[0];
      if (
        isDynamicArray(type) &&
        node.vInitialValue instanceof FunctionCall &&
        isExternalCall(node.vInitialValue)
      ) {
        if (id === null) {
          const uniqueSuffix = this.gapVarCounter++;
          return [`__warp_gv_len${uniqueSuffix}`, `__warp_gv${uniqueSuffix}`];
        }
        const declaration = getDeclarationForId(id);
        assert(
          declaration.storageLocation === DataLocation.CallData,
          `WARNING: declaration receiving calldata dynarray has location ${declaration.storageLocation}`,
        );
        const writtenVar = writer.write(declaration);
        return [`${writtenVar}_len`, writtenVar];
      } else {
        if (id === null) {
          return [`__warp_gv${this.gapVarCounter++}`];
        }
        return [writer.write(getDeclarationForId(id))];
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
          } = ${writer.write(node.vInitialValue)};`,
        ].join('\n'),
      ];
    } else if (declarations.length > 1 || node.vInitialValue instanceof FunctionCall) {
      return [
        [
          documentation,
          `let (${declarations.join(', ')}) = ${writer.write(node.vInitialValue)};`,
        ].join('\n'),
      ];
    }
    return [
      [documentation, `let ${declarations[0]} = ${writer.write(node.vInitialValue)};`].join('\n'),
    ];
  }
}

class IfStatementWriter extends CairoASTNodeWriter {
  writeInner(node: IfStatement, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    return [
      [
        documentation,
        `if (${writer.write(node.vCondition)} != 0){`,
        writer.write(node.vTrueBody),
        ...(node.vFalseBody ? ['}else{', writer.write(node.vFalseBody)] : []),
        '}',
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
  if (INCLUDE_CAIRO_DUMP_FUNCTIONS) {
    imports = mergeImports(
      imports,
      new Map([['starkware.cairo.common.alloc', new Set(['alloc'])]]),
    );
  }
  return [...imports.entries()]
    .map(
      ([location, importedSymbols]) =>
        `from ${location} import ${[...importedSymbols.keys()].join(', ')}`,
    )
    .join('\n');
}

const interfaceNameMappings: Map<SourceUnit, Map<string, string>> = new Map();

function generateInterfaceNameMappings(node: SourceUnit) {
  const map: Map<string, string> = new Map();
  const existingNames = node.vContracts
    .filter((c) => c.kind !== ContractKind.Interface)
    .map((c) => c.name);

  node.vContracts
    .filter((c) => c.kind === ContractKind.Interface)
    .forEach((c) => {
      const baseName = c.name.replace('@interface', '');
      const interfaceName = `${baseName}_warped_interface`;
      if (!existingNames.includes(baseName)) {
        map.set(baseName, interfaceName);
      } else {
        let i = 1;
        while (existingNames.includes(`${interfaceName}_${i}`)) ++i;
        map.set(baseName, `${interfaceName}_${i}`);
      }
    });

  interfaceNameMappings.set(node, map);
}

function getInterfaceNameForContract(contractName: string, nodeInSourceUnit: ASTNode): string {
  const sourceUnit =
    nodeInSourceUnit instanceof SourceUnit
      ? nodeInSourceUnit
      : nodeInSourceUnit.getClosestParentByType(SourceUnit);

  assert(
    sourceUnit !== undefined,
    `Unable to find source unit for interface ${contractName} while writing`,
  );

  const interfaceName = interfaceNameMappings.get(sourceUnit)?.get(contractName);
  assert(
    interfaceName !== undefined,
    `An error occured during name substitution for the interface ${contractName}`,
  );

  return interfaceName;
}

let structRemappings: Map<number, string>;

class SourceUnitWriter extends CairoASTNodeWriter {
  writeInner(node: SourceUnit, writer: ASTWriter): SrcDesc {
    generateInterfaceNameMappings(node);

    // Every sourceUnit should only define a single contract
    const mainContract_ = node.vContracts.filter((cd) => cd.kind !== ContractKind.Interface);
    assert(mainContract_.length <= 1, 'There should only be one active contract per sourceUnit');
    const [mainContract] = mainContract_;

    const [freeStructs, freeStructRemappings_] = mainContract
      ? getStructsAndRemappings(node, this.ast)
      : [[], new Map()];
    structRemappings = freeStructRemappings_;

    // Only constants generated by `newToDeploy` exist at this stage
    const constants = node.vVariables.flatMap((v) => {
      assert(v.vValue !== undefined, 'Constants cannot be unanssigned');
      return [`// ${v.documentation}`, `const ${v.name} = ${writer.write(v.vValue)};`].join('\n');
    });

    const structs = [...freeStructs, ...node.vStructs, ...(mainContract?.vStructs || [])].map((v) =>
      writer.write(v),
    );

    const functions = node.vFunctions.map((v) => writer.write(v));

    const contracts = node.vContracts.map((v) => writer.write(v));

    const generatedUtilFunctions = this.ast.getUtilFuncGen(node).getGeneratedCode();
    const imports = writeImports(this.ast.getImports(node));
    return [
      removeExcessNewlines(
        [
          '%lang starknet',
          [imports],
          ...constants,
          ...structs,
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
      .filter((line) => line.trim().startsWith('func '))
      .flatMap((line) => [line, '}', ''])
      .map((l) => INDENT + l)
      .join('\n'),
  );
  // Handle the workaround of genContractInterface function of externalContractInterfaceInserter.ts
  // Remove `@interface` to get the actual contract interface name
  const baseName = node.name.replace('@interface', '');
  const interfaceName = getInterfaceNameForContract(baseName, node);

  return [
    [
      documentation,
      [`@contract_interface`, `namespace ${interfaceName}{`, ...functions, `}`].join('\n'),
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
        `// This contract may be abstract, it may not implement an abstract parent's methods\n// completely or it may not invoke an inherited contract's constructor correctly.\n`,
      ];

    const dynamicVariables = [...node.dynamicStorageAllocations.entries()].map(
      ([decl, loc]) => `const ${decl.name} = ${loc};`,
    );
    const staticVariables = [...node.staticStorageAllocations.entries()].map(
      ([decl, loc]) => `const ${decl.name} = ${loc};`,
    );
    const variables = [
      `// Dynamic variables - Arrays and Maps`,
      ...dynamicVariables,
      `// Static variables`,
      ...staticVariables,
    ];

    const documentation = getDocumentation(node.documentation, writer);

    // Don't need to write structs, SourceUnitWriter does so already

    const enums = node.vEnums.map((value) => writer.write(value));

    const externalFunctions = node.vFunctions
      .filter((func) => isExternallyVisible(func))
      .map((func) => writer.write(func));

    const otherFunctions = node.vFunctions
      .filter((func) => !isExternallyVisible(func))
      .map((func) => writer.write(func));

    const events = node.vEvents.map((value) => writer.write(value));

    const body = [...variables, ...enums, ...otherFunctions]
      .join('\n\n')
      .split('\n')
      .map((l) => (l.length > 0 ? INDENT + l : l))
      .join('\n');

    const outsideNamespaceBody = [...externalFunctions]
      .join('\n\n')
      .split('\n')
      .map((l) => (l.length > 0 ? INDENT + l : l))
      .join('\n');

    const storageCode = [
      '@storage_var',
      'func WARP_STORAGE(index: felt) -> (val: felt){',
      '}',
      '@storage_var',
      'func WARP_USED_STORAGE() -> (val: felt){',
      '}',
      '@storage_var',
      'func WARP_NAMEGEN() -> (name: felt){',
      '}',
      'func readId{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (val: felt){',
      '    alloc_locals;',
      '    let (id) = WARP_STORAGE.read(loc);',
      '    if (id == 0){',
      '        let (id) = WARP_NAMEGEN.read();',
      '        WARP_NAMEGEN.write(id + 1);',
      '        WARP_STORAGE.write(loc, id + 1);',
      '        return (id + 1,);',
      '    }else{',
      '        return (id,);',
      '    }',
      '}',
      ...(INCLUDE_CAIRO_DUMP_FUNCTIONS
        ? [
            'func DUMP_WARP_STORAGE_ITER{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(length : felt, ptr: felt*){',
            '    alloc_locals;',
            '    if (length == 0){',
            '        return ();',
            '    }',
            '    let index = length - 1;',
            '    let (read) = WARP_STORAGE.read(index);',
            '    assert ptr[index] = read;',
            '    DUMP_WARP_STORAGE_ITER(index, ptr);',
            '    return ();',
            '}',
            '@external',
            'func DUMP_WARP_STORAGE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(length : felt) -> (data_len : felt, data: felt*){',
            '    alloc_locals;',
            '    let (p: felt*) = alloc();',
            '    DUMP_WARP_STORAGE_ITER(length, p);',
            '    return (length, p);',
            '}',
          ]
        : []),
    ].join('\n');

    return [
      [
        documentation,
        ...events,
        storageCode,
        `namespace ${node.name}{\n\n${body}\n\n}`,
        outsideNamespaceBody,
      ].join('\n\n'),
    ];
  }

  writeWhole(node: CairoContract, writer: ASTWriter): SrcDesc {
    return [`// Contract Def ${node.name}\n\n${this.writeInner(node, writer)}`];
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
        safeGetNodeType(value, writer.targetCompilerVersion),
        this.ast,
        varTypeConversionContext,
      );
      if (tp instanceof CairoDynArray && node.parent instanceof FunctionDefinition) {
        return isExternallyVisible(node.parent) ||
          node.getClosestParentByType(ContractDefinition)?.name.includes('@interface')
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
    if (documentation.slice(2).trim().startsWith('warp-cairo')) {
      return [
        documentation
          .split('\n')
          .map((line) => line.slice(2).trim())
          .slice(1)
          .join('\n'),
      ];
    }
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
      [documentation, ...decorator, `func ${name}${implicits}(${args})${returns}{`, body, `}`]
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

    const [keccakPtrInit, [withKeccak, end]] =
      node.implicits.has('keccak_ptr') && isExternallyVisible(node)
        ? [
            [
              'let (local keccak_ptr_start : felt*) = alloc();',
              'let keccak_ptr = keccak_ptr_start;',
            ],
            ['with keccak_ptr{', '}'],
          ]
        : [[], ['', '']];

    if (!isExternallyVisible(node) || !node.implicits.has('warp_memory')) {
      return [
        'alloc_locals;',
        this.getConstructorStorageAllocation(node),
        ...keccakPtrInit,
        withKeccak,
        writer.write(node.vBody),
        end,
      ]
        .filter(notNull)
        .join('\n');
    }

    assert(node.vBody.children.length > 0, error(`${printNode(node)} has an empty body`));
    const keccakPtr = withKeccak !== '' ? ', keccak_ptr' : '';

    return [
      'alloc_locals;',
      this.getConstructorStorageAllocation(node),
      ...keccakPtrInit,
      'let (local warp_memory : DictAccess*) = default_dict_new(0);',
      'local warp_memory_start: DictAccess* = warp_memory;',
      'dict_write{dict_ptr=warp_memory}(0,1);',
      `with warp_memory${keccakPtr}{`,
      writer.write(node.vBody),
      '}',
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
      // External functions should not print the warp_memory or keccak_ptr implicit argument, even
      // if they use them internally. Instead their contents are wrapped
      // in code to initialise them
      (i) => !isExternallyVisible(node) || (i !== 'warp_memory' && i !== 'keccak_ptr'),
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
        contract.usedStorage === 0 ? '' : `WARP_USED_STORAGE.write(${contract.usedStorage});`,
        contract.usedIds === 0 ? '' : `WARP_NAMEGEN.write(${contract.usedIds});`,
      ].join(`\n`);
    }
    return null;
  }
}

class CairoTempVarWriter extends CairoASTNodeWriter {
  writeInner(node: CairoTempVar, _writer: ASTWriter): SrcDesc {
    return [`tempvar ${node.name} = ${node.name};`];
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
          : `(${expWriten},)`;
    }

    const finalizeWarpMemory = this.usesWarpMemory(node)
      ? 'default_dict_finalize(warp_memory_start, warp_memory, 0);\n'
      : '';

    const finalizeKeccakPtr = this.usesKeccak(node)
      ? 'finalize_keccak(keccak_ptr_start, keccak_ptr);\n'
      : '';

    return [
      [documentation, finalizeWarpMemory, finalizeKeccakPtr, `return ${returns};`].join('\n'),
    ];
  }

  private usesWarpMemory(node: Return): boolean {
    const parentFunc = node.getClosestParentByType(CairoFunctionDefinition);
    return (
      parentFunc instanceof CairoFunctionDefinition &&
      parentFunc.implicits.has('warp_memory') &&
      isExternallyVisible(parentFunc)
    );
  }

  private usesKeccak(node: Return): boolean {
    const parentFunc = node.getClosestParentByType(CairoFunctionDefinition);
    return (
      parentFunc instanceof CairoFunctionDefinition &&
      parentFunc.implicits.has('keccak_ptr') &&
      isExternallyVisible(parentFunc)
    );
  }
}

class ExpressionStatementWriter extends CairoASTNodeWriter {
  newVarCounter = 0;
  writeInner(node: ExpressionStatement, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    if (
      node.vExpression instanceof FunctionCall &&
      node.vExpression.kind !== FunctionCallKind.StructConstructorCall
    ) {
      return [[documentation, `${writer.write(node.vExpression)};`].join('\n')];
    } else if (node.vExpression instanceof Assignment || node.vExpression instanceof CairoAssert) {
      return [[documentation, `${writer.write(node.vExpression)}`].join('\n')];
    } else {
      return [
        [
          documentation,
          `let __warp_uv${this.newVarCounter++} = ${writer.write(node.vExpression)};`,
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
        if (
          node.value.length === node.hexValue.length / 2 &&
          node.value.length < 32 &&
          node.value.split('').every((v) => v.charCodeAt(0) < 127)
        ) {
          return [`'${node.value}'`];
        }
        return [`0x${node.hexValue}`];
      }
      case LiteralKind.HexString:
        switch (primitiveTypeToCairo(node.typeString)) {
          case 'Uint256': {
            return [
              `Uint256(low=0x${node.hexValue.slice(32, 64)}, high=0x${node.hexValue.slice(0, 32)})`,
            ];
          }
          case 'felt':
            return [`0x${node.hexValue}`];
          default:
            throw new TranspileFailedError('Attempted to write unexpected cairo type');
        }
    }
  }
}

class IndexAccessWriter extends CairoASTNodeWriter {
  writeInner(node: IndexAccess, writer: ASTWriter): SrcDesc {
    assert(node.vIndexExpression !== undefined);
    const baseWritten = writer.write(node.vBaseExpression);
    const indexWritten = writer.write(node.vIndexExpression);
    if (isDynamicCallDataArray(safeGetNodeType(node.vBaseExpression, this.ast.compilerVersion))) {
      return [`${baseWritten}.ptr[${indexWritten}]`];
    }
    return [`${baseWritten}[${indexWritten}]`];
  }
}
class IdentifierWriter extends CairoASTNodeWriter {
  writeInner(node: Identifier, _: ASTWriter): SrcDesc {
    if (
      node.vIdentifierType === ExternalReferenceType.Builtin &&
      node.name === 'super' &&
      !(node.parent instanceof MemberAccess)
    ) {
      return ['0'];
    }
    if (isCalldataDynArrayStruct(node, this.ast.compilerVersion)) {
      // Calldata dynamic arrays have the element pointer and length variables
      // stored inside a struct. When the dynamic array is accessed, struct's members
      // must be used instead
      return [`${node.name}.len, ${node.name}.ptr`];
    }
    if (isExternalMemoryDynArray(node, this.ast.compilerVersion)) {
      // Memory treated as calldata behaves similarly to calldata but it's
      // element pointer and length variabes are not wrapped inside a struct.
      // When access to the dynamic array is needed, this two variables are used instead
      return [`${node.name}_len, ${node.name}`];
    }

    return [
      `${
        node.vReferencedDeclaration
          ? structRemappings.get(node.vReferencedDeclaration?.id) || node.name
          : node.name
      }`,
    ];
  }
}

class FunctionCallWriter extends CairoASTNodeWriter {
  writeInner(node: FunctionCall, writer: ASTWriter): SrcDesc {
    const args = node.vArguments.map((v) => writer.write(v)).join(', ');
    const func = writer.write(node.vExpression);
    switch (node.kind) {
      case FunctionCallKind.FunctionCall: {
        if (node.vExpression instanceof MemberAccess) {
          // check if we're calling a member of a contract
          const nodeType = safeGetNodeType(
            node.vExpression.vExpression,
            writer.targetCompilerVersion,
          );
          if (
            nodeType instanceof UserDefinedType &&
            nodeType.definition instanceof ContractDefinition
          ) {
            const memberName = node.vExpression.memberName;
            const contract = writer.write(node.vExpression.vExpression);
            return [
              `${getInterfaceNameForContract(
                nodeType.definition.name,
                node,
              )}.${memberName}(${contract}${args ? ', ' : ''}${args})`,
            ];
          }
        } else if (
          node.vReferencedDeclaration instanceof CairoFunctionDefinition &&
          (node.vReferencedDeclaration.acceptsRawDarray ||
            node.vReferencedDeclaration.acceptsUnpackedStructArray)
        ) {
          const [len_suffix, name_suffix] = node.vReferencedDeclaration.acceptsRawDarray
            ? ['_len', '']
            : ['.len', '.ptr'];
          const argTypes = node.vArguments.map((v) => ({
            name: writer.write(v),
            type: safeGetNodeType(v, this.ast.compilerVersion),
          }));
          const args = argTypes
            .map(({ name, type }) =>
              isDynamicArray(type) ? `${name}${len_suffix}, ${name}${name_suffix}` : name,
            )
            .join(',');
          return [`${func}(${args})`];
        }
        return [`${func}(${args})`];
      }
      case FunctionCallKind.StructConstructorCall:
        return [
          `${
            node.vReferencedDeclaration && node.vReferencedDeclaration instanceof StructDefinition
              ? node.vReferencedDeclaration
                ? mangleStructName(node.vReferencedDeclaration)
                : func
              : func
          }(${args})`,
        ];

      case FunctionCallKind.TypeConversion: {
        const arg = node.vArguments[0];
        if (node.vFunctionName === 'address' && arg instanceof Literal) {
          const val = BigInt(arg.value);
          // Make sure literal < 2**251
          assert(val < BigInt('0x800000000000000000000000000000000000000000000000000000000000000'));
          return [`${args[0]}`];
        }
        const nodeType = safeGetNodeType(node.vExpression, writer.targetCompilerVersion);
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
    const [lhs, rhs] = [node.vLeftHandSide, node.vRightHandSide];
    const nodes = [lhs, rhs].map((v) => writer.write(v));
    // This is specifically needed because of the construtions involved with writing
    // conditionals (derived from short circuit expressions). Other tuple assignments
    // and function call assignments will have been split
    if (
      rhs instanceof FunctionCall &&
      !(
        rhs.vReferencedDeclaration instanceof CairoFunctionDefinition &&
        rhs.vReferencedDeclaration.functionStubKind === FunctionStubKind.StructDefStub
      ) &&
      !(lhs instanceof TupleExpression)
    ) {
      return [`let (${nodes[0]}) ${node.operator} ${nodes[1]};`];
    }
    return [`let ${nodes[0]} ${node.operator} ${nodes[1]};`];
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
    return [[documentation, `@event`, `func ${node.name}(${args}){`, `}`].join('\n')];
  }
}

class EmitStatementWriter extends CairoASTNodeWriter {
  writeInner(node: EmitStatement, writer: ASTWriter): SrcDesc {
    const eventDef = node.vEventCall.vReferencedDeclaration;
    assert(eventDef instanceof EventDefinition, `Expected EventDefintion as referenced type`);

    const documentation = getDocumentation(node.documentation, writer);
    const args: string = node.vEventCall.vArguments.map((v) => writer.write(v)).join(', ');
    return [[documentation, `${eventDef.name}.emit(${args});`].join('\n')];
  }
}

class CairoAssertWriter extends CairoASTNodeWriter {
  writeInner(node: CairoAssert, writer: ASTWriter): SrcDesc {
    const assertExpr = `assert ${writer.write(node.vExpression)} = 1;`;

    if (node.assertMessage === null) {
      return [assertExpr];
    } else {
      return [
        [`with_attr error_message("${node.assertMessage}"){`, `${INDENT}${assertExpr}`, `}`].join(
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
    [CairoTempVar, new CairoTempVarWriter(ast, throwOnUnimplemented)],
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
