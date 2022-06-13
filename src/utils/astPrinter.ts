import {
  ArrayType,
  ASTContext,
  ASTNode,
  FunctionCall,
  MappingType,
  PointerType,
  TypeNameType,
  TypeNode,
} from 'solc-typed-ast';
import { PrintOptions } from '..';
import { CairoFunctionDefinition, FunctionStubKind } from '../ast/cairoNodes';
import { cyan, underline } from './formatting';
import { extractProperty } from './utils';

type PropPrinter = {
  prop: string;
  isRelevantNode: (n: ASTNode) => boolean;
  print: (value: unknown) => string | null;
};

type PropSearch = {
  prop: string;
  nodeType?: string;
  print?: (x: unknown) => string | null;
};

export class ASTPrinter {
  propPrinters: PropPrinter[] = [];
  idsToHighlight: number[] = [];
  printStubs = true;

  applyOptions(options: PrintOptions) {
    options.highlight?.forEach((id) => this.highlightId(parseInt(id)));
    this.printStubs = !!options.stubs;
  }

  lookFor(propSearch: string | PropSearch): ASTPrinter {
    if (typeof propSearch === 'string') {
      this.propPrinters.push({
        prop: propSearch,
        isRelevantNode: () => true,
        print: (x: unknown) => `${x}`,
      });
    } else {
      this.propPrinters.push({
        prop: propSearch.prop,
        isRelevantNode: (n: ASTNode) =>
          propSearch.nodeType === undefined || n.type === propSearch.nodeType,
        print: (x: unknown) => (propSearch.print === undefined ? `${x}` : propSearch.print(x)),
      });
    }

    return this;
  }

  highlightId(id: number): ASTPrinter {
    if (!this.idsToHighlight.includes(id)) {
      this.idsToHighlight.push(id);
    }
    return this;
  }

  print(root: ASTNode): string {
    const propString = this.propPrinters
      .filter(({ isRelevantNode }) => isRelevantNode(root))
      .map(({ prop, print }) => {
        const value = extractProperty(prop, root);
        if (value === undefined) return '';
        const formattedValue = print(value);
        if (formattedValue === null) return '';
        return `\n${root.children.length > 0 ? '| ' : '  '}  ${prop}: ${formattedValue}`;
      })
      .join('');

    const subtrees = root.children
      .filter(
        (child) =>
          this.printStubs ||
          !(
            child instanceof CairoFunctionDefinition &&
            child.functionStubKind !== FunctionStubKind.None
          ),
      )
      .map((child, index, children) =>
        this.print(child)
          .split('\n')
          .map((line, lineIndex) => {
            if (lineIndex === 0) return `\n+-${line}`;
            else if (index === children.length - 1) return `\n  ${line}`;
            else return `\n| ${line}`;
          })
          .join(''),
      );

    const printedRoot = this.idsToHighlight.includes(root.id)
      ? cyan(underline(printNode(root)))
      : printNode(root);

    return `${printedRoot}${propString}${subtrees.join('')}`;
  }
}

export const DefaultASTPrinter = new ASTPrinter()
  .lookFor('absolutePath')
  .lookFor('canonicalName')
  .lookFor({
    prop: 'context',
    nodeType: 'SourceUnit',
    print: context,
  })
  .lookFor('fieldNames')
  .lookFor('functionReturnParameters')
  .lookFor('hexValue')
  .lookFor({
    prop: 'implicits',
    nodeType: 'CairoFunctionDefinition',
    print: implicits,
  })
  .lookFor({
    prop: 'linearizedBaseContracts',
    print: linearizedBaseContracts,
  })
  .lookFor('memberName')
  .lookFor('name')
  .lookFor('operator')
  .lookFor('referencedDeclaration')
  .lookFor('returnTypes')
  .lookFor('scope')
  .lookFor('stateMutability')
  .lookFor({
    prop: 'storageAllocations',
    nodeType: 'CairoContract',
    print: storageAllocations,
  })
  .lookFor('storageLocation')
  .lookFor({
    prop: 'symbolAliases',
    print: symbolAliases,
  })
  .lookFor('typeString')
  .lookFor('value')
  .lookFor('visibility');

export function printNode(node: ASTNode): string {
  if (node instanceof FunctionCall) {
    return `${node.type} #${node.id} ${node.vFunctionName}`;
  }
  return `${node.type} #${node.id}`;
}

export function printTypeNode(node: TypeNode, detail?: boolean): string {
  let type = `${node.constructor.name}`;
  if (detail) {
    type = `${printTypeNodeTypes(node)}`;
  }
  return `${node.pp()} (${type})`;
}

function printTypeNodeTypes(node: TypeNode): string {
  let subTypes = '';
  if (node instanceof ArrayType) {
    subTypes = `(${printTypeNodeTypes(node.elementT)}, ${node.size})`;
  } else if (node instanceof MappingType) {
    subTypes = `(${printTypeNodeTypes(node.keyType)}, ${printTypeNodeTypes(node.valueType)})`;
  } else if (node instanceof PointerType) {
    subTypes = `(${printTypeNodeTypes(node.to)}, ${node.location})`;
  } else if (node instanceof TypeNameType) {
    subTypes = `(${printTypeNodeTypes(node.type)})`;
  }
  return `${node.constructor.name} ${subTypes}`;
}

// Property printing functions-------------------------------------------------

function context(x: unknown): string {
  return `${x instanceof ASTContext ? x.id : 'not a context'}`;
}

function implicits(x: unknown): string {
  if (!(x instanceof Set)) throw new Error('Implicits not a set');
  return `${[...x.values()]}`;
}

function linearizedBaseContracts(x: unknown): string {
  if (!Array.isArray(x)) throw new Error('linearizedBaseContracts not an array');
  return x.map((elem) => `${elem}`).join(', ');
}

function storageAllocations(x: unknown): string {
  if (!(x instanceof Map)) throw new Error('storage allocations not a map');
  return [...x.entries()]
    .map(([n, v]) => {
      if (!(n instanceof ASTNode))
        throw new Error(`n should be astnode, found ${n.constructor.name}`);
      return `#${n.id}->${v}`;
    })
    .join();
}

function symbolAliases(x: unknown): string {
  if (!(x instanceof Array)) throw new Error('symbolAliases not a array');
  return `[${x
    .map(
      (alias) =>
        `foreign: ${
          alias.foreign instanceof ASTNode ? printNode(alias.foreign) : `${alias.foreign}`
        } local: ${alias.local}`,
    )
    .join(', ')}]`;
}
