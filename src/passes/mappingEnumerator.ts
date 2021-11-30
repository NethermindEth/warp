// import {ASTNode, Mapping, ContractDefinition, TypeName} from "solc-typed-ast";
// import {ASTMapper} from "../ast/mapper";
// import {getMappingTypes} from "../utils/mappings";

// type StorageVarName = string;
// type Type = string;
// export default class ReturnInserter extends ASTMapper {
//   visitContractDefinition(node: ContractDefinition): ASTNode {
//     const mappings = node.vStateVariables.filter((v) => v.vType instanceof Mapping)
//     const mappingTypes: [StorageVarName, Type][] = mappings.map((v) => [v.name, getMappingTypes(v.vType as Mapping).map((v) => v.typeString).toString()])
//     mappingTypes.reduce(function(groups, [name,types]) {
//     groups[types] = (groups[types] || []).push(name);
//     return groups
//   }, {});
//     return new ContractDefinition(node.id, node.src, node.type, node.name, node.scope, node.kind, node.abstarct, node.fullyImplemented, node.linearizedBaseContracts, node.usedErrors, node.documentation,
//   }
// }
