import {
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, FunctionStubKind } from './cairoFunctionDefinition';
import { Implicits, implicitTypes } from '../../utils/implicits';
import { TranspileFailedError } from '../../utils/errors';
import assert from 'assert';

export class CairoRawStringFunctionDefinition extends CairoFunctionDefinition {
  rawStringDefinition: string;
  constructor(
    id: number,
    src: string,
    scope: number,
    kind: FunctionKind,
    name: string,
    visibility: FunctionVisibility,
    stateMutability: FunctionStateMutability,
    parameters: ParameterList,
    returnParameters: ParameterList,
    rawStringDefinition: string,
  ) {
    super(
      id,
      src,
      scope,
      kind,
      name,
      false,
      visibility,
      stateMutability,
      false,
      parameters,
      returnParameters,
      [],
      new Set(parseImplicits(rawStringDefinition)),
      FunctionStubKind.None,
      false,
      false,
    );
    this.rawStringDefinition = rawStringDefinition;
  }
}
function parseImplicits(cairoCode: string): Implicits[] {
  const funcSignature = cairoCode.match(/func .+\{(.+)\}/);
  assert(funcSignature !== null);

  // implicits -> impl1 : type1, impl2, ..., impln : typen
  const implicits = funcSignature[1];

  // implicitsList -> [impl1 : type1, impl2, ...., impln : typen]
  const implicitsList = [...implicits.matchAll(/[A-Za-z][A-Za-z_: 0-9]*/g)].map((w) => w[0]);

  // implicitsNameList -> [impl1, impl2, ..., impln]
  const implicitsNameList = implicitsList.map((i) => i.match(/[A-Za-z][A-Za-z_0-9]*/));
  assert(notContainsNull(implicitsNameList));

  // Check that implicits are valid and add them to result
  return implicitsNameList.map((i) => {
    const impl = i[0];
    if (!elementIsImplicit(impl)) {
      throw new TranspileFailedError(
        `Implicit ${impl} defined on raw string function ({printNode(node)}) is not known`,
      );
    }
    return impl;
  });
}

function elementIsImplicit(e: string): e is Implicits {
  return Object.keys(implicitTypes).includes(e);
}

function notContainsNull<T>(l: (T | null)[]): l is T[] {
  return !l.some((e) => e === null);
}
