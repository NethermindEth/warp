import assert from 'assert';
import { ASTWriter, ContractKind, SourceUnit, SrcDesc } from 'solc-typed-ast';
import { getStructsAndRemappings } from '../../freeStructWritter';
import { removeExcessNewlines } from '../../utils/formatting';
import { TEMP_INTERFACE_SUFFIX } from '../../utils/nameModifiers';
import { CairoASTNodeWriter } from '../base';
import { writeImports } from '../utils';

// Used by:
//  -> CairoContractWriter
//  -> FunctionCallWriter
export const interfaceNameMappings: Map<SourceUnit, Map<string, string>> = new Map();
// Used by IdentifierWriter
export let structRemappings: Map<number, string>;

export class SourceUnitWriter extends CairoASTNodeWriter {
  writeInner(node: SourceUnit, writer: ASTWriter): SrcDesc {
    this.generateInterfaceNameMappings(node);

    // Every sourceUnit should only define a single contract
    const mainContract_ =
      node.vContracts.length >= 2
        ? node.vContracts.filter((cd) => !cd.name.endsWith(TEMP_INTERFACE_SUFFIX))
        : node.vContracts;

    assert(mainContract_.length <= 1, 'xx');
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

  private generateInterfaceNameMappings(node: SourceUnit) {
    const map: Map<string, string> = new Map();
    const existingNames = node.vContracts
      .filter((c) => c.kind !== ContractKind.Interface)
      .map((c) => c.name);

    node.vContracts
      .filter((c) => c.kind === ContractKind.Interface && c.name.endsWith(TEMP_INTERFACE_SUFFIX))
      .forEach((c) => {
        const baseName = c.name.replace(TEMP_INTERFACE_SUFFIX, '');
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
}