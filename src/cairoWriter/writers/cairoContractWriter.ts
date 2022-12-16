import { ASTWriter, ContractKind, SrcDesc } from 'solc-typed-ast';
import { CairoContract, isExternallyVisible } from '../../export';
import { CairoASTNodeWriter } from '../base';
import {
  getDocumentation,
  getInterfaceNameForContract,
  INCLUDE_CAIRO_DUMP_FUNCTIONS,
  INDENT,
} from '../utils';
import { interfaceNameMappings } from './sourceUnitWriter';

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
    console.log('Writing contract interface', node.name);
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
    const baseName = node.name.replace('@interface', '');
    const interfaceName = getInterfaceNameForContract(baseName, node, interfaceNameMappings);

    return [
      [
        documentation,
        [`@contract_interface`, `namespace ${interfaceName}{`, ...functions, `}`].join('\n'),
      ].join('\n'),
    ];
  }
}
