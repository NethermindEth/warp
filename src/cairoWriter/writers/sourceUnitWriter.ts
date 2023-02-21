import assert from 'assert';
import { ASTWriter, ContractKind, FunctionDefinition, SourceUnit, SrcDesc } from 'solc-typed-ast';
import {
  CairoImportFunctionDefinition,
  CairoGeneratedFunctionDefinition,
  FunctionStubKind,
} from '../../ast/cairoNodes';
import { getStructsAndRemappings } from '../../freeStructWritter';
import { removeExcessNewlines } from '../../utils/formatting';
import { TEMP_INTERFACE_SUFFIX } from '../../utils/nameModifiers';
import { CairoASTNodeWriter } from '../base';

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

    assert(mainContract_.length <= 1);
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

    const [importFunctions, generatedFunctions, functions] = node.vFunctions.reduce(
      ([importFunctions, generatedFunctions, functions], funcDef) =>
        funcDef instanceof CairoImportFunctionDefinition
          ? [[funcDef, ...importFunctions], generatedFunctions, functions]
          : funcDef instanceof CairoGeneratedFunctionDefinition
          ? [importFunctions, [funcDef, ...generatedFunctions], functions]
          : [importFunctions, generatedFunctions, [funcDef, ...functions]],
      [
        new Array<CairoImportFunctionDefinition>(),
        new Array<CairoGeneratedFunctionDefinition>(),
        new Array<FunctionDefinition>(),
      ],
    );

    const writtenImportFuncs = getGroupedImports(
      importFunctions
        .sort((funcA, funcB) =>
          `${funcA.path}.${funcA.name}`.localeCompare(`${funcB.path}.${funcB.name}`),
        )
        .filter((func, index, importFuncs) => func.name !== importFuncs[index - 1]?.name),
    ).reduce((writtenImports, importFunc) => `${writtenImports}\n${importFunc}`, '');

    const writtenGeneratedFuncs = generatedFunctions
      .sort((funcA, funcB) => funcA.name.localeCompare(funcB.name))
      .sort((funcA, funcB) => {
        const stubA = funcA.functionStubKind;
        const stubB = funcB.functionStubKind;
        if (stubA === stubB) return 0;
        if (stubA === FunctionStubKind.StructDefStub) return -1;
        if (stubA === FunctionStubKind.StorageDefStub) return -1;
        return 1;
      })
      .filter((func, index, genFuncs) => func.name !== genFuncs[index - 1]?.name)
      .map((func) => writer.write(func));

    const writtenFuncs = functions.map((func) => writer.write(func));

    const contracts = node.vContracts.map((v) => writer.write(v));

    return [
      removeExcessNewlines(
        [
          '%lang starknet',
          writtenImportFuncs,
          ...constants,
          ...structs,
          ...writtenGeneratedFuncs,
          ...writtenFuncs,
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

function getGroupedImports(imports: CairoImportFunctionDefinition[]): string[] {
  const processedImports: string[] = [];
  imports.reduce((functionNames: string[], importNode, index) => {
    functionNames.push(importNode.name);
    if (importNode.path !== imports[index + 1]?.path) {
      processedImports.push(`from ${importNode.path} import ${functionNames.join(', ')}`);
      functionNames = [];
    }
    return functionNames;
  }, []);
  return processedImports;
}
