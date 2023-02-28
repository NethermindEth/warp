import assert from 'assert';
import {
  ASTNode,
  EventDefinition,
  FunctionCall,
  FunctionDefinition,
  SourceUnit,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition, FunctionStubKind } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { ASTVisitor } from '../ast/visitor';
import { printNode } from '../utils/astPrinter';
import { Implicits, implicitTypes, registerImportsForImplicit } from '../utils/implicits';
import { isExternallyVisible, union } from '../utils/utils';
import { getDocString, isCairoStub } from './cairoStubProcessor';
import { EMIT_PREFIX } from '../export';
import { parseImplicits } from '../utils/cairoParsing';

export class AnnotateImplicits extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'Tic', // Type builtins are not handled at this stage
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    this.commonVisit(node, ast);
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const implicits = new ImplicitCollector(node).collect(ast);
    const annotatedFunction = new CairoFunctionDefinition(
      node.id,
      node.src,
      node.scope,
      node.kind,
      node.name,
      node.virtual,
      node.visibility,
      node.stateMutability,
      node.isConstructor,
      node.vParameters,
      node.vReturnParameters,
      node.vModifiers,
      implicits,
      FunctionStubKind.None,
      false, // acceptsRawDArray
      false, // acceptsUnpackedStructArray
      node.vOverrideSpecifier,
      node.vBody,
      node.documentation,
      node.nameLocation,
      node.raw,
    );
    ast.replaceNode(node, annotatedFunction);
    implicits.forEach((i) => registerImportsForImplicit(ast, annotatedFunction, i));
    node.children.forEach((child) => this.dispatchVisit(child, ast));
  }
}

class ImplicitCollector extends ASTVisitor<Set<Implicits>> {
  root: FunctionDefinition;
  visited: Set<ASTNode> = new Set();
  constructor(root: FunctionDefinition) {
    super();
    this.root = root;
  }

  commonVisit(node: ASTNode, ast: AST): Set<Implicits> {
    assert(!this.visited.has(node), `Implicit collected visited ${printNode(node)} twice`);
    this.visited.add(node);
    return node.children
      .map((child) => this.dispatchVisit(child, ast))
      .reduce((acc, set) => {
        set.forEach((implicit) => acc.add(implicit));
        return acc;
      }, new Set());
  }

  collect(ast: AST): Set<Implicits> {
    // To avoid cycles, visitFunctionDefinition does not recurse when visiting root,
    // however it is needed for if root is a public function
    return union(this.visitFunctionDefinition(this.root, ast), this.commonVisit(this.root, ast));
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, _ast: AST): Set<Implicits> {
    this.visited.add(node);
    return node.implicits;
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): Set<Implicits> {
    const result: Set<Implicits> = new Set();
    if (isCairoStub(node)) {
      extractImplicitFromStubs(node, result);
      return node === this.root ? result : union(result, this.commonVisit(node, ast));
    }
    if (node.implemented && isExternallyVisible(node)) {
      result.add('range_check_ptr');
      result.add('syscall_ptr');
    }
    if (node.isConstructor) {
      result.add('syscall_ptr');
      result.add('pedersen_ptr');
      result.add('range_check_ptr');
    }

    if (node === this.root) return result;
    return union(result, this.commonVisit(node, ast));
  }

  visitFunctionCall(node: FunctionCall, ast: AST): Set<Implicits> {
    const result = this.commonVisit(node, ast);
    if (
      node.vReferencedDeclaration !== this.root &&
      (node.vReferencedDeclaration instanceof FunctionDefinition ||
        node.vReferencedDeclaration instanceof EventDefinition) &&
      !this.visited.has(node.vReferencedDeclaration)
    ) {
      this.dispatchVisit(node.vReferencedDeclaration, ast).forEach((defn) => result.add(defn));
    }

    const sourceUnit = node.getClosestParentByType(SourceUnit);
    const referencedSourceUnit = node.vReferencedDeclaration?.getClosestParentByType(SourceUnit);
    if (referencedSourceUnit !== sourceUnit || node.vFunctionName.startsWith(EMIT_PREFIX)) {
      result.add('range_check_ptr');
      result.add('syscall_ptr');
    }
    return result;
  }

  visitEventDefinition(node: EventDefinition, ast: AST): Set<Implicits> {
    const result = this.commonVisit(node, ast);
    result.add('syscall_ptr');
    result.add('range_check_ptr');
    return result;
  }
}

function extractImplicitFromStubs(node: FunctionDefinition, result: Set<Implicits>) {
  const cairoCode = getDocString(node.documentation);
  assert(cairoCode !== undefined);
  const funcSignature = cairoCode.match(/func .+\{(.+)\}/);
  if (funcSignature === null) return;

  const implicits = parseImplicits(funcSignature[1]);
  implicits.forEach((impl) => result.add(impl));
}
