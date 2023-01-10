import assert from 'assert';
import { ASTNode, ASTWriter, SourceUnit, StructuredDocumentation } from 'solc-typed-ast';
import { mergeImports } from '../utils/utils';

export const INDENT = ' '.repeat(4);
export const INCLUDE_CAIRO_DUMP_FUNCTIONS = false;

export function getDocumentation(
  documentation: string | StructuredDocumentation | undefined,
  writer: ASTWriter,
): string {
  return documentation !== undefined
    ? typeof documentation === 'string'
      ? `// ${documentation.split('\n').join('\n//')}`
      : writer.write(documentation)
    : '';
}

export function writeImports(imports: Map<string, Set<string>>): string {
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

export function getInterfaceNameForContract(
  contractName: string,
  nodeInSourceUnit: ASTNode,
  interfaceNameMappings: Map<SourceUnit, Map<string, string>>,
): string {
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
