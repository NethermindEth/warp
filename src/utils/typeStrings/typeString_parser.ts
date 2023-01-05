/* eslint-disable */
// Need the ts-nocheck to suppress the noUnusedLocals errors in the generated parser
// @ts-nocheck
import { lt } from 'semver';
import {
  ASTNode,
  ASTNodeConstructor,
  ContractDefinition,
  DataLocation,
  EnumDefinition,
  Expression,
  FunctionDefinition,
  FunctionStateMutability,
  FunctionVisibility,
  resolveAny,
  StructDefinition,
  UserDefinedValueTypeDefinition,
  VariableDeclaration,
  AddressType,
  ArrayType,
  BoolType,
  BuiltinType,
  BytesType,
  FixedBytesType,
  FunctionType,
  IntLiteralType,
  IntType,
  MappingType,
  PointerType,
  RationalLiteralType,
  StringLiteralType,
  StringType,
  TupleType,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  assert,
  pp,
  InferType,
} from 'solc-typed-ast';
import { InaccessibleDynamicType } from './ast/inaccessible_dynamic_type';
import { ModuleType } from './ast/module_type';

function getFunctionAttributes(
  decorators: string[],
): [FunctionVisibility, FunctionStateMutability] {
  let visiblity: FunctionVisibility | undefined;
  let mutability: FunctionStateMutability | undefined;

  const visiblities = new Set<string>([
    FunctionVisibility.Internal,
    FunctionVisibility.External,
    FunctionVisibility.Public,
    FunctionVisibility.Private,
  ]);

  const mutabilities = new Set<string>([
    FunctionStateMutability.Pure,
    FunctionStateMutability.View,
    FunctionStateMutability.NonPayable,
    FunctionStateMutability.Payable,
  ]);

  for (const decorator of decorators) {
    if (visiblities.has(decorator)) {
      if (visiblity !== undefined) {
        throw new Error(
          `Multiple visiblity decorators specified: ${decorator} conflicts with ${visiblity}`,
        );
      }

      visiblity = decorator as FunctionVisibility;
    } else if (mutabilities.has(decorator)) {
      if (mutability !== undefined) {
        throw new Error(
          `Multiple mutability decorators specified: ${decorator} conflicts with ${mutability}`,
        );
      }

      mutability = decorator as FunctionStateMutability;
    }
  }

  // Assume default visiblity is internal
  if (visiblity === undefined) {
    visiblity = FunctionVisibility.Internal;
  }

  // Assume default mutability is non-payable
  if (mutability === undefined) {
    mutability = FunctionStateMutability.NonPayable;
  }

  return [visiblity, mutability];
}

/**
 * Return the `TypeNode` corresponding to `node`, where `node` is an AST node
 * with a type string (`Expression` or `VariableDeclaration`).
 *
 * The function uses a parser to process the type string,
 * while resolving and user-defined type references in the context of `node`.
 *
 * @param arg - an AST node with a type string (`Expression` or `VariableDeclaration`)
 * @param version - compiler version to be used. Useful as resolution rules changed between 0.4.x and 0.5.x.
 */
export function getNodeType(
  node: Expression | VariableDeclaration,
  inference: InferType,
): TypeNode {
  return parse(node.typeString, { ctx: node, inference }) as TypeNode;
}

/**
 * Return the `TypeNode` corresponding to `arg`, where `arg` is either a raw type string,
 * or an AST node with a type string (`Expression` or `VariableDeclaration`).
 *
 * The function uses a parser to process the type string,
 * while resolving and user-defined type references in the context of `ctx`.
 *
 * @param arg - either a type string, or a node with a type string (`Expression` or `VariableDeclaration`)
 * @param version - compiler version to be used. Useful as resolution rules changed between 0.4.x and 0.5.x.
 * @param ctx - `ASTNode` representing the context in which a type string is to be parsed
 */
export function getNodeTypeInCtx(
  arg: Expression | VariableDeclaration | string,
  inference: InferType,
  ctx: ASTNode,
): TypeNode {
  const typeString = typeof arg === 'string' ? arg : arg.typeString;

  return parse(typeString, { ctx, inference }) as TypeNode;
}

function makeUserDefinedType<T extends ASTNode>(
  name: string,
  constructor: ASTNodeConstructor<T>,
  inference: InferType,
  ctx: ASTNode,
): UserDefinedType {
  let defs = [...resolveAny(name, ctx, inference)];

  /**
   * Note that constructors below 0.5.0 may have same name as contract definition.
   */
  if (constructor === ContractDefinition) {
    defs = defs
      .filter(
        (def) =>
          def instanceof ContractDefinition ||
          (def instanceof FunctionDefinition && def.isConstructor && def.name === def.vScope.name),
      )
      .map((def) => (def instanceof FunctionDefinition ? def.vScope : def));
  } else {
    defs = defs.filter((def) => def instanceof constructor);
  }

  if (defs.length === 0) {
    throw new Error(`Couldn't find ${constructor.name} ${name}`);
  }

  if (defs.length > 1) {
    throw new Error(`Multiple matches for ${constructor.name} ${name}`);
  }

  const def = defs[0];

  assert(
    def instanceof constructor,
    'Expected {0} to resolve to {1} got {2} instead',
    name,
    constructor.name,
    def,
  );

  return new UserDefinedType(name, def);
}

// Generated by peggy v. 1.2.0 (ts-pegjs plugin v. 1.2.2 )
//
// https://peggyjs.org/   https://github.com/metadevpro/ts-pegjs

export interface IFilePosition {
  offset: number;
  line: number;
  column: number;
}

export interface IFileRange {
  start: IFilePosition;
  end: IFilePosition;
  source: string;
}

export interface ILiteralExpectation {
  type: 'literal';
  text: string;
  ignoreCase: boolean;
}

export interface IClassParts extends Array<string | IClassParts> {}

export interface IClassExpectation {
  type: 'class';
  parts: IClassParts;
  inverted: boolean;
  ignoreCase: boolean;
}

export interface IAnyExpectation {
  type: 'any';
}

export interface IEndExpectation {
  type: 'end';
}

export interface IOtherExpectation {
  type: 'other';
  description: string;
}

export type Expectation =
  | ILiteralExpectation
  | IClassExpectation
  | IAnyExpectation
  | IEndExpectation
  | IOtherExpectation;

function peg$padEnd(str: string, targetLength: number, padString: string) {
  padString = padString || ' ';
  if (str.length > targetLength) {
    return str;
  }
  targetLength -= str.length;
  padString += padString.repeat(targetLength);
  return str + padString.slice(0, targetLength);
}

export class SyntaxError extends Error {
  public static buildMessage(expected: Expectation[], found: string | null) {
    function hex(ch: string): string {
      return ch.charCodeAt(0).toString(16).toUpperCase();
    }

    function literalEscape(s: string): string {
      return s
        .replace(/\\/g, '\\\\')
        .replace(/"/g, '\\"')
        .replace(/\0/g, '\\0')
        .replace(/\t/g, '\\t')
        .replace(/\n/g, '\\n')
        .replace(/\r/g, '\\r')
        .replace(/[\x00-\x0F]/g, (ch) => '\\x0' + hex(ch))
        .replace(/[\x10-\x1F\x7F-\x9F]/g, (ch) => '\\x' + hex(ch));
    }

    function classEscape(s: string): string {
      return s
        .replace(/\\/g, '\\\\')
        .replace(/\]/g, '\\]')
        .replace(/\^/g, '\\^')
        .replace(/-/g, '\\-')
        .replace(/\0/g, '\\0')
        .replace(/\t/g, '\\t')
        .replace(/\n/g, '\\n')
        .replace(/\r/g, '\\r')
        .replace(/[\x00-\x0F]/g, (ch) => '\\x0' + hex(ch))
        .replace(/[\x10-\x1F\x7F-\x9F]/g, (ch) => '\\x' + hex(ch));
    }

    function describeExpectation(expectation: Expectation) {
      switch (expectation.type) {
        case 'literal':
          return '"' + literalEscape(expectation.text) + '"';
        case 'class':
          const escapedParts = expectation.parts.map((part) => {
            return Array.isArray(part)
              ? classEscape(part[0] as string) + '-' + classEscape(part[1] as string)
              : classEscape(part);
          });

          return '[' + (expectation.inverted ? '^' : '') + escapedParts + ']';
        case 'any':
          return 'any character';
        case 'end':
          return 'end of input';
        case 'other':
          return expectation.description;
      }
    }

    function describeExpected(expected1: Expectation[]) {
      const descriptions = expected1.map(describeExpectation);
      let i: number;
      let j: number;

      descriptions.sort();

      if (descriptions.length > 0) {
        for (i = 1, j = 1; i < descriptions.length; i++) {
          if (descriptions[i - 1] !== descriptions[i]) {
            descriptions[j] = descriptions[i];
            j++;
          }
        }
        descriptions.length = j;
      }

      switch (descriptions.length) {
        case 1:
          return descriptions[0];

        case 2:
          return descriptions[0] + ' or ' + descriptions[1];

        default:
          return (
            descriptions.slice(0, -1).join(', ') + ', or ' + descriptions[descriptions.length - 1]
          );
      }
    }

    function describeFound(found1: string | null) {
      return found1 ? '"' + literalEscape(found1) + '"' : 'end of input';
    }

    return 'Expected ' + describeExpected(expected) + ' but ' + describeFound(found) + ' found.';
  }

  public message: string;
  public expected: Expectation[];
  public found: string | null;
  public location: IFileRange;
  public name: string;

  constructor(
    message: string,
    expected: Expectation[],
    found: string | null,
    location: IFileRange,
  ) {
    super();
    this.message = message;
    this.expected = expected;
    this.found = found;
    this.location = location;
    this.name = 'SyntaxError';

    if (typeof (Object as any).setPrototypeOf === 'function') {
      (Object as any).setPrototypeOf(this, SyntaxError.prototype);
    } else {
      (this as any).__proto__ = SyntaxError.prototype;
    }
    if (typeof (Error as any).captureStackTrace === 'function') {
      (Error as any).captureStackTrace(this, SyntaxError);
    }
  }

  format(sources: { source: string; text: string }[]): string {
    let str = 'Error: ' + this.message;
    if (this.location) {
      let src: string[] | null = null;
      let k;
      for (k = 0; k < sources.length; k++) {
        if (sources[k].source === this.location.source) {
          src = sources[k].text.split(/\r\n|\n|\r/g);
          break;
        }
      }
      let s = this.location.start;
      let loc = this.location.source + ':' + s.line + ':' + s.column;
      if (src) {
        let e = this.location.end;
        let filler = peg$padEnd('', s.line.toString().length, ' ');
        let line = src[s.line - 1];
        let last = s.line === e.line ? e.column : line.length + 1;
        str +=
          '\n --> ' +
          loc +
          '\n' +
          filler +
          ' |\n' +
          s.line +
          ' | ' +
          line +
          '\n' +
          filler +
          ' | ' +
          peg$padEnd('', s.column - 1, ' ') +
          peg$padEnd('', last - s.column, '^');
      } else {
        str += '\n at ' + loc;
      }
    }
    return str;
  }
}

export interface ICached {
  nextPos: number;
  result: any;
}

