import assert from 'assert';
import {
  ArrayType,
  ArrayTypeName,
  generalizeType,
  Literal,
  SourceUnit,
  StateVariableVisibility,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode, printTypeNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { generateLiteralTypeString } from '../utils/getTypeString';
import { createDefaultConstructor, createNumberLiteral } from '../utils/nodeTemplates';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { isExternallyVisible } from '../utils/utils';
import { addSignature, returnSignature } from '../transcode/utils';

export class ABIExtractor extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    this.commonVisit(node, ast);
    node.vFunctions.forEach((fd) =>
      addSignature(node, ast, fd.canonicalSignature(ABIEncoderVersion.V2), returnSignature(fd)),
    );
    node.vContracts
      .flatMap((cd) => cd.vLinearizedBaseContracts)
      .forEach((cd) => {
        if (!cd.abstract) {
          // We do this to trick the canonicalSignature method into giving us a result
          const fakeConstructor =
            cd.vConstructor !== undefined
              ? cloneASTNode(cd.vConstructor, ast)
              : createDefaultConstructor(cd, ast);
          fakeConstructor.isConstructor = false;
          fakeConstructor.name = 'constructor';
          addSignature(
            node,
            ast,
            fakeConstructor.canonicalSignature(ABIEncoderVersion.V2),
            returnSignature(fakeConstructor),
          );
        }
        cd.vFunctions.forEach((fd) => {
          if (isExternallyVisible(fd)) {
            addSignature(
              node,
              ast,
              fd.canonicalSignature(ABIEncoderVersion.V2),
              returnSignature(fd),
            );
          }
        });
        cd.vStateVariables.forEach((vd) => {
          if (vd.visibility === StateVariableVisibility.Public) {
            addSignature(node, ast, vd.getterCanonicalSignature(ABIEncoderVersion.V2));
          }
        });
      });
  }

  // The CanonicalSignature fails for ArrayTypeNames with non-literal, non-undefined length
  // This replaces such cases with literals
  visitArrayTypeName(node: ArrayTypeName, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.vLength !== undefined && !(node.vLength instanceof Literal)) {
      const type = generalizeType(safeGetNodeType(node, ast.compilerVersion))[0];
      assert(
        type instanceof ArrayType,
        `${printNode(node)} ${node.typeString} has non-array type ${printTypeNode(type, true)}`,
      );
      assert(type.size !== undefined, `Static array ${printNode(node)} ${node.typeString}`);
      const literal = createNumberLiteral(
        type.size,
        ast,
        generateLiteralTypeString(type.size.toString()),
      );
      node.vLength = literal;
      ast.registerChild(node.vLength, node);
    }
  }
}

export function dumpABI(node: SourceUnit, ast: AST): string {
  return JSON.stringify([...(ast.abi.get(node.id) || new Set()).keys()]);
}
