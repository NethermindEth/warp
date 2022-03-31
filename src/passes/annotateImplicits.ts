import assert = require('assert');
import {
  ASTNode,
  EventDefinition,
  FunctionCall,
  FunctionDefinition,
  FunctionVisibility,
  SourceUnit,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { ASTVisitor } from '../ast/visitor';
import { printNode } from '../utils/astPrinter';
import { Implicits, registerImportsForImplicit } from '../utils/implicits';
import { union } from '../utils/utils';

export class AnnotateImplicits extends ASTMapper {
  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    this.commonVisit(node, ast);
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const implicits = new ImplicitCollector(node).collect(ast);
    const annotatedFunction = new CairoFunctionDefinition(
      node.id,
      node.src,
      'CairoFunctionDefinition',
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
      false,
      node.vOverrideSpecifier,
      node.vBody,
      node.documentation,
      node.nameLocation,
      node.raw,
    );
    ast.replaceNode(node, annotatedFunction);
    ast.copyRegisteredImports(node, annotatedFunction);
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
    if (
      node.implemented &&
      (node.visibility === FunctionVisibility.Public ||
        node.visibility === FunctionVisibility.External)
    ) {
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
    if (referencedSourceUnit !== sourceUnit) {
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