function peg$parse(input: string, options?: IParseOptions) {
  options = options !== undefined ? options : {};

  const peg$FAILED: Readonly<any> = {};
  const peg$source = options.grammarSource;

  const peg$startRuleFunctions: { [id: string]: any } = { Start: peg$parseStart };
  let peg$startRuleFunction: () => any = peg$parseStart;

  const peg$c0 = function (type: any): any {
    return type;
  };
  const peg$c1 = peg$otherExpectation('whitespace');
  const peg$c2 = '\t';
  const peg$c3 = peg$literalExpectation('\t', false);
  const peg$c4 = '\v';
  const peg$c5 = peg$literalExpectation('\v', false);
  const peg$c6 = '\f';
  const peg$c7 = peg$literalExpectation('\f', false);
  const peg$c8 = ' ';
  const peg$c9 = peg$literalExpectation(' ', false);
  const peg$c10 = '\xA0';
  const peg$c11 = peg$literalExpectation('\xA0', false);
  const peg$c12 = '\uFEFF';
  const peg$c13 = peg$literalExpectation('\uFEFF', false);
  const peg$c14 = /^[ \xA0\u1680\u2000-\u200A\u202F\u205F\u3000]/;
  const peg$c15 = peg$classExpectation(
    [' ', '\xA0', '\u1680', ['\u2000', '\u200A'], '\u202F', '\u205F', '\u3000'],
    false,
    false,
  );
  const peg$c16 = /^[\n\r\u2028\u2029]/;
  const peg$c17 = peg$classExpectation(['\n', '\r', '\u2028', '\u2029'], false, false);
  const peg$c18 = peg$otherExpectation('end of line');
  const peg$c19 = '\n';
  const peg$c20 = peg$literalExpectation('\n', false);
  const peg$c21 = '\r\n';
  const peg$c22 = peg$literalExpectation('\r\n', false);
  const peg$c23 = '\r';
  const peg$c24 = peg$literalExpectation('\r', false);
  const peg$c25 = '\u2028';
  const peg$c26 = peg$literalExpectation('\u2028', false);
  const peg$c27 = '\u2029';
  const peg$c28 = peg$literalExpectation('\u2029', false);
  const peg$c29 = 'true';
  const peg$c30 = peg$literalExpectation('true', false);
  const peg$c31 = 'false';
  const peg$c32 = peg$literalExpectation('false', false);
  const peg$c33 = 'old';
  const peg$c34 = peg$literalExpectation('old', false);
  const peg$c35 = 'let';
  const peg$c36 = peg$literalExpectation('let', false);
  const peg$c37 = 'in';
  const peg$c38 = peg$literalExpectation('in', false);
  const peg$c39 = 'bool';
  const peg$c40 = peg$literalExpectation('bool', false);
  const peg$c41 = 'address';
  const peg$c42 = peg$literalExpectation('address', false);
  const peg$c43 = 'payable';
  const peg$c44 = peg$literalExpectation('payable', false);
  const peg$c45 = 'bytes';
  const peg$c46 = peg$literalExpectation('bytes', false);
  const peg$c47 = 'string';
  const peg$c48 = peg$literalExpectation('string', false);
  const peg$c49 = 'byte';
  const peg$c50 = peg$literalExpectation('byte', false);
  const peg$c51 = 'memory';
  const peg$c52 = peg$literalExpectation('memory', false);
  const peg$c53 = 'storage';
  const peg$c54 = peg$literalExpectation('storage', false);
  const peg$c55 = 'calldata';
  const peg$c56 = peg$literalExpectation('calldata', false);
  const peg$c57 = 'mapping';
  const peg$c58 = peg$literalExpectation('mapping', false);
  const peg$c59 = 'function';
  const peg$c60 = peg$literalExpectation('function', false);
  const peg$c61 = 'returns';
  const peg$c62 = peg$literalExpectation('returns', false);
  const peg$c63 = 'public';
  const peg$c64 = peg$literalExpectation('public', false);
  const peg$c65 = 'external';
  const peg$c66 = peg$literalExpectation('external', false);
  const peg$c67 = 'internal';
  const peg$c68 = peg$literalExpectation('internal', false);
  const peg$c69 = 'private';
  const peg$c70 = peg$literalExpectation('private', false);
  const peg$c71 = 'pure';
  const peg$c72 = peg$literalExpectation('pure', false);
  const peg$c73 = 'view';
  const peg$c74 = peg$literalExpectation('view', false);
  const peg$c75 = 'nonpayable';
  const peg$c76 = peg$literalExpectation('nonpayable', false);
  const peg$c77 = 'int_const';
  const peg$c78 = peg$literalExpectation('int_const', false);
  const peg$c79 = 'rational_const';
  const peg$c80 = peg$literalExpectation('rational_const', false);
  const peg$c81 = 'pointer';
  const peg$c82 = peg$literalExpectation('pointer', false);
  const peg$c83 = 'ref';
  const peg$c84 = peg$literalExpectation('ref', false);
  const peg$c85 = 'tuple';
  const peg$c86 = peg$literalExpectation('tuple', false);
  const peg$c87 = 'type';
  const peg$c88 = peg$literalExpectation('type', false);
  const peg$c89 = 'literal_string';
  const peg$c90 = peg$literalExpectation('literal_string', false);
  const peg$c91 = 'modifier';
  const peg$c92 = peg$literalExpectation('modifier', false);
  const peg$c93 = 'contract';
  const peg$c94 = peg$literalExpectation('contract', false);
  const peg$c95 = 'super';
  const peg$c96 = peg$literalExpectation('super', false);
  const peg$c97 = 'library';
  const peg$c98 = peg$literalExpectation('library', false);
  const peg$c99 = 'struct';
  const peg$c100 = peg$literalExpectation('struct', false);
  const peg$c101 = 'enum';
  const peg$c102 = peg$literalExpectation('enum', false);
  const peg$c103 = 'msg';
  const peg$c104 = peg$literalExpectation('msg', false);
  const peg$c105 = 'abi';
  const peg$c106 = peg$literalExpectation('abi', false);
  const peg$c107 = 'block';
  const peg$c108 = peg$literalExpectation('block', false);
  const peg$c109 = 'tx';
  const peg$c110 = peg$literalExpectation('tx', false);
  const peg$c111 = 'slice';
  const peg$c112 = peg$literalExpectation('slice', false);
  const peg$c113 = 'constant';
  const peg$c114 = peg$literalExpectation('constant', false);
  const peg$c115 = 'hex';
  const peg$c116 = peg$literalExpectation('hex', false);
  const peg$c117 = 'module';
  const peg$c118 = peg$literalExpectation('module', false);
  const peg$c119 = "'";
  const peg$c120 = peg$literalExpectation("'", false);
  const peg$c121 = function (chars: any): any {
    return [chars.join(''), 'string'];
  };
  const peg$c122 = '"';
  const peg$c123 = peg$literalExpectation('"', false);
  const peg$c124 = function (val: any): any {
    return [val.join(''), 'hexString'];
  };
  const peg$c125 = peg$anyExpectation();
  const peg$c126 = '\\';
  const peg$c127 = peg$literalExpectation('\\', false);
  const peg$c128 = function (): any {
    return text();
  };
  const peg$c129 = function (sequence: any): any {
    return sequence;
  };
  const peg$c130 = function (): any {
    return '';
  };
  const peg$c131 = '0';
  const peg$c132 = peg$literalExpectation('0', false);
  const peg$c133 = function (): any {
    return '\0';
  };
  const peg$c134 = 'b';
  const peg$c135 = peg$literalExpectation('b', false);
  const peg$c136 = function (): any {
    return '\b';
  };
  const peg$c137 = 'f';
  const peg$c138 = peg$literalExpectation('f', false);
  const peg$c139 = function (): any {
    return '\f';
  };
  const peg$c140 = 'n';
  const peg$c141 = peg$literalExpectation('n', false);
  const peg$c142 = function (): any {
    return '\n';
  };
  const peg$c143 = 'r';
  const peg$c144 = peg$literalExpectation('r', false);
  const peg$c145 = function (): any {
    return '\r';
  };
  const peg$c146 = 't';
  const peg$c147 = peg$literalExpectation('t', false);
  const peg$c148 = function (): any {
    return '\t';
  };
  const peg$c149 = 'v';
  const peg$c150 = peg$literalExpectation('v', false);
  const peg$c151 = function (): any {
    return '\v';
  };
  const peg$c152 = /^[0-9a-f]/i;
  const peg$c153 = peg$classExpectation(
    [
      ['0', '9'],
      ['a', 'f'],
    ],
    false,
    true,
  );
  const peg$c154 = /^[0-9]/;
  const peg$c155 = peg$classExpectation([['0', '9']], false, false);
  const peg$c156 = 'x';
  const peg$c157 = peg$literalExpectation('x', false);
  const peg$c158 = 'u';
  const peg$c159 = peg$literalExpectation('u', false);
  const peg$c160 = function (digits: any): any {
    return String.fromCharCode(parseInt(digits, 16));
  };
  const peg$c161 = /^[^a-zA-Z0-9_]/;
  const peg$c162 = peg$classExpectation([['a', 'z'], ['A', 'Z'], ['0', '9'], '_'], true, false);
  const peg$c163 = /^[a-zA-Z_$]/;
  const peg$c164 = peg$classExpectation([['a', 'z'], ['A', 'Z'], '_', '$'], false, false);
  const peg$c165 = /^[a-zA-Z$0-9_]/;
  const peg$c166 = peg$classExpectation(
    [['a', 'z'], ['A', 'Z'], '$', ['0', '9'], '_'],
    false,
    false,
  );
  const peg$c167 = function (id: any): any {
    return text();
  };
  const peg$c168 = function (): any {
    return BigInt(text());
  };
  const peg$c169 = '-';
  const peg$c170 = peg$literalExpectation('-', false);
  const peg$c171 = function (sign: any, num: any): any {
    return sign === null ? num : -num;
  };
  const peg$c172 = 'inaccessible dynamic type';
  const peg$c173 = peg$literalExpectation('inaccessible dynamic type', false);
  const peg$c174 = function (): any {
    return new InaccessibleDynamicType();
  };
  const peg$c175 = '(';
  const peg$c176 = peg$literalExpectation('(', false);
  const peg$c177 = /^[^)]/;
  const peg$c178 = peg$classExpectation([')'], true, false);
  const peg$c179 = ')';
  const peg$c180 = peg$literalExpectation(')', false);
  const peg$c181 = function (): any {
    return [text(), false];
  };
  const peg$c182 = function (literal: any): any {
    return new StringLiteralType(literal[1]);
  };
  const peg$c183 = '...(';
  const peg$c184 = peg$literalExpectation('...(', false);
  const peg$c185 = ')...';
  const peg$c186 = peg$literalExpectation(')...', false);
  const peg$c187 = function (prefix: any, rest: any): any {
    return new IntLiteralType(prefix);
  };
  const peg$c188 = '/';
  const peg$c189 = peg$literalExpectation('/', false);
  const peg$c190 = function (numerator: any, denominator: any): any {
    return new RationalLiteralType({ numerator: numerator, denominator: denominator });
  };
  const peg$c191 = function (): any {
    return new BoolType();
  };
  const peg$c192 = function (payable: any): any {
    return new AddressType(payable !== null);
  };
  const peg$c193 = 'int';
  const peg$c194 = peg$literalExpectation('int', false);
  const peg$c195 = function (unsigned: any, width: any): any {
    const signed = unsigned === null;
    const bitWidth = width === null ? 256 : Number(width);

    return new IntType(bitWidth, signed);
  };
  const peg$c196 = function (width: any): any {
    return new FixedBytesType(Number(width));
  };
  const peg$c197 = function (): any {
    return new FixedBytesType(1);
  };
  const peg$c198 = function (): any {
    return new BytesType();
  };
  const peg$c199 = function (): any {
    return new StringType();
  };
  const peg$c200 = '.';
  const peg$c201 = peg$literalExpectation('.', false);
  const peg$c202 = function (name: any): any {
    return makeUserDefinedType(name, StructDefinition, options.inference, options.ctx);
  };
  const peg$c203 = function (name: any): any {
    return makeUserDefinedType(name, EnumDefinition, options.inference, options.ctx);
  };
  const peg$c204 = function (name: any): any {
    return makeUserDefinedType(name, ContractDefinition, options.inference, options.ctx);
  };
  const peg$c205 = function (name: any): any {
    return makeUserDefinedType(
      name,
      UserDefinedValueTypeDefinition,
      options.inference,
      options.ctx,
    );
  };
  const peg$c206 = '=>';
  const peg$c207 = peg$literalExpectation('=>', false);
  const peg$c208 = function (keyType: any, valueType: any): any {
    // Identifiers refering directly to state variable maps
    // don't have a pointer suffix.
    // So we wrap them in a PointerType here.
    // This means we explicitly disagree with the exact typeString.
    return new PointerType(new MappingType(keyType, valueType), DataLocation.Storage);
  };
  const peg$c209 = ',';
  const peg$c210 = peg$literalExpectation(',', false);
  const peg$c211 = function (head: any, tail: any): any {
    return tail.reduce(
      (lst, cur) => {
        lst.push(cur[3]);

        return lst;
      },
      [head],
    );
  };
  const peg$c212 = function (): any {
    return [];
  };
  const peg$c213 = function (head: any, tail: any): any {
    return tail.reduce(
      (acc, cur) => {
        acc.push(cur[1]);

        return acc;
      },
      [head],
    );
  };
  const peg$c214 = function (name: any, args: any, decorators: any, returns: any): any {
    const retTypes = returns === null ? [] : returns[4];
    const [visibility, mutability] = getFunctionAttributes(decorators === null ? [] : decorators);

    return new FunctionType(
      name === null ? undefined : name,
      args,
      retTypes,
      visibility,
      mutability,
    );
  };
  const peg$c215 = function (args: any): any {
    throw new Error("Shouldn't try to type modifiers!");
  };
  const peg$c216 = function (elements: any): any {
    return new TupleType(elements === null ? [] : elements);
  };
  const peg$c217 = function (innerT: any): any {
    return new TypeNameType(innerT);
  };
  const peg$c218 = function (name: any): any {
    return new BuiltinType(name);
  };
  const peg$c219 = function (path: any): any {
    return new ModuleType(path[0]);
  };
  const peg$c220 = '[';
  const peg$c221 = peg$literalExpectation('[', false);
  const peg$c222 = ']';
  const peg$c223 = peg$literalExpectation(']', false);
  const peg$c224 = function (head: any, tail: any): any {
    return tail.reduce((acc, cur) => {
      acc = acc;

      if (cur.length > 3) {
        const size = cur[4];

        return new ArrayType(acc, size === null ? undefined : size);
      }

      const location = cur[1] as DataLocation;
      const kind = cur[2] === null ? undefined : cur[2][1];

      return new PointerType(acc, location, kind);
    }, head);
  };

  let peg$currPos = 0;
  let peg$savedPos = 0;
  const peg$posDetailsCache = [{ line: 1, column: 1 }];
  let peg$maxFailPos = 0;
  let peg$maxFailExpected: Expectation[] = [];
  let peg$silentFails = 0;

  const peg$resultsCache: { [id: number]: ICached } = {};

  let peg$result;

  if (options.startRule !== undefined) {
    if (!(options.startRule in peg$startRuleFunctions)) {
      throw new Error('Can\'t start parsing from rule "' + options.startRule + '".');
    }

    peg$startRuleFunction = peg$startRuleFunctions[options.startRule];
  }

  function text(): string {
    return input.substring(peg$savedPos, peg$currPos);
  }

  function location(): IFileRange {
    return peg$computeLocation(peg$savedPos, peg$currPos);
  }

  function expected(description: string, location1?: IFileRange) {
    location1 =
      location1 !== undefined ? location1 : peg$computeLocation(peg$savedPos, peg$currPos);

    throw peg$buildStructuredError(
      [peg$otherExpectation(description)],
      input.substring(peg$savedPos, peg$currPos),
      location1,
    );
  }

  function error(message: string, location1?: IFileRange) {
    location1 =
      location1 !== undefined ? location1 : peg$computeLocation(peg$savedPos, peg$currPos);

    throw peg$buildSimpleError(message, location1);
  }

  function peg$literalExpectation(text1: string, ignoreCase: boolean): ILiteralExpectation {
    return { type: 'literal', text: text1, ignoreCase: ignoreCase };
  }

  function peg$classExpectation(
    parts: IClassParts,
    inverted: boolean,
    ignoreCase: boolean,
  ): IClassExpectation {
    return { type: 'class', parts: parts, inverted: inverted, ignoreCase: ignoreCase };
  }

  function peg$anyExpectation(): IAnyExpectation {
    return { type: 'any' };
  }

  function peg$endExpectation(): IEndExpectation {
    return { type: 'end' };
  }

  function peg$otherExpectation(description: string): IOtherExpectation {
    return { type: 'other', description: description };
  }

  function peg$computePosDetails(pos: number) {
    let details = peg$posDetailsCache[pos];
    let p;

    if (details) {
      return details;
    } else {
      p = pos - 1;
      while (!peg$posDetailsCache[p]) {
        p--;
      }

      details = peg$posDetailsCache[p];
      details = {
        line: details.line,
        column: details.column,
      };

      while (p < pos) {
        if (input.charCodeAt(p) === 10) {
          details.line++;
          details.column = 1;
        } else {
          details.column++;
        }

        p++;
      }

      peg$posDetailsCache[pos] = details;

      return details;
    }
  }

  function peg$computeLocation(startPos: number, endPos: number): IFileRange {
    const startPosDetails = peg$computePosDetails(startPos);
    const endPosDetails = peg$computePosDetails(endPos);

    return {
      source: peg$source,
      start: {
        offset: startPos,
        line: startPosDetails.line,
        column: startPosDetails.column,
      },
      end: {
        offset: endPos,
        line: endPosDetails.line,
        column: endPosDetails.column,
      },
    };
  }

  function peg$fail(expected1: Expectation) {
    if (peg$currPos < peg$maxFailPos) {
      return;
    }

    if (peg$currPos > peg$maxFailPos) {
      peg$maxFailPos = peg$currPos;
      peg$maxFailExpected = [];
    }

    peg$maxFailExpected.push(expected1);
  }

  function peg$buildSimpleError(message: string, location1: IFileRange) {
    return new SyntaxError(message, [], '', location1);
  }

  function peg$buildStructuredError(
    expected1: Expectation[],
    found: string | null,
    location1: IFileRange,
  ) {
    return new SyntaxError(SyntaxError.buildMessage(expected1, found), expected1, found, location1);
  }

  function peg$parseStart(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 0;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parse__();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parseType();
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parse__();
        if ((s3 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c0(s2);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parsePrimitiveWhiteSpace(): any {
    let s0, s1;

    const key = peg$currPos * 103 + 1;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    peg$silentFails++;
    if (input.charCodeAt(peg$currPos) === 9) {
      s0 = peg$c2;
      peg$currPos++;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c3);
      }
    }
    if ((s0 as any) === peg$FAILED) {
      if (input.charCodeAt(peg$currPos) === 11) {
        s0 = peg$c4;
        peg$currPos++;
      } else {
        s0 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c5);
        }
      }
      if ((s0 as any) === peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 12) {
          s0 = peg$c6;
          peg$currPos++;
        } else {
          s0 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c7);
          }
        }
        if ((s0 as any) === peg$FAILED) {
          if (input.charCodeAt(peg$currPos) === 32) {
            s0 = peg$c8;
            peg$currPos++;
          } else {
            s0 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c9);
            }
          }
          if ((s0 as any) === peg$FAILED) {
            if (input.charCodeAt(peg$currPos) === 160) {
              s0 = peg$c10;
              peg$currPos++;
            } else {
              s0 = peg$FAILED;
              if (peg$silentFails === 0) {
                peg$fail(peg$c11);
              }
            }
            if ((s0 as any) === peg$FAILED) {
              if (input.charCodeAt(peg$currPos) === 65279) {
                s0 = peg$c12;
                peg$currPos++;
              } else {
                s0 = peg$FAILED;
                if (peg$silentFails === 0) {
                  peg$fail(peg$c13);
                }
              }
              if ((s0 as any) === peg$FAILED) {
                s0 = peg$parseZs();
              }
            }
          }
        }
      }
    }
    peg$silentFails--;
    if ((s0 as any) === peg$FAILED) {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c1);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseWhiteSpace(): any {
    let s0, s1;

    const key = peg$currPos * 103 + 2;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    peg$silentFails++;
    s0 = peg$parsePrimitiveWhiteSpace();
    peg$silentFails--;
    if ((s0 as any) === peg$FAILED) {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c1);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseZs(): any {
    let s0;

    const key = peg$currPos * 103 + 3;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (peg$c14.test(input.charAt(peg$currPos))) {
      s0 = input.charAt(peg$currPos);
      peg$currPos++;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c15);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseLineTerminator(): any {
    let s0;

    const key = peg$currPos * 103 + 4;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (peg$c16.test(input.charAt(peg$currPos))) {
      s0 = input.charAt(peg$currPos);
      peg$currPos++;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c17);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseLineTerminatorSequence(): any {
    let s0, s1;

    const key = peg$currPos * 103 + 5;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    peg$silentFails++;
    if (input.charCodeAt(peg$currPos) === 10) {
      s0 = peg$c19;
      peg$currPos++;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c20);
      }
    }
    if ((s0 as any) === peg$FAILED) {
      if (input.substr(peg$currPos, 2) === peg$c21) {
        s0 = peg$c21;
        peg$currPos += 2;
      } else {
        s0 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c22);
        }
      }
      if ((s0 as any) === peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 13) {
          s0 = peg$c23;
          peg$currPos++;
        } else {
          s0 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c24);
          }
        }
        if ((s0 as any) === peg$FAILED) {
          if (input.charCodeAt(peg$currPos) === 8232) {
            s0 = peg$c25;
            peg$currPos++;
          } else {
            s0 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c26);
            }
          }
          if ((s0 as any) === peg$FAILED) {
            if (input.charCodeAt(peg$currPos) === 8233) {
              s0 = peg$c27;
              peg$currPos++;
            } else {
              s0 = peg$FAILED;
              if (peg$silentFails === 0) {
                peg$fail(peg$c28);
              }
            }
          }
        }
      }
    }
    peg$silentFails--;
    if ((s0 as any) === peg$FAILED) {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c18);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parse__(): any {
    let s0, s1;

    const key = peg$currPos * 103 + 6;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = [];
    s1 = peg$parseWhiteSpace();
    if ((s1 as any) === peg$FAILED) {
      s1 = peg$parseLineTerminator();
    }
    while ((s1 as any) !== peg$FAILED) {
      s0.push(s1);
      s1 = peg$parseWhiteSpace();
      if ((s1 as any) === peg$FAILED) {
        s1 = peg$parseLineTerminator();
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseTRUE(): any {
    let s0;

    const key = peg$currPos * 103 + 7;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 4) === peg$c29) {
      s0 = peg$c29;
      peg$currPos += 4;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c30);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseFALSE(): any {
    let s0;

    const key = peg$currPos * 103 + 8;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 5) === peg$c31) {
      s0 = peg$c31;
      peg$currPos += 5;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c32);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseOLD(): any {
    let s0;

    const key = peg$currPos * 103 + 9;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 3) === peg$c33) {
      s0 = peg$c33;
      peg$currPos += 3;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c34);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseLET(): any {
    let s0;

    const key = peg$currPos * 103 + 10;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 3) === peg$c35) {
      s0 = peg$c35;
      peg$currPos += 3;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c36);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseIN(): any {
    let s0;

    const key = peg$currPos * 103 + 11;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 2) === peg$c37) {
      s0 = peg$c37;
      peg$currPos += 2;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c38);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseBOOL(): any {
    let s0;

    const key = peg$currPos * 103 + 12;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 4) === peg$c39) {
      s0 = peg$c39;
      peg$currPos += 4;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c40);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseADDRESS(): any {
    let s0;

    const key = peg$currPos * 103 + 13;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 7) === peg$c41) {
      s0 = peg$c41;
      peg$currPos += 7;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c42);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parsePAYABLE(): any {
    let s0;

    const key = peg$currPos * 103 + 14;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 7) === peg$c43) {
      s0 = peg$c43;
      peg$currPos += 7;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c44);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseBYTES(): any {
    let s0;

    const key = peg$currPos * 103 + 15;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 5) === peg$c45) {
      s0 = peg$c45;
      peg$currPos += 5;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c46);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseSTRING(): any {
    let s0;

    const key = peg$currPos * 103 + 16;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 6) === peg$c47) {
      s0 = peg$c47;
      peg$currPos += 6;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c48);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseBYTE(): any {
    let s0;

    const key = peg$currPos * 103 + 17;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 4) === peg$c49) {
      s0 = peg$c49;
      peg$currPos += 4;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c50);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseMEMORY(): any {
    let s0;

    const key = peg$currPos * 103 + 18;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 6) === peg$c51) {
      s0 = peg$c51;
      peg$currPos += 6;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c52);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseSTORAGE(): any {
    let s0;

    const key = peg$currPos * 103 + 19;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 7) === peg$c53) {
      s0 = peg$c53;
      peg$currPos += 7;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c54);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseCALLDATA(): any {
    let s0;

    const key = peg$currPos * 103 + 20;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 8) === peg$c55) {
      s0 = peg$c55;
      peg$currPos += 8;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c56);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseMAPPING(): any {
    let s0;

    const key = peg$currPos * 103 + 21;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 7) === peg$c57) {
      s0 = peg$c57;
      peg$currPos += 7;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c58);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseFUNCTION(): any {
    let s0;

    const key = peg$currPos * 103 + 22;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 8) === peg$c59) {
      s0 = peg$c59;
      peg$currPos += 8;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c60);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseRETURNS(): any {
    let s0;

    const key = peg$currPos * 103 + 23;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 7) === peg$c61) {
      s0 = peg$c61;
      peg$currPos += 7;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c62);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parsePUBLIC(): any {
    let s0;

    const key = peg$currPos * 103 + 24;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 6) === peg$c63) {
      s0 = peg$c63;
      peg$currPos += 6;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c64);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseEXTERNAL(): any {
    let s0;

    const key = peg$currPos * 103 + 25;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 8) === peg$c65) {
      s0 = peg$c65;
      peg$currPos += 8;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c66);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseINTERNAL(): any {
    let s0;

    const key = peg$currPos * 103 + 26;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 8) === peg$c67) {
      s0 = peg$c67;
      peg$currPos += 8;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c68);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parsePRIVATE(): any {
    let s0;

    const key = peg$currPos * 103 + 27;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 7) === peg$c69) {
      s0 = peg$c69;
      peg$currPos += 7;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c70);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parsePURE(): any {
    let s0;

    const key = peg$currPos * 103 + 28;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 4) === peg$c71) {
      s0 = peg$c71;
      peg$currPos += 4;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c72);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseVIEW(): any {
    let s0;

    const key = peg$currPos * 103 + 29;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 4) === peg$c73) {
      s0 = peg$c73;
      peg$currPos += 4;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c74);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseNONPAYABLE(): any {
    let s0;

    const key = peg$currPos * 103 + 30;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 10) === peg$c75) {
      s0 = peg$c75;
      peg$currPos += 10;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c76);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseINT_CONST(): any {
    let s0;

    const key = peg$currPos * 103 + 31;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 9) === peg$c77) {
      s0 = peg$c77;
      peg$currPos += 9;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c78);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseRATIONAL_CONST(): any {
    let s0;

    const key = peg$currPos * 103 + 32;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 14) === peg$c79) {
      s0 = peg$c79;
      peg$currPos += 14;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c80);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parsePOINTER(): any {
    let s0;

    const key = peg$currPos * 103 + 33;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 7) === peg$c81) {
      s0 = peg$c81;
      peg$currPos += 7;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c82);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseREF(): any {
    let s0;

    const key = peg$currPos * 103 + 34;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 3) === peg$c83) {
      s0 = peg$c83;
      peg$currPos += 3;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c84);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseTUPLE(): any {
    let s0;

    const key = peg$currPos * 103 + 35;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 5) === peg$c85) {
      s0 = peg$c85;
      peg$currPos += 5;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c86);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseTYPE(): any {
    let s0;

    const key = peg$currPos * 103 + 36;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 4) === peg$c87) {
      s0 = peg$c87;
      peg$currPos += 4;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c88);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseLITERAL_STRING(): any {
    let s0;

    const key = peg$currPos * 103 + 37;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 14) === peg$c89) {
      s0 = peg$c89;
      peg$currPos += 14;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c90);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseMODIFIER(): any {
    let s0;

    const key = peg$currPos * 103 + 38;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 8) === peg$c91) {
      s0 = peg$c91;
      peg$currPos += 8;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c92);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseCONTRACT(): any {
    let s0;

    const key = peg$currPos * 103 + 39;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 8) === peg$c93) {
      s0 = peg$c93;
      peg$currPos += 8;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c94);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseSUPER(): any {
    let s0;

    const key = peg$currPos * 103 + 40;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 5) === peg$c95) {
      s0 = peg$c95;
      peg$currPos += 5;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c96);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseLIBRARY(): any {
    let s0;

    const key = peg$currPos * 103 + 41;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 7) === peg$c97) {
      s0 = peg$c97;
      peg$currPos += 7;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c98);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseSTRUCT(): any {
    let s0;

    const key = peg$currPos * 103 + 42;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 6) === peg$c99) {
      s0 = peg$c99;
      peg$currPos += 6;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c100);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseENUM(): any {
    let s0;

    const key = peg$currPos * 103 + 43;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 4) === peg$c101) {
      s0 = peg$c101;
      peg$currPos += 4;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c102);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseMSG(): any {
    let s0;

    const key = peg$currPos * 103 + 44;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 3) === peg$c103) {
      s0 = peg$c103;
      peg$currPos += 3;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c104);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseABI(): any {
    let s0;

    const key = peg$currPos * 103 + 45;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 3) === peg$c105) {
      s0 = peg$c105;
      peg$currPos += 3;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c106);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseBLOCK(): any {
    let s0;

    const key = peg$currPos * 103 + 46;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 5) === peg$c107) {
      s0 = peg$c107;
      peg$currPos += 5;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c108);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseTX(): any {
    let s0;

    const key = peg$currPos * 103 + 47;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 2) === peg$c109) {
      s0 = peg$c109;
      peg$currPos += 2;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c110);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseSLICE(): any {
    let s0;

    const key = peg$currPos * 103 + 48;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 5) === peg$c111) {
      s0 = peg$c111;
      peg$currPos += 5;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c112);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseCONSTANT(): any {
    let s0;

    const key = peg$currPos * 103 + 49;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 8) === peg$c113) {
      s0 = peg$c113;
      peg$currPos += 8;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c114);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseHEX(): any {
    let s0;

    const key = peg$currPos * 103 + 50;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 3) === peg$c115) {
      s0 = peg$c115;
      peg$currPos += 3;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c116);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseMODULE(): any {
    let s0;

    const key = peg$currPos * 103 + 51;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.substr(peg$currPos, 6) === peg$c117) {
      s0 = peg$c117;
      peg$currPos += 6;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c118);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseKeyword(): any {
    let s0;

    const key = peg$currPos * 103 + 52;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parseTRUE();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseFALSE();
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseOLD();
        if ((s0 as any) === peg$FAILED) {
          s0 = peg$parseLET();
          if ((s0 as any) === peg$FAILED) {
            s0 = peg$parseIN();
            if ((s0 as any) === peg$FAILED) {
              s0 = peg$parseBOOL();
              if ((s0 as any) === peg$FAILED) {
                s0 = peg$parseADDRESS();
                if ((s0 as any) === peg$FAILED) {
                  s0 = peg$parsePAYABLE();
                  if ((s0 as any) === peg$FAILED) {
                    s0 = peg$parseBYTES();
                    if ((s0 as any) === peg$FAILED) {
                      s0 = peg$parseBYTE();
                      if ((s0 as any) === peg$FAILED) {
                        s0 = peg$parseMEMORY();
                        if ((s0 as any) === peg$FAILED) {
                          s0 = peg$parseSTORAGE();
                          if ((s0 as any) === peg$FAILED) {
                            s0 = peg$parseCALLDATA();
                            if ((s0 as any) === peg$FAILED) {
                              s0 = peg$parseSTRING();
                              if ((s0 as any) === peg$FAILED) {
                                s0 = peg$parseMAPPING();
                                if ((s0 as any) === peg$FAILED) {
                                  s0 = peg$parseFUNCTION();
                                  if ((s0 as any) === peg$FAILED) {
                                    s0 = peg$parseRETURNS();
                                    if ((s0 as any) === peg$FAILED) {
                                      s0 = peg$parseEXTERNAL();
                                      if ((s0 as any) === peg$FAILED) {
                                        s0 = peg$parseINTERNAL();
                                        if ((s0 as any) === peg$FAILED) {
                                          s0 = peg$parsePURE();
                                          if ((s0 as any) === peg$FAILED) {
                                            s0 = peg$parseVIEW();
                                            if ((s0 as any) === peg$FAILED) {
                                              s0 = peg$parseNONPAYABLE();
                                              if ((s0 as any) === peg$FAILED) {
                                                s0 = peg$parseINT_CONST();
                                                if ((s0 as any) === peg$FAILED) {
                                                  s0 = peg$parseRATIONAL_CONST();
                                                  if ((s0 as any) === peg$FAILED) {
                                                    s0 = peg$parseTUPLE();
                                                    if ((s0 as any) === peg$FAILED) {
                                                      s0 = peg$parseTYPE();
                                                      if ((s0 as any) === peg$FAILED) {
                                                        s0 = peg$parseLITERAL_STRING();
                                                        if ((s0 as any) === peg$FAILED) {
                                                          s0 = peg$parseMODIFIER();
                                                          if ((s0 as any) === peg$FAILED) {
                                                            s0 = peg$parseCONTRACT();
                                                            if ((s0 as any) === peg$FAILED) {
                                                              s0 = peg$parseSUPER();
                                                              if ((s0 as any) === peg$FAILED) {
                                                                s0 = peg$parseLIBRARY();
                                                                if ((s0 as any) === peg$FAILED) {
                                                                  s0 = peg$parseSTRUCT();
                                                                  if ((s0 as any) === peg$FAILED) {
                                                                    s0 = peg$parseENUM();
                                                                    if (
                                                                      (s0 as any) === peg$FAILED
                                                                    ) {
                                                                      s0 = peg$parseMSG();
                                                                      if (
                                                                        (s0 as any) === peg$FAILED
                                                                      ) {
                                                                        s0 = peg$parseABI();
                                                                        if (
                                                                          (s0 as any) === peg$FAILED
                                                                        ) {
                                                                          s0 = peg$parseBLOCK();
                                                                          if (
                                                                            (s0 as any) ===
                                                                            peg$FAILED
                                                                          ) {
                                                                            s0 = peg$parseSLICE();
                                                                            if (
                                                                              (s0 as any) ===
                                                                              peg$FAILED
                                                                            ) {
                                                                              s0 = peg$parseTX();
                                                                              if (
                                                                                (s0 as any) ===
                                                                                peg$FAILED
                                                                              ) {
                                                                                s0 =
                                                                                  peg$parseCONSTANT();
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseStringLiteral(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 53;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    if (input.charCodeAt(peg$currPos) === 39) {
      s1 = peg$c119;
      peg$currPos++;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c120);
      }
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = [];
      s3 = peg$parseSingleStringChar();
      while ((s3 as any) !== peg$FAILED) {
        s2.push(s3);
        s3 = peg$parseSingleStringChar();
      }
      if ((s2 as any) !== peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 39) {
          s3 = peg$c119;
          peg$currPos++;
        } else {
          s3 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c120);
          }
        }
        if ((s3 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c121(s2);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$currPos;
      if (input.charCodeAt(peg$currPos) === 34) {
        s1 = peg$c122;
        peg$currPos++;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c123);
        }
      }
      if ((s1 as any) !== peg$FAILED) {
        s2 = [];
        s3 = peg$parseDoubleStringChar();
        while ((s3 as any) !== peg$FAILED) {
          s2.push(s3);
          s3 = peg$parseDoubleStringChar();
        }
        if ((s2 as any) !== peg$FAILED) {
          if (input.charCodeAt(peg$currPos) === 34) {
            s3 = peg$c122;
            peg$currPos++;
          } else {
            s3 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c123);
            }
          }
          if ((s3 as any) !== peg$FAILED) {
            peg$savedPos = s0;
            s1 = peg$c121(s2);
            s0 = s1;
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseHexLiteral(): any {
    let s0, s1, s2, s3, s4;

    const key = peg$currPos * 103 + 54;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseHEX();
    if ((s1 as any) !== peg$FAILED) {
      if (input.charCodeAt(peg$currPos) === 34) {
        s2 = peg$c122;
        peg$currPos++;
      } else {
        s2 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c123);
        }
      }
      if ((s2 as any) !== peg$FAILED) {
        s3 = [];
        s4 = peg$parseHexDigit();
        while ((s4 as any) !== peg$FAILED) {
          s3.push(s4);
          s4 = peg$parseHexDigit();
        }
        if ((s3 as any) !== peg$FAILED) {
          if (input.charCodeAt(peg$currPos) === 34) {
            s4 = peg$c122;
            peg$currPos++;
          } else {
            s4 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c123);
            }
          }
          if ((s4 as any) !== peg$FAILED) {
            peg$savedPos = s0;
            s1 = peg$c124(s3);
            s0 = s1;
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$currPos;
      s1 = peg$parseHEX();
      if ((s1 as any) !== peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 39) {
          s2 = peg$c119;
          peg$currPos++;
        } else {
          s2 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c120);
          }
        }
        if ((s2 as any) !== peg$FAILED) {
          s3 = [];
          s4 = peg$parseHexDigit();
          while ((s4 as any) !== peg$FAILED) {
            s3.push(s4);
            s4 = peg$parseHexDigit();
          }
          if ((s3 as any) !== peg$FAILED) {
            if (input.charCodeAt(peg$currPos) === 39) {
              s4 = peg$c119;
              peg$currPos++;
            } else {
              s4 = peg$FAILED;
              if (peg$silentFails === 0) {
                peg$fail(peg$c120);
              }
            }
            if ((s4 as any) !== peg$FAILED) {
              peg$savedPos = s0;
              s1 = peg$c124(s3);
              s0 = s1;
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseAnyChar(): any {
    let s0;

    const key = peg$currPos * 103 + 55;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.length > peg$currPos) {
      s0 = input.charAt(peg$currPos);
      peg$currPos++;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c125);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseDoubleStringChar(): any {
    let s0, s1, s2;

    const key = peg$currPos * 103 + 56;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$currPos;
    peg$silentFails++;
    if (input.charCodeAt(peg$currPos) === 34) {
      s2 = peg$c122;
      peg$currPos++;
    } else {
      s2 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c123);
      }
    }
    if ((s2 as any) === peg$FAILED) {
      if (input.charCodeAt(peg$currPos) === 92) {
        s2 = peg$c126;
        peg$currPos++;
      } else {
        s2 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c127);
        }
      }
      if ((s2 as any) === peg$FAILED) {
        s2 = peg$parseLineTerminator();
      }
    }
    peg$silentFails--;
    if ((s2 as any) === peg$FAILED) {
      s1 = undefined;
    } else {
      peg$currPos = s1;
      s1 = peg$FAILED;
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parseAnyChar();
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c128();
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$currPos;
      if (input.charCodeAt(peg$currPos) === 92) {
        s1 = peg$c126;
        peg$currPos++;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c127);
        }
      }
      if ((s1 as any) !== peg$FAILED) {
        s2 = peg$parseEscapeSequence();
        if ((s2 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c129(s2);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseLineContinuation();
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseSingleStringChar(): any {
    let s0, s1, s2;

    const key = peg$currPos * 103 + 57;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$currPos;
    peg$silentFails++;
    if (input.charCodeAt(peg$currPos) === 39) {
      s2 = peg$c119;
      peg$currPos++;
    } else {
      s2 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c120);
      }
    }
    if ((s2 as any) === peg$FAILED) {
      if (input.charCodeAt(peg$currPos) === 92) {
        s2 = peg$c126;
        peg$currPos++;
      } else {
        s2 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c127);
        }
      }
      if ((s2 as any) === peg$FAILED) {
        s2 = peg$parseLineTerminator();
      }
    }
    peg$silentFails--;
    if ((s2 as any) === peg$FAILED) {
      s1 = undefined;
    } else {
      peg$currPos = s1;
      s1 = peg$FAILED;
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parseAnyChar();
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c128();
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$currPos;
      if (input.charCodeAt(peg$currPos) === 92) {
        s1 = peg$c126;
        peg$currPos++;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c127);
        }
      }
      if ((s1 as any) !== peg$FAILED) {
        s2 = peg$parseEscapeSequence();
        if ((s2 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c129(s2);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseLineContinuation();
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseLineContinuation(): any {
    let s0, s1, s2;

    const key = peg$currPos * 103 + 58;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    if (input.charCodeAt(peg$currPos) === 92) {
      s1 = peg$c126;
      peg$currPos++;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c127);
      }
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parseLineTerminatorSequence();
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c130();
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseEscapeSequence(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 59;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parseCharEscapeSequence();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$currPos;
      if (input.charCodeAt(peg$currPos) === 48) {
        s1 = peg$c131;
        peg$currPos++;
      } else {
        s1 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c132);
        }
      }
      if ((s1 as any) !== peg$FAILED) {
        s2 = peg$currPos;
        peg$silentFails++;
        s3 = peg$parseDecDigit();
        peg$silentFails--;
        if ((s3 as any) === peg$FAILED) {
          s2 = undefined;
        } else {
          peg$currPos = s2;
          s2 = peg$FAILED;
        }
        if ((s2 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c133();
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseHexEscapeSequence();
        if ((s0 as any) === peg$FAILED) {
          s0 = peg$parseUnicodeEscapeSequence();
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseCharEscapeSequence(): any {
    let s0;

    const key = peg$currPos * 103 + 60;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parseSingleEscapeChar();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseNonEscapeChar();
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseSingleEscapeChar(): any {
    let s0, s1;

    const key = peg$currPos * 103 + 61;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (input.charCodeAt(peg$currPos) === 39) {
      s0 = peg$c119;
      peg$currPos++;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c120);
      }
    }
    if ((s0 as any) === peg$FAILED) {
      if (input.charCodeAt(peg$currPos) === 34) {
        s0 = peg$c122;
        peg$currPos++;
      } else {
        s0 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c123);
        }
      }
      if ((s0 as any) === peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 92) {
          s0 = peg$c126;
          peg$currPos++;
        } else {
          s0 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c127);
          }
        }
        if ((s0 as any) === peg$FAILED) {
          s0 = peg$currPos;
          if (input.charCodeAt(peg$currPos) === 98) {
            s1 = peg$c134;
            peg$currPos++;
          } else {
            s1 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c135);
            }
          }
          if ((s1 as any) !== peg$FAILED) {
            peg$savedPos = s0;
            s1 = peg$c136();
          }
          s0 = s1;
          if ((s0 as any) === peg$FAILED) {
            s0 = peg$currPos;
            if (input.charCodeAt(peg$currPos) === 102) {
              s1 = peg$c137;
              peg$currPos++;
            } else {
              s1 = peg$FAILED;
              if (peg$silentFails === 0) {
                peg$fail(peg$c138);
              }
            }
            if ((s1 as any) !== peg$FAILED) {
              peg$savedPos = s0;
              s1 = peg$c139();
            }
            s0 = s1;
            if ((s0 as any) === peg$FAILED) {
              s0 = peg$currPos;
              if (input.charCodeAt(peg$currPos) === 110) {
                s1 = peg$c140;
                peg$currPos++;
              } else {
                s1 = peg$FAILED;
                if (peg$silentFails === 0) {
                  peg$fail(peg$c141);
                }
              }
              if ((s1 as any) !== peg$FAILED) {
                peg$savedPos = s0;
                s1 = peg$c142();
              }
              s0 = s1;
              if ((s0 as any) === peg$FAILED) {
                s0 = peg$currPos;
                if (input.charCodeAt(peg$currPos) === 114) {
                  s1 = peg$c143;
                  peg$currPos++;
                } else {
                  s1 = peg$FAILED;
                  if (peg$silentFails === 0) {
                    peg$fail(peg$c144);
                  }
                }
                if ((s1 as any) !== peg$FAILED) {
                  peg$savedPos = s0;
                  s1 = peg$c145();
                }
                s0 = s1;
                if ((s0 as any) === peg$FAILED) {
                  s0 = peg$currPos;
                  if (input.charCodeAt(peg$currPos) === 116) {
                    s1 = peg$c146;
                    peg$currPos++;
                  } else {
                    s1 = peg$FAILED;
                    if (peg$silentFails === 0) {
                      peg$fail(peg$c147);
                    }
                  }
                  if ((s1 as any) !== peg$FAILED) {
                    peg$savedPos = s0;
                    s1 = peg$c148();
                  }
                  s0 = s1;
                  if ((s0 as any) === peg$FAILED) {
                    s0 = peg$currPos;
                    if (input.charCodeAt(peg$currPos) === 118) {
                      s1 = peg$c149;
                      peg$currPos++;
                    } else {
                      s1 = peg$FAILED;
                      if (peg$silentFails === 0) {
                        peg$fail(peg$c150);
                      }
                    }
                    if ((s1 as any) !== peg$FAILED) {
                      peg$savedPos = s0;
                      s1 = peg$c151();
                    }
                    s0 = s1;
                  }
                }
              }
            }
          }
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseNonEscapeChar(): any {
    let s0, s1, s2;

    const key = peg$currPos * 103 + 62;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$currPos;
    peg$silentFails++;
    s2 = peg$parseEscapeChar();
    if ((s2 as any) === peg$FAILED) {
      s2 = peg$parseLineTerminator();
    }
    peg$silentFails--;
    if ((s2 as any) === peg$FAILED) {
      s1 = undefined;
    } else {
      peg$currPos = s1;
      s1 = peg$FAILED;
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parseAnyChar();
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c128();
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseHexDigit(): any {
    let s0;

    const key = peg$currPos * 103 + 63;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (peg$c152.test(input.charAt(peg$currPos))) {
      s0 = input.charAt(peg$currPos);
      peg$currPos++;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c153);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseDecDigit(): any {
    let s0;

    const key = peg$currPos * 103 + 64;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    if (peg$c154.test(input.charAt(peg$currPos))) {
      s0 = input.charAt(peg$currPos);
      peg$currPos++;
    } else {
      s0 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c155);
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseEscapeChar(): any {
    let s0;

    const key = peg$currPos * 103 + 65;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parseSingleEscapeChar();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseDecDigit();
      if ((s0 as any) === peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 120) {
          s0 = peg$c156;
          peg$currPos++;
        } else {
          s0 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c157);
          }
        }
        if ((s0 as any) === peg$FAILED) {
          if (input.charCodeAt(peg$currPos) === 117) {
            s0 = peg$c158;
            peg$currPos++;
          } else {
            s0 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c159);
            }
          }
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseHexEscapeSequence(): any {
    let s0, s1, s2, s3, s4, s5;

    const key = peg$currPos * 103 + 66;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    if (input.charCodeAt(peg$currPos) === 120) {
      s1 = peg$c156;
      peg$currPos++;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c157);
      }
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$currPos;
      s3 = peg$currPos;
      s4 = peg$parseHexDigit();
      if ((s4 as any) !== peg$FAILED) {
        s5 = peg$parseHexDigit();
        if ((s5 as any) !== peg$FAILED) {
          s4 = [s4, s5];
          s3 = s4;
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      } else {
        peg$currPos = s3;
        s3 = peg$FAILED;
      }
      if ((s3 as any) !== peg$FAILED) {
        s2 = input.substring(s2, peg$currPos);
      } else {
        s2 = s3;
      }
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c160(s2);
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseUnicodeEscapeSequence(): any {
    let s0, s1, s2, s3, s4, s5, s6, s7;

    const key = peg$currPos * 103 + 67;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    if (input.charCodeAt(peg$currPos) === 117) {
      s1 = peg$c158;
      peg$currPos++;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c159);
      }
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$currPos;
      s3 = peg$currPos;
      s4 = peg$parseHexDigit();
      if ((s4 as any) !== peg$FAILED) {
        s5 = peg$parseHexDigit();
        if ((s5 as any) !== peg$FAILED) {
          s6 = peg$parseHexDigit();
          if ((s6 as any) !== peg$FAILED) {
            s7 = peg$parseHexDigit();
            if ((s7 as any) !== peg$FAILED) {
              s4 = [s4, s5, s6, s7];
              s3 = s4;
            } else {
              peg$currPos = s3;
              s3 = peg$FAILED;
            }
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      } else {
        peg$currPos = s3;
        s3 = peg$FAILED;
      }
      if ((s3 as any) !== peg$FAILED) {
        s2 = input.substring(s2, peg$currPos);
      } else {
        s2 = s3;
      }
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c160(s2);
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseIdentifier(): any {
    let s0, s1, s2, s3, s4, s5;

    const key = peg$currPos * 103 + 68;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$currPos;
    peg$silentFails++;
    s2 = peg$currPos;
    s3 = peg$parseKeyword();
    if ((s3 as any) !== peg$FAILED) {
      if (peg$c161.test(input.charAt(peg$currPos))) {
        s4 = input.charAt(peg$currPos);
        peg$currPos++;
      } else {
        s4 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c162);
        }
      }
      if ((s4 as any) !== peg$FAILED) {
        s3 = [s3, s4];
        s2 = s3;
      } else {
        peg$currPos = s2;
        s2 = peg$FAILED;
      }
    } else {
      peg$currPos = s2;
      s2 = peg$FAILED;
    }
    peg$silentFails--;
    if ((s2 as any) === peg$FAILED) {
      s1 = undefined;
    } else {
      peg$currPos = s1;
      s1 = peg$FAILED;
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$currPos;
      if (peg$c163.test(input.charAt(peg$currPos))) {
        s3 = input.charAt(peg$currPos);
        peg$currPos++;
      } else {
        s3 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c164);
        }
      }
      if ((s3 as any) !== peg$FAILED) {
        s4 = [];
        if (peg$c165.test(input.charAt(peg$currPos))) {
          s5 = input.charAt(peg$currPos);
          peg$currPos++;
        } else {
          s5 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c166);
          }
        }
        while ((s5 as any) !== peg$FAILED) {
          s4.push(s5);
          if (peg$c165.test(input.charAt(peg$currPos))) {
            s5 = input.charAt(peg$currPos);
            peg$currPos++;
          } else {
            s5 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c166);
            }
          }
        }
        if ((s4 as any) !== peg$FAILED) {
          s3 = [s3, s4];
          s2 = s3;
        } else {
          peg$currPos = s2;
          s2 = peg$FAILED;
        }
      } else {
        peg$currPos = s2;
        s2 = peg$FAILED;
      }
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c167(s2);
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseWord(): any {
    let s0, s1, s2, s3, s4;

    const key = peg$currPos * 103 + 69;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$currPos;
    if (peg$c163.test(input.charAt(peg$currPos))) {
      s2 = input.charAt(peg$currPos);
      peg$currPos++;
    } else {
      s2 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c164);
      }
    }
    if ((s2 as any) !== peg$FAILED) {
      s3 = [];
      if (peg$c165.test(input.charAt(peg$currPos))) {
        s4 = input.charAt(peg$currPos);
        peg$currPos++;
      } else {
        s4 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c166);
        }
      }
      while ((s4 as any) !== peg$FAILED) {
        s3.push(s4);
        if (peg$c165.test(input.charAt(peg$currPos))) {
          s4 = input.charAt(peg$currPos);
          peg$currPos++;
        } else {
          s4 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c166);
          }
        }
      }
      if ((s3 as any) !== peg$FAILED) {
        s2 = [s2, s3];
        s1 = s2;
      } else {
        peg$currPos = s1;
        s1 = peg$FAILED;
      }
    } else {
      peg$currPos = s1;
      s1 = peg$FAILED;
    }
    if ((s1 as any) !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$c167(s1);
    }
    s0 = s1;

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseNumber(): any {
    let s0, s1, s2;

    const key = peg$currPos * 103 + 70;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = [];
    if (peg$c154.test(input.charAt(peg$currPos))) {
      s2 = input.charAt(peg$currPos);
      peg$currPos++;
    } else {
      s2 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c155);
      }
    }
    if ((s2 as any) !== peg$FAILED) {
      while ((s2 as any) !== peg$FAILED) {
        s1.push(s2);
        if (peg$c154.test(input.charAt(peg$currPos))) {
          s2 = input.charAt(peg$currPos);
          peg$currPos++;
        } else {
          s2 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c155);
          }
        }
      }
    } else {
      s1 = peg$FAILED;
    }
    if ((s1 as any) !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$c168();
    }
    s0 = s1;

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseMaybeNegNumber(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 71;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    if (input.charCodeAt(peg$currPos) === 45) {
      s1 = peg$c169;
      peg$currPos++;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c170);
      }
    }
    if ((s1 as any) === peg$FAILED) {
      s1 = null;
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parseNumber();
        if ((s3 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c171(s1, s3);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseInaccessibleDynamicType(): any {
    let s0, s1;

    const key = peg$currPos * 103 + 72;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    if (input.substr(peg$currPos, 25) === peg$c172) {
      s1 = peg$c172;
      peg$currPos += 25;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c173);
      }
    }
    if ((s1 as any) !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$c174();
    }
    s0 = s1;

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseSimpleType(): any {
    let s0;

    const key = peg$currPos * 103 + 73;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parseBoolType();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseInaccessibleDynamicType();
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseAddressType();
        if ((s0 as any) === peg$FAILED) {
          s0 = peg$parseIntLiteralType();
          if ((s0 as any) === peg$FAILED) {
            s0 = peg$parseRationalLiteralType();
            if ((s0 as any) === peg$FAILED) {
              s0 = peg$parseStringLiteralType();
              if ((s0 as any) === peg$FAILED) {
                s0 = peg$parseIntType();
                if ((s0 as any) === peg$FAILED) {
                  s0 = peg$parseBytesType();
                  if ((s0 as any) === peg$FAILED) {
                    s0 = peg$parseFixedSizeBytesType();
                    if ((s0 as any) === peg$FAILED) {
                      s0 = peg$parseStringType();
                      if ((s0 as any) === peg$FAILED) {
                        s0 = peg$parseUserDefinedType();
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseStringLiteralErrorMsg(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 74;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    if (input.charCodeAt(peg$currPos) === 40) {
      s1 = peg$c175;
      peg$currPos++;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c176);
      }
    }
    if ((s1 as any) !== peg$FAILED) {
      s2 = [];
      if (peg$c177.test(input.charAt(peg$currPos))) {
        s3 = input.charAt(peg$currPos);
        peg$currPos++;
      } else {
        s3 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c178);
        }
      }
      while ((s3 as any) !== peg$FAILED) {
        s2.push(s3);
        if (peg$c177.test(input.charAt(peg$currPos))) {
          s3 = input.charAt(peg$currPos);
          peg$currPos++;
        } else {
          s3 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c178);
          }
        }
      }
      if ((s2 as any) !== peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 41) {
          s3 = peg$c179;
          peg$currPos++;
        } else {
          s3 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c180);
          }
        }
        if ((s3 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c181();
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseStringLiteralType(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 75;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseLITERAL_STRING();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parseStringLiteral();
        if ((s3 as any) === peg$FAILED) {
          s3 = peg$parseHexLiteral();
          if ((s3 as any) === peg$FAILED) {
            s3 = peg$parseStringLiteralErrorMsg();
          }
        }
        if ((s3 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c182(s3);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseIntLiteralType(): any {
    let s0, s1, s2, s3, s4, s5, s6, s7, s8;

    const key = peg$currPos * 103 + 76;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseINT_CONST();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parseMaybeNegNumber();
        if ((s3 as any) !== peg$FAILED) {
          s4 = peg$currPos;
          if (input.substr(peg$currPos, 4) === peg$c183) {
            s5 = peg$c183;
            peg$currPos += 4;
          } else {
            s5 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c184);
            }
          }
          if ((s5 as any) !== peg$FAILED) {
            s6 = [];
            if (peg$c177.test(input.charAt(peg$currPos))) {
              s7 = input.charAt(peg$currPos);
              peg$currPos++;
            } else {
              s7 = peg$FAILED;
              if (peg$silentFails === 0) {
                peg$fail(peg$c178);
              }
            }
            while ((s7 as any) !== peg$FAILED) {
              s6.push(s7);
              if (peg$c177.test(input.charAt(peg$currPos))) {
                s7 = input.charAt(peg$currPos);
                peg$currPos++;
              } else {
                s7 = peg$FAILED;
                if (peg$silentFails === 0) {
                  peg$fail(peg$c178);
                }
              }
            }
            if ((s6 as any) !== peg$FAILED) {
              if (input.substr(peg$currPos, 4) === peg$c185) {
                s7 = peg$c185;
                peg$currPos += 4;
              } else {
                s7 = peg$FAILED;
                if (peg$silentFails === 0) {
                  peg$fail(peg$c186);
                }
              }
              if ((s7 as any) !== peg$FAILED) {
                s8 = peg$parseNumber();
                if ((s8 as any) !== peg$FAILED) {
                  s5 = [s5, s6, s7, s8];
                  s4 = s5;
                } else {
                  peg$currPos = s4;
                  s4 = peg$FAILED;
                }
              } else {
                peg$currPos = s4;
                s4 = peg$FAILED;
              }
            } else {
              peg$currPos = s4;
              s4 = peg$FAILED;
            }
          } else {
            peg$currPos = s4;
            s4 = peg$FAILED;
          }
          if ((s4 as any) === peg$FAILED) {
            s4 = null;
          }
          if ((s4 as any) !== peg$FAILED) {
            peg$savedPos = s0;
            s1 = peg$c187(s3, s4);
            s0 = s1;
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseRationalLiteralType(): any {
    let s0, s1, s2, s3, s4, s5, s6, s7;

    const key = peg$currPos * 103 + 77;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseRATIONAL_CONST();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parseMaybeNegNumber();
        if ((s3 as any) !== peg$FAILED) {
          s4 = peg$parse__();
          if ((s4 as any) !== peg$FAILED) {
            if (input.charCodeAt(peg$currPos) === 47) {
              s5 = peg$c188;
              peg$currPos++;
            } else {
              s5 = peg$FAILED;
              if (peg$silentFails === 0) {
                peg$fail(peg$c189);
              }
            }
            if ((s5 as any) !== peg$FAILED) {
              s6 = peg$parse__();
              if ((s6 as any) !== peg$FAILED) {
                s7 = peg$parseNumber();
                if ((s7 as any) !== peg$FAILED) {
                  peg$savedPos = s0;
                  s1 = peg$c190(s3, s7);
                  s0 = s1;
                } else {
                  peg$currPos = s0;
                  s0 = peg$FAILED;
                }
              } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
              }
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseBoolType(): any {
    let s0, s1;

    const key = peg$currPos * 103 + 78;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseBOOL();
    if ((s1 as any) !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$c191();
    }
    s0 = s1;

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseAddressType(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 79;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseADDRESS();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parsePAYABLE();
        if ((s3 as any) === peg$FAILED) {
          s3 = null;
        }
        if ((s3 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c192(s3);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseIntType(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 80;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    if (input.charCodeAt(peg$currPos) === 117) {
      s1 = peg$c158;
      peg$currPos++;
    } else {
      s1 = peg$FAILED;
      if (peg$silentFails === 0) {
        peg$fail(peg$c159);
      }
    }
    if ((s1 as any) === peg$FAILED) {
      s1 = null;
    }
    if ((s1 as any) !== peg$FAILED) {
      if (input.substr(peg$currPos, 3) === peg$c193) {
        s2 = peg$c193;
        peg$currPos += 3;
      } else {
        s2 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c194);
        }
      }
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parseNumber();
        if ((s3 as any) === peg$FAILED) {
          s3 = null;
        }
        if ((s3 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c195(s1, s3);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseFixedSizeBytesType(): any {
    let s0, s1, s2;

    const key = peg$currPos * 103 + 81;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseBYTES();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parseNumber();
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c196(s2);
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$currPos;
      s1 = peg$parseBYTE();
      if ((s1 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c197();
      }
      s0 = s1;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseBytesType(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 82;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseBYTES();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$currPos;
      peg$silentFails++;
      s3 = peg$parseNumber();
      peg$silentFails--;
      if ((s3 as any) === peg$FAILED) {
        s2 = undefined;
      } else {
        peg$currPos = s2;
        s2 = peg$FAILED;
      }
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c198();
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseStringType(): any {
    let s0, s1;

    const key = peg$currPos * 103 + 83;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseSTRING();
    if ((s1 as any) !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$c199();
    }
    s0 = s1;

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseFQName(): any {
    let s0, s1, s2, s3, s4, s5;

    const key = peg$currPos * 103 + 84;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseIdentifier();
    if ((s1 as any) !== peg$FAILED) {
      s2 = [];
      s3 = peg$currPos;
      if (input.charCodeAt(peg$currPos) === 46) {
        s4 = peg$c200;
        peg$currPos++;
      } else {
        s4 = peg$FAILED;
        if (peg$silentFails === 0) {
          peg$fail(peg$c201);
        }
      }
      if ((s4 as any) !== peg$FAILED) {
        s5 = peg$parseWord();
        if ((s5 as any) !== peg$FAILED) {
          s4 = [s4, s5];
          s3 = s4;
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      } else {
        peg$currPos = s3;
        s3 = peg$FAILED;
      }
      while ((s3 as any) !== peg$FAILED) {
        s2.push(s3);
        s3 = peg$currPos;
        if (input.charCodeAt(peg$currPos) === 46) {
          s4 = peg$c200;
          peg$currPos++;
        } else {
          s4 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c201);
          }
        }
        if ((s4 as any) !== peg$FAILED) {
          s5 = peg$parseWord();
          if ((s5 as any) !== peg$FAILED) {
            s4 = [s4, s5];
            s3 = s4;
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      }
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c128();
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseUserDefinedType(): any {
    let s0, s1, s2, s3, s4, s5;

    const key = peg$currPos * 103 + 85;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseSTRUCT();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parseFQName();
        if ((s3 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c202(s3);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$currPos;
      s1 = peg$parseENUM();
      if ((s1 as any) !== peg$FAILED) {
        s2 = peg$parse__();
        if ((s2 as any) !== peg$FAILED) {
          s3 = peg$parseFQName();
          if ((s3 as any) !== peg$FAILED) {
            peg$savedPos = s0;
            s1 = peg$c203(s3);
            s0 = s1;
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$currPos;
        s1 = peg$parseCONTRACT();
        if ((s1 as any) !== peg$FAILED) {
          s2 = peg$parse__();
          if ((s2 as any) !== peg$FAILED) {
            s3 = peg$parseSUPER();
            if ((s3 as any) === peg$FAILED) {
              s3 = null;
            }
            if ((s3 as any) !== peg$FAILED) {
              s4 = peg$parse__();
              if ((s4 as any) !== peg$FAILED) {
                s5 = peg$parseFQName();
                if ((s5 as any) !== peg$FAILED) {
                  peg$savedPos = s0;
                  s1 = peg$c204(s5);
                  s0 = s1;
                } else {
                  peg$currPos = s0;
                  s0 = peg$FAILED;
                }
              } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
              }
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
        if ((s0 as any) === peg$FAILED) {
          s0 = peg$currPos;
          s1 = peg$parseLIBRARY();
          if ((s1 as any) !== peg$FAILED) {
            s2 = peg$parse__();
            if ((s2 as any) !== peg$FAILED) {
              s3 = peg$parseFQName();
              if ((s3 as any) !== peg$FAILED) {
                peg$savedPos = s0;
                s1 = peg$c204(s3);
                s0 = s1;
              } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
              }
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
          if ((s0 as any) === peg$FAILED) {
            s0 = peg$currPos;
            s1 = peg$parseFQName();
            if ((s1 as any) !== peg$FAILED) {
              peg$savedPos = s0;
              s1 = peg$c205(s1);
            }
            s0 = s1;
          }
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseMappingType(): any {
    let s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11;

    const key = peg$currPos * 103 + 86;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseMAPPING();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 40) {
          s3 = peg$c175;
          peg$currPos++;
        } else {
          s3 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c176);
          }
        }
        if ((s3 as any) !== peg$FAILED) {
          s4 = peg$parse__();
          if ((s4 as any) !== peg$FAILED) {
            s5 = peg$parseArrayPtrType();
            if ((s5 as any) !== peg$FAILED) {
              s6 = peg$parse__();
              if ((s6 as any) !== peg$FAILED) {
                if (input.substr(peg$currPos, 2) === peg$c206) {
                  s7 = peg$c206;
                  peg$currPos += 2;
                } else {
                  s7 = peg$FAILED;
                  if (peg$silentFails === 0) {
                    peg$fail(peg$c207);
                  }
                }
                if ((s7 as any) !== peg$FAILED) {
                  s8 = peg$parse__();
                  if ((s8 as any) !== peg$FAILED) {
                    s9 = peg$parseType();
                    if ((s9 as any) !== peg$FAILED) {
                      s10 = peg$parse__();
                      if ((s10 as any) !== peg$FAILED) {
                        if (input.charCodeAt(peg$currPos) === 41) {
                          s11 = peg$c179;
                          peg$currPos++;
                        } else {
                          s11 = peg$FAILED;
                          if (peg$silentFails === 0) {
                            peg$fail(peg$c180);
                          }
                        }
                        if ((s11 as any) !== peg$FAILED) {
                          peg$savedPos = s0;
                          s1 = peg$c208(s5, s9);
                          s0 = s1;
                        } else {
                          peg$currPos = s0;
                          s0 = peg$FAILED;
                        }
                      } else {
                        peg$currPos = s0;
                        s0 = peg$FAILED;
                      }
                    } else {
                      peg$currPos = s0;
                      s0 = peg$FAILED;
                    }
                  } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                  }
                } else {
                  peg$currPos = s0;
                  s0 = peg$FAILED;
                }
              } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
              }
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseDataLocation(): any {
    let s0;

    const key = peg$currPos * 103 + 87;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parseMEMORY();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseSTORAGE();
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseCALLDATA();
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parsePointerType(): any {
    let s0;

    const key = peg$currPos * 103 + 88;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parsePOINTER();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseREF();
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseSLICE();
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseTypeList(): any {
    let s0, s1, s2, s3, s4, s5, s6, s7;

    const key = peg$currPos * 103 + 89;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseType();
    if ((s1 as any) !== peg$FAILED) {
      s2 = [];
      s3 = peg$currPos;
      s4 = peg$parse__();
      if ((s4 as any) !== peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 44) {
          s5 = peg$c209;
          peg$currPos++;
        } else {
          s5 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c210);
          }
        }
        if ((s5 as any) !== peg$FAILED) {
          s6 = peg$parse__();
          if ((s6 as any) !== peg$FAILED) {
            s7 = peg$parseType();
            if ((s7 as any) !== peg$FAILED) {
              s4 = [s4, s5, s6, s7];
              s3 = s4;
            } else {
              peg$currPos = s3;
              s3 = peg$FAILED;
            }
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      } else {
        peg$currPos = s3;
        s3 = peg$FAILED;
      }
      while ((s3 as any) !== peg$FAILED) {
        s2.push(s3);
        s3 = peg$currPos;
        s4 = peg$parse__();
        if ((s4 as any) !== peg$FAILED) {
          if (input.charCodeAt(peg$currPos) === 44) {
            s5 = peg$c209;
            peg$currPos++;
          } else {
            s5 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c210);
            }
          }
          if ((s5 as any) !== peg$FAILED) {
            s6 = peg$parse__();
            if ((s6 as any) !== peg$FAILED) {
              s7 = peg$parseType();
              if ((s7 as any) !== peg$FAILED) {
                s4 = [s4, s5, s6, s7];
                s3 = s4;
              } else {
                peg$currPos = s3;
                s3 = peg$FAILED;
              }
            } else {
              peg$currPos = s3;
              s3 = peg$FAILED;
            }
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      }
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c211(s1, s2);
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$currPos;
      s1 = peg$parse__();
      if ((s1 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c212();
      }
      s0 = s1;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseFunctionVisibility(): any {
    let s0;

    const key = peg$currPos * 103 + 90;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parsePRIVATE();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseINTERNAL();
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseEXTERNAL();
        if ((s0 as any) === peg$FAILED) {
          s0 = peg$parsePUBLIC();
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseFunctionMutability(): any {
    let s0;

    const key = peg$currPos * 103 + 91;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parsePURE();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseVIEW();
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parsePAYABLE();
        if ((s0 as any) === peg$FAILED) {
          s0 = peg$parseNONPAYABLE();
          if ((s0 as any) === peg$FAILED) {
            s0 = peg$parseCONSTANT();
          }
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseFunctionDecorator(): any {
    let s0;

    const key = peg$currPos * 103 + 92;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parseFunctionVisibility();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseFunctionMutability();
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseFunctionDecoratorList(): any {
    let s0, s1, s2, s3, s4, s5;

    const key = peg$currPos * 103 + 93;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseFunctionDecorator();
    if ((s1 as any) !== peg$FAILED) {
      s2 = [];
      s3 = peg$currPos;
      s4 = peg$parse__();
      if ((s4 as any) !== peg$FAILED) {
        s5 = peg$parseFunctionDecorator();
        if ((s5 as any) !== peg$FAILED) {
          s4 = [s4, s5];
          s3 = s4;
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      } else {
        peg$currPos = s3;
        s3 = peg$FAILED;
      }
      while ((s3 as any) !== peg$FAILED) {
        s2.push(s3);
        s3 = peg$currPos;
        s4 = peg$parse__();
        if ((s4 as any) !== peg$FAILED) {
          s5 = peg$parseFunctionDecorator();
          if ((s5 as any) !== peg$FAILED) {
            s4 = [s4, s5];
            s3 = s4;
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      }
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c213(s1, s2);
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseFunctionType(): any {
    let s0,
      s1,
      s2,
      s3,
      s4,
      s5,
      s6,
      s7,
      s8,
      s9,
      s10,
      s11,
      s12,
      s13,
      s14,
      s15,
      s16,
      s17,
      s18,
      s19,
      s20;

    const key = peg$currPos * 103 + 94;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseFUNCTION();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parseFQName();
        if ((s3 as any) === peg$FAILED) {
          s3 = null;
        }
        if ((s3 as any) !== peg$FAILED) {
          s4 = peg$parse__();
          if ((s4 as any) !== peg$FAILED) {
            if (input.charCodeAt(peg$currPos) === 40) {
              s5 = peg$c175;
              peg$currPos++;
            } else {
              s5 = peg$FAILED;
              if (peg$silentFails === 0) {
                peg$fail(peg$c176);
              }
            }
            if ((s5 as any) !== peg$FAILED) {
              s6 = peg$parse__();
              if ((s6 as any) !== peg$FAILED) {
                s7 = peg$parseTypeList();
                if ((s7 as any) === peg$FAILED) {
                  s7 = null;
                }
                if ((s7 as any) !== peg$FAILED) {
                  s8 = peg$parse__();
                  if ((s8 as any) !== peg$FAILED) {
                    if (input.charCodeAt(peg$currPos) === 41) {
                      s9 = peg$c179;
                      peg$currPos++;
                    } else {
                      s9 = peg$FAILED;
                      if (peg$silentFails === 0) {
                        peg$fail(peg$c180);
                      }
                    }
                    if ((s9 as any) !== peg$FAILED) {
                      s10 = peg$parse__();
                      if ((s10 as any) !== peg$FAILED) {
                        s11 = peg$parseFunctionDecoratorList();
                        if ((s11 as any) === peg$FAILED) {
                          s11 = null;
                        }
                        if ((s11 as any) !== peg$FAILED) {
                          s12 = peg$parse__();
                          if ((s12 as any) !== peg$FAILED) {
                            s13 = peg$currPos;
                            s14 = peg$parseRETURNS();
                            if ((s14 as any) !== peg$FAILED) {
                              s15 = peg$parse__();
                              if ((s15 as any) !== peg$FAILED) {
                                if (input.charCodeAt(peg$currPos) === 40) {
                                  s16 = peg$c175;
                                  peg$currPos++;
                                } else {
                                  s16 = peg$FAILED;
                                  if (peg$silentFails === 0) {
                                    peg$fail(peg$c176);
                                  }
                                }
                                if ((s16 as any) !== peg$FAILED) {
                                  s17 = peg$parse__();
                                  if ((s17 as any) !== peg$FAILED) {
                                    s18 = peg$parseTypeList();
                                    if ((s18 as any) !== peg$FAILED) {
                                      s19 = peg$parse__();
                                      if ((s19 as any) !== peg$FAILED) {
                                        if (input.charCodeAt(peg$currPos) === 41) {
                                          s20 = peg$c179;
                                          peg$currPos++;
                                        } else {
                                          s20 = peg$FAILED;
                                          if (peg$silentFails === 0) {
                                            peg$fail(peg$c180);
                                          }
                                        }
                                        if ((s20 as any) !== peg$FAILED) {
                                          s14 = [s14, s15, s16, s17, s18, s19, s20];
                                          s13 = s14;
                                        } else {
                                          peg$currPos = s13;
                                          s13 = peg$FAILED;
                                        }
                                      } else {
                                        peg$currPos = s13;
                                        s13 = peg$FAILED;
                                      }
                                    } else {
                                      peg$currPos = s13;
                                      s13 = peg$FAILED;
                                    }
                                  } else {
                                    peg$currPos = s13;
                                    s13 = peg$FAILED;
                                  }
                                } else {
                                  peg$currPos = s13;
                                  s13 = peg$FAILED;
                                }
                              } else {
                                peg$currPos = s13;
                                s13 = peg$FAILED;
                              }
                            } else {
                              peg$currPos = s13;
                              s13 = peg$FAILED;
                            }
                            if ((s13 as any) === peg$FAILED) {
                              s13 = null;
                            }
                            if ((s13 as any) !== peg$FAILED) {
                              peg$savedPos = s0;
                              s1 = peg$c214(s3, s7, s11, s13);
                              s0 = s1;
                            } else {
                              peg$currPos = s0;
                              s0 = peg$FAILED;
                            }
                          } else {
                            peg$currPos = s0;
                            s0 = peg$FAILED;
                          }
                        } else {
                          peg$currPos = s0;
                          s0 = peg$FAILED;
                        }
                      } else {
                        peg$currPos = s0;
                        s0 = peg$FAILED;
                      }
                    } else {
                      peg$currPos = s0;
                      s0 = peg$FAILED;
                    }
                  } else {
                    peg$currPos = s0;
                    s0 = peg$FAILED;
                  }
                } else {
                  peg$currPos = s0;
                  s0 = peg$FAILED;
                }
              } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
              }
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseModifierType(): any {
    let s0, s1, s2, s3, s4, s5, s6, s7;

    const key = peg$currPos * 103 + 95;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseMODIFIER();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 40) {
          s3 = peg$c175;
          peg$currPos++;
        } else {
          s3 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c176);
          }
        }
        if ((s3 as any) !== peg$FAILED) {
          s4 = peg$parse__();
          if ((s4 as any) !== peg$FAILED) {
            s5 = peg$parseTypeList();
            if ((s5 as any) === peg$FAILED) {
              s5 = null;
            }
            if ((s5 as any) !== peg$FAILED) {
              s6 = peg$parse__();
              if ((s6 as any) !== peg$FAILED) {
                if (input.charCodeAt(peg$currPos) === 41) {
                  s7 = peg$c179;
                  peg$currPos++;
                } else {
                  s7 = peg$FAILED;
                  if (peg$silentFails === 0) {
                    peg$fail(peg$c180);
                  }
                }
                if ((s7 as any) !== peg$FAILED) {
                  peg$savedPos = s0;
                  s1 = peg$c215(s5);
                  s0 = s1;
                } else {
                  peg$currPos = s0;
                  s0 = peg$FAILED;
                }
              } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
              }
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseTupleType(): any {
    let s0, s1, s2, s3, s4, s5, s6, s7;

    const key = peg$currPos * 103 + 96;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseTUPLE();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 40) {
          s3 = peg$c175;
          peg$currPos++;
        } else {
          s3 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c176);
          }
        }
        if ((s3 as any) !== peg$FAILED) {
          s4 = peg$parse__();
          if ((s4 as any) !== peg$FAILED) {
            s5 = peg$parseTypeList();
            if ((s5 as any) === peg$FAILED) {
              s5 = null;
            }
            if ((s5 as any) !== peg$FAILED) {
              s6 = peg$parse__();
              if ((s6 as any) !== peg$FAILED) {
                if (input.charCodeAt(peg$currPos) === 41) {
                  s7 = peg$c179;
                  peg$currPos++;
                } else {
                  s7 = peg$FAILED;
                  if (peg$silentFails === 0) {
                    peg$fail(peg$c180);
                  }
                }
                if ((s7 as any) !== peg$FAILED) {
                  peg$savedPos = s0;
                  s1 = peg$c216(s5);
                  s0 = s1;
                } else {
                  peg$currPos = s0;
                  s0 = peg$FAILED;
                }
              } else {
                peg$currPos = s0;
                s0 = peg$FAILED;
              }
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseTypeExprType(): any {
    let s0, s1, s2, s3, s4, s5;

    const key = peg$currPos * 103 + 97;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseTYPE();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        if (input.charCodeAt(peg$currPos) === 40) {
          s3 = peg$c175;
          peg$currPos++;
        } else {
          s3 = peg$FAILED;
          if (peg$silentFails === 0) {
            peg$fail(peg$c176);
          }
        }
        if ((s3 as any) !== peg$FAILED) {
          s4 = peg$parseType();
          if ((s4 as any) !== peg$FAILED) {
            if (input.charCodeAt(peg$currPos) === 41) {
              s5 = peg$c179;
              peg$currPos++;
            } else {
              s5 = peg$FAILED;
              if (peg$silentFails === 0) {
                peg$fail(peg$c180);
              }
            }
            if ((s5 as any) !== peg$FAILED) {
              peg$savedPos = s0;
              s1 = peg$c217(s4);
              s0 = s1;
            } else {
              peg$currPos = s0;
              s0 = peg$FAILED;
            }
          } else {
            peg$currPos = s0;
            s0 = peg$FAILED;
          }
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseBuiltinTypes(): any {
    let s0, s1;

    const key = peg$currPos * 103 + 98;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseMSG();
    if ((s1 as any) !== peg$FAILED) {
      peg$savedPos = s0;
      s1 = peg$c218(s1);
    }
    s0 = s1;
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$currPos;
      s1 = peg$parseABI();
      if ((s1 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c218(s1);
      }
      s0 = s1;
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$currPos;
        s1 = peg$parseBLOCK();
        if ((s1 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c218(s1);
        }
        s0 = s1;
        if ((s0 as any) === peg$FAILED) {
          s0 = peg$currPos;
          s1 = peg$parseTX();
          if ((s1 as any) !== peg$FAILED) {
            peg$savedPos = s0;
            s1 = peg$c218(s1);
          }
          s0 = s1;
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseModuleType(): any {
    let s0, s1, s2, s3;

    const key = peg$currPos * 103 + 99;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseMODULE();
    if ((s1 as any) !== peg$FAILED) {
      s2 = peg$parse__();
      if ((s2 as any) !== peg$FAILED) {
        s3 = peg$parseStringLiteral();
        if ((s3 as any) !== peg$FAILED) {
          peg$savedPos = s0;
          s1 = peg$c219(s3);
          s0 = s1;
        } else {
          peg$currPos = s0;
          s0 = peg$FAILED;
        }
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseNonArrPtrType(): any {
    let s0;

    const key = peg$currPos * 103 + 100;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parseMappingType();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseSimpleType();
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseFunctionType();
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseArrayPtrType(): any {
    let s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10;

    const key = peg$currPos * 103 + 101;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$currPos;
    s1 = peg$parseNonArrPtrType();
    if ((s1 as any) !== peg$FAILED) {
      s2 = [];
      s3 = peg$currPos;
      s4 = peg$parse__();
      if ((s4 as any) !== peg$FAILED) {
        s5 = peg$currPos;
        peg$silentFails++;
        s6 = peg$parsePointerType();
        peg$silentFails--;
        if ((s6 as any) === peg$FAILED) {
          s5 = undefined;
        } else {
          peg$currPos = s5;
          s5 = peg$FAILED;
        }
        if ((s5 as any) !== peg$FAILED) {
          if (input.charCodeAt(peg$currPos) === 91) {
            s6 = peg$c220;
            peg$currPos++;
          } else {
            s6 = peg$FAILED;
            if (peg$silentFails === 0) {
              peg$fail(peg$c221);
            }
          }
          if ((s6 as any) !== peg$FAILED) {
            s7 = peg$parse__();
            if ((s7 as any) !== peg$FAILED) {
              s8 = peg$parseNumber();
              if ((s8 as any) === peg$FAILED) {
                s8 = null;
              }
              if ((s8 as any) !== peg$FAILED) {
                s9 = peg$parse__();
                if ((s9 as any) !== peg$FAILED) {
                  if (input.charCodeAt(peg$currPos) === 93) {
                    s10 = peg$c222;
                    peg$currPos++;
                  } else {
                    s10 = peg$FAILED;
                    if (peg$silentFails === 0) {
                      peg$fail(peg$c223);
                    }
                  }
                  if ((s10 as any) !== peg$FAILED) {
                    s4 = [s4, s5, s6, s7, s8, s9, s10];
                    s3 = s4;
                  } else {
                    peg$currPos = s3;
                    s3 = peg$FAILED;
                  }
                } else {
                  peg$currPos = s3;
                  s3 = peg$FAILED;
                }
              } else {
                peg$currPos = s3;
                s3 = peg$FAILED;
              }
            } else {
              peg$currPos = s3;
              s3 = peg$FAILED;
            }
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      } else {
        peg$currPos = s3;
        s3 = peg$FAILED;
      }
      if ((s3 as any) === peg$FAILED) {
        s3 = peg$currPos;
        s4 = peg$parse__();
        if ((s4 as any) !== peg$FAILED) {
          s5 = peg$parseDataLocation();
          if ((s5 as any) !== peg$FAILED) {
            s6 = peg$currPos;
            s7 = peg$parse__();
            if ((s7 as any) !== peg$FAILED) {
              s8 = peg$parsePointerType();
              if ((s8 as any) !== peg$FAILED) {
                s7 = [s7, s8];
                s6 = s7;
              } else {
                peg$currPos = s6;
                s6 = peg$FAILED;
              }
            } else {
              peg$currPos = s6;
              s6 = peg$FAILED;
            }
            if ((s6 as any) === peg$FAILED) {
              s6 = null;
            }
            if ((s6 as any) !== peg$FAILED) {
              s4 = [s4, s5, s6];
              s3 = s4;
            } else {
              peg$currPos = s3;
              s3 = peg$FAILED;
            }
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
      }
      while ((s3 as any) !== peg$FAILED) {
        s2.push(s3);
        s3 = peg$currPos;
        s4 = peg$parse__();
        if ((s4 as any) !== peg$FAILED) {
          s5 = peg$currPos;
          peg$silentFails++;
          s6 = peg$parsePointerType();
          peg$silentFails--;
          if ((s6 as any) === peg$FAILED) {
            s5 = undefined;
          } else {
            peg$currPos = s5;
            s5 = peg$FAILED;
          }
          if ((s5 as any) !== peg$FAILED) {
            if (input.charCodeAt(peg$currPos) === 91) {
              s6 = peg$c220;
              peg$currPos++;
            } else {
              s6 = peg$FAILED;
              if (peg$silentFails === 0) {
                peg$fail(peg$c221);
              }
            }
            if ((s6 as any) !== peg$FAILED) {
              s7 = peg$parse__();
              if ((s7 as any) !== peg$FAILED) {
                s8 = peg$parseNumber();
                if ((s8 as any) === peg$FAILED) {
                  s8 = null;
                }
                if ((s8 as any) !== peg$FAILED) {
                  s9 = peg$parse__();
                  if ((s9 as any) !== peg$FAILED) {
                    if (input.charCodeAt(peg$currPos) === 93) {
                      s10 = peg$c222;
                      peg$currPos++;
                    } else {
                      s10 = peg$FAILED;
                      if (peg$silentFails === 0) {
                        peg$fail(peg$c223);
                      }
                    }
                    if ((s10 as any) !== peg$FAILED) {
                      s4 = [s4, s5, s6, s7, s8, s9, s10];
                      s3 = s4;
                    } else {
                      peg$currPos = s3;
                      s3 = peg$FAILED;
                    }
                  } else {
                    peg$currPos = s3;
                    s3 = peg$FAILED;
                  }
                } else {
                  peg$currPos = s3;
                  s3 = peg$FAILED;
                }
              } else {
                peg$currPos = s3;
                s3 = peg$FAILED;
              }
            } else {
              peg$currPos = s3;
              s3 = peg$FAILED;
            }
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
        } else {
          peg$currPos = s3;
          s3 = peg$FAILED;
        }
        if ((s3 as any) === peg$FAILED) {
          s3 = peg$currPos;
          s4 = peg$parse__();
          if ((s4 as any) !== peg$FAILED) {
            s5 = peg$parseDataLocation();
            if ((s5 as any) !== peg$FAILED) {
              s6 = peg$currPos;
              s7 = peg$parse__();
              if ((s7 as any) !== peg$FAILED) {
                s8 = peg$parsePointerType();
                if ((s8 as any) !== peg$FAILED) {
                  s7 = [s7, s8];
                  s6 = s7;
                } else {
                  peg$currPos = s6;
                  s6 = peg$FAILED;
                }
              } else {
                peg$currPos = s6;
                s6 = peg$FAILED;
              }
              if ((s6 as any) === peg$FAILED) {
                s6 = null;
              }
              if ((s6 as any) !== peg$FAILED) {
                s4 = [s4, s5, s6];
                s3 = s4;
              } else {
                peg$currPos = s3;
                s3 = peg$FAILED;
              }
            } else {
              peg$currPos = s3;
              s3 = peg$FAILED;
            }
          } else {
            peg$currPos = s3;
            s3 = peg$FAILED;
          }
        }
      }
      if ((s2 as any) !== peg$FAILED) {
        peg$savedPos = s0;
        s1 = peg$c224(s1, s2);
        s0 = s1;
      } else {
        peg$currPos = s0;
        s0 = peg$FAILED;
      }
    } else {
      peg$currPos = s0;
      s0 = peg$FAILED;
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  function peg$parseType(): any {
    let s0;

    const key = peg$currPos * 103 + 102;
    const cached: ICached = peg$resultsCache[key];

    if (cached) {
      peg$currPos = cached.nextPos;

      return cached.result;
    }

    s0 = peg$parseModuleType();
    if ((s0 as any) === peg$FAILED) {
      s0 = peg$parseModifierType();
      if ((s0 as any) === peg$FAILED) {
        s0 = peg$parseTypeExprType();
        if ((s0 as any) === peg$FAILED) {
          s0 = peg$parseTupleType();
          if ((s0 as any) === peg$FAILED) {
            s0 = peg$parseBuiltinTypes();
            if ((s0 as any) === peg$FAILED) {
              s0 = peg$parseArrayPtrType();
            }
          }
        }
      }
    }

    peg$resultsCache[key] = { nextPos: peg$currPos, result: s0 };

    return s0;
  }

  peg$result = peg$startRuleFunction();

  if (peg$result !== peg$FAILED && peg$currPos === input.length) {
    return peg$result;
  } else {
    if (peg$result !== peg$FAILED && peg$currPos < input.length) {
      peg$fail(peg$endExpectation());
    }

    throw peg$buildStructuredError(
      peg$maxFailExpected,
      peg$maxFailPos < input.length ? input.charAt(peg$maxFailPos) : null,
      peg$maxFailPos < input.length
        ? peg$computeLocation(peg$maxFailPos, peg$maxFailPos + 1)
        : peg$computeLocation(peg$maxFailPos, peg$maxFailPos),
    );
  }
}

export interface IParseOptions {
  filename?: string;
  startRule?: string;
  tracer?: any;
  [key: string]: any;
}
export type ParseFunction = (input: string, options?: IParseOptions) => any;
export const parse: ParseFunction = peg$parse;
