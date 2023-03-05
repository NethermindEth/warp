import { ASTWriter, ContractKind, SourceUnit, SrcDesc } from 'solc-typed-ast';
import { isExternallyVisible } from '../../utils/utils';
import {
  CairoContract,
  CairoGeneratedFunctionDefinition,
  FunctionStubKind,
} from '../../ast/cairoNodes';
import { TEMP_INTERFACE_SUFFIX } from '../../utils/nameModifiers';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation, getInterfaceNameForContract, INDENT } from '../utils';
import { interfaceNameMappings } from './sourceUnitWriter';
import assert from 'assert';

export class CairoContractWriter extends CairoASTNodeWriter {
  writeInner(node: CairoContract, writer: ASTWriter): SrcDesc {
    if (node.kind === ContractKind.Interface) {
      return this.writeContractInterface(node, writer);
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

    let documentation = getDocumentation(node.documentation, writer);

    if (documentation.slice(2).trim().startsWith('warp-cairo')) {
      documentation = documentation
        .split('\n')
        .map((line) => line.slice(2))
        .slice(1)
        .join('\n');
    }

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

    const parentSourceUnit = node.parent;
    assert(parentSourceUnit instanceof SourceUnit);
    const otherStorageVars = parentSourceUnit.vFunctions.filter(
      (v) =>
        v instanceof CairoGeneratedFunctionDefinition &&
        v.functionStubKind === FunctionStubKind.StorageDefStub,
    );
    const storageCode = [
      'struct Storage {',
      '   WARP_STORAGE: LegacyMap::<felt, felt>,',
      '   WARP_USED_STORAGE: felt,',
      '   WARP_NAMEGEN: felt,',
      ...otherStorageVars.map((v) => '   ' + writer.write(v)),
      '}',

      'fn readId(loc: felt) -> felt {',
      '    let id = WARP_STORAGE::read(loc);',
      '    if id == 0{',
      '        let id = WARP_NAMEGEN::read();',
      '        WARP_NAMEGEN::write(id + 1);',
      '        WARP_STORAGE::write(loc, id + 1);',
      '        return id + 1;',
      '    } else {',
      '        return id;',
      '    }',
      '}',
    ].join('\n');

    return [
      [
        documentation,
        ...events,
        `namespace ${node.name}{\n\n${body}\n\n}`,
        outsideNamespaceBody,
        storageCode,
      ].join('\n\n'),
    ];
  }

  writeWhole(node: CairoContract, writer: ASTWriter): SrcDesc {
    return [`// Contract Def ${node.name}\n\n${this.writeInner(node, writer)}`];
  }

  private writeContractInterface(node: CairoContract, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    const functions = node.vFunctions.map((v) => {
      const resultLines = writer
        .write(v)
        /* TODO: It's a quickfix for now. Implement that as a pass maybe. 
               Remove any StructuredDocumentation from interface's functions? 
               Only those that start with 'warp-cairo'?
               Or create a pass that transforms StructuredDocumentation into AST nodes and removes the function body from interfaces?
      */
        .replace(/\s*\/\/.*/g, '')
        // remove all content between any two pairing curly braces
        .replace(/\{[^]*\}/g, '')
        .split('\n');
      const funcLineIndex = resultLines.findIndex((line) => line.startsWith('func'));
      resultLines.splice(0, funcLineIndex);
      return resultLines.join('\n') + '{\n}';
    });
    // Handle the workaround of genContractInterface function of externalContractInterfaceInserter.ts
    // Remove `@interface` to get the actual contract interface name

    const interfaceName = node.name.endsWith(TEMP_INTERFACE_SUFFIX)
      ? getInterfaceNameForContract(
          node.name.replace(TEMP_INTERFACE_SUFFIX, ''),
          node,
          interfaceNameMappings,
        )
      : node.name;

    return [
      [
        documentation,
        [`@contract_interface`, `namespace ${interfaceName}{`, ...functions, `}`].join('\n'),
      ].join('\n'),
    ];
  }
}
