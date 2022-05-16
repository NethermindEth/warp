import {
  ArrayType,
  ContractDefinition,
  getNodeType,
  MappingType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class OrderNestedStructs extends ASTMapper {
  // Cairo does not permit to use struct definitions which are yet to be defined.
  // For example:
  // contract Warp {
  //    struct Top {
  //        Nested n;
  //    }
  //    struct Nested { ... }
  // }
  // When transpiled to Cairo, struct definitions must be reordered so that
  // nested structs are defined first:
  //   struct Nested { ... }
  //   struct Top {
  //     member n : Nested;
  //   }
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    const structs = node.vStructs;
    const [roots, tree] = this.makeStructTree(structs, ast);

    // there are no nested structs
    if (roots.size === structs.length) return;

    const newStructOrder = this.reorderStructs(roots, tree);

    // remove old struct definiton
    structs.forEach((child) => {
      if (child instanceof StructDefinition) {
        node.removeChild(child);
      }
    });

    // insert back in new order
    newStructOrder.reverse().forEach((struct) => node.insertAtBeginning(struct));
  }

  private makeStructTree(
    structs: readonly StructDefinition[],
    ast: AST,
  ): [Set<StructDefinition>, Map<StructDefinition, [StructDefinition]>] {
    const roots = new Set<StructDefinition>(structs);
    const tree = new Map<StructDefinition, [StructDefinition]>();

    structs.forEach((struct) => {
      struct.vMembers.forEach((varDecl) => {
        const nestedStruct = findStruct(getNodeType(varDecl, ast.compilerVersion));
        if (nestedStruct !== null) {
          roots.delete(nestedStruct);
          tree.has(struct)
            ? tree.get(struct)?.push(nestedStruct)
            : tree.set(struct, [nestedStruct]);
        }
      });
    });

    // roots are struct definition from which none other struct defintion
    // depends on
    return [roots, tree];
  }

  private reorderStructs(
    roots: Set<StructDefinition>,
    tree: Map<StructDefinition, [StructDefinition]>,
  ) {
    const newOrder: StructDefinition[] = [];
    const visited = new Set<StructDefinition>();

    roots.forEach((root) => visitTree(root, tree, visited, newOrder));

    return newOrder;
  }
}

// dfs through the tree
// root is alawys added to orderedStructs after all it's children
function visitTree(
  root: StructDefinition,
  tree: Map<StructDefinition, [StructDefinition]>,
  visited: Set<StructDefinition>,
  orderedStructs: StructDefinition[],
) {
  if (visited.has(root)) {
    return;
  }
  visited.add(root);

  tree.get(root)?.forEach((nested) => visitTree(nested, tree, visited, orderedStructs));

  orderedStructs.push(root);
}

function findStruct(varType: TypeNode): StructDefinition | null {
  if (varType instanceof UserDefinedType && varType.definition instanceof StructDefinition)
    return varType.definition;

  if (varType instanceof ArrayType) return findStruct(varType.elementT);

  if (varType instanceof MappingType) return findStruct(varType.valueType);

  return null;
}
