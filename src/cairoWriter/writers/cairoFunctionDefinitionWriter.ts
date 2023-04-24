import assert from 'assert';
import {
  ASTWriter,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  SrcDesc,
} from 'solc-typed-ast';
import { CairoContract, CairoFunctionDefinition, FunctionStubKind } from '../../ast/cairoNodes';
import { printNode } from '../../utils/astPrinter';
import { error } from '../../utils/formatting';
import { notNull } from '../../utils/typeConstructs';
import { isExternallyVisible } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';
import endent from 'endent';

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

    return [
      [documentation, ...decorator, `fn ${name}(${args})${returns}{`, body, `}`]
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

    if (node.implicits.has('warp_memory')) {
      decorators.push('#[implicit(warp_memory)]');
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
      return [this.getConstructorStorageAllocation(node), writer.write(node.vBody)]
        .filter(notNull)
        .join('\n');
    }

    assert(node.vBody.children.length > 0, error(`${printNode(node)} has an empty body`));

    return [
      this.getConstructorStorageAllocation(node),
      endent`let mut warp_memory: WarpMemory = MemoryTrait::initialize();
      ${writer.write(node.vBody)}
      `,
    ]
      .flat()
      .filter(notNull)
      .join('\n');
  }

  private getReturns(node: CairoFunctionDefinition, writer: ASTWriter): string {
    if (node.kind === FunctionKind.Constructor) return '';

    const returnStr = writer.write(node.vReturnParameters);
    const paramLen = node.vReturnParameters.vParameters.length;
    // Cairo1 does not need to always return a tuple as former versions
    if (paramLen > 1) return `-> (${returnStr})`;
    else if (paramLen === 1) return `-> ${returnStr}`;
    else return ''; // No return specified so nothing to print
  }

  private getConstructorStorageAllocation(node: CairoFunctionDefinition): string | null {
    if (node.kind === FunctionKind.Constructor) {
      const contract = node.vScope;
      assert(contract instanceof CairoContract);
      if (contract.usedStorage === 0 && contract.usedIds === 0) {
        return null;
      }
      return [
        contract.usedStorage === 0 ? '' : `WARP_USED_STORAGE::write(${contract.usedStorage});`,
        contract.usedIds === 0 ? '' : `WARP_NAMEGEN::write(${contract.usedIds});`,
      ].join(`\n`);
    }
    return null;
  }
}
