import assert from 'assert';
import {
  ASTWriter,
  ContractDefinition,
  ContractKind,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  SrcDesc,
} from 'solc-typed-ast';
import { CairoContract, CairoFunctionDefinition, FunctionStubKind } from '../../ast/cairoNodes';
import { printNode } from '../../utils/astPrinter';
import { error } from '../../utils/formatting';
import { implicitOrdering, implicitTypes } from '../../utils/implicits';
import { notNull } from '../../utils/typeConstructs';
import { isExternallyVisible } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

export class CairoFunctionDefinitionWriter extends CairoASTNodeWriter {
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
      [documentation, ...decorator, `fn ${name}${/*implicits*/ ' '}(${args})${returns}{`, body, `}`]
        .filter(notNull)
        .join('\n'),
    ];
  }

  private getDecorator(node: CairoFunctionDefinition): string[] {
    if (node.kind === FunctionKind.Constructor) return ['#[constructor]'];
    const decorators: string[] = [];
    if (node.kind === FunctionKind.Fallback) {
      decorators.push('#[raw_input]');
      if (node.vParameters.vParameters.length > 0) decorators.push('#[raw_output]');
    }

    if (node.visibility === FunctionVisibility.External) {
      if (
        [FunctionStateMutability.Pure, FunctionStateMutability.View].includes(node.stateMutability)
      )
        decorators.push('#[view]');
      else decorators.push('#[external]');
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
        '',
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
      '',
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
