// import { ASTWriter, ContractKind, SrcDesc } from 'solc-typed-ast';
// import { isExternallyVisible } from '../../utils/utils';
// import { CairoContract } from '../../ast/cairoNodes';
// import { TEMP_INTERFACE_SUFFIX } from '../../utils/nameModifiers';
// import { CairoASTNodeWriter } from '../base';
// import { getDocumentation, getInterfaceNameForContract, INDENT } from '../utils';
// import { interfaceNameMappings } from './sourceUnitWriter';
// import { TranspileFailedError } from '../../export';
//
// export class CairoContractWriter extends CairoASTNodeWriter {
//   writeInner(node: CairoContract, writer: ASTWriter): SrcDesc {
//     // TODO: Deal with interfaces
//     // TODO: Deal with abstracts (Currently are being dropped)
//     if (node.kind === ContractKind.Interface || node.abstract) {
//       throw new TranspileFailedError('Cannot transpile abstract contracts or interfaces');
//     }
//
//     // TODO: Figure out constants outside function definitions
//     // const staticVariables = [...node.staticStorageAllocations.entries()].map(
//     //   ([decl, loc]) => `const ${decl.name} = ${loc};`,
//     // );
//     // const dynamicVariables = [...node.dynamicStorageAllocations.entries()].map(
//     //   ([decl, loc]) => `const ${decl.name} = ${loc};`,
//     // );
//
//     const storageVars = ['WARP_STORAGE', 'WARP_USED_STORAGE', 'WARP'];
//
//     const externalFunctions = node.vFunctions
//       .filter((func) => isExternallyVisible(func))
//       .map((func) => writer.write(func));
//
//     const otherFunctions = node.vFunctions
//       .filter((func) => !isExternallyVisible(func))
//       .map((func) => writer.write(func));
//   }
//
//   writeWhole(node: CairoContract, writer: ASTWriter): SrcDesc {}
// }
