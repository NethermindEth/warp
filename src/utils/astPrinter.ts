import { ASTContext, ASTNode, TypeNode } from 'solc-typed-ast';
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

    const subtrees = root.children.map((child, index, children) =>
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
  .lookFor('name')
  .lookFor('memberName')
  .lookFor('operator')
  .lookFor('value')
  .lookFor('fieldNames')
  .lookFor('referencedDeclaration')
  .lookFor('returnTypes')
  .lookFor('typeString')
  .lookFor('symbolAliases')
  .lookFor({
    prop: 'context',
    nodeType: 'SourceUnit',
    print: (x: unknown) => `${x instanceof ASTContext ? x.id : 'not a context'}`,
  })
  .lookFor('storageLocation')
  .lookFor({
    prop: 'storageAllocations',
    nodeType: 'CairoContract',
    print: (x: unknown) => {
      if (!(x instanceof Map)) throw new Error('storage allocations not a map');
      return [...x.entries()]
        .map(([n, v]) => {
          if (!(n instanceof ASTNode))
            throw new Error(`n should be astnode, found ${n.constructor.name}`);
          return `#${n.id}->${v}`;
        })
        .join();
    },
  })
  .lookFor({
    prop: 'implicits',
    nodeType: 'CairoFunctionDefinition',
    print: (x: unknown) => {
      if (!(x instanceof Set)) throw new Error('Implicits not a set');
      return `${[...x.entries()]}`;
    },
  })
  .lookFor('visibility')
  .lookFor('stateMutability');

export function printNode(node: ASTNode): string {
  return `${node.type} #${node.id}`;
}

export function printTypeNode(node: TypeNode): string {
  return `${node.pp()} (${node.constructor.name})`;
}

function underline(text: string): string {
  return `${text}\n${'-'.repeat(text.length)}`;
}

function cyan(text: string): string {
  return `\x1b[36m${text}\x1b[0m`;
}
