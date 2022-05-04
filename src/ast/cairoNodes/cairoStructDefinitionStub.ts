import { StructDefinition, VariableDeclaration } from 'solc-typed-ast';

/*
 An extension of StructDefinition. When handeling dArrays in external functions they are
 represented as 2 seperate variables where in solidity they are represented as 1. This
 struct definition will have two fields, but only 1 node when reperesented in the AST.
 Therefor we need this struct defintion to be a stub since we want it to be in the AST,
 but when written we want it to accept two seperate variables.
*/

export class CairoStructDefinitionStub extends StructDefinition {
  isStub: boolean;
  constructor(
    id: number,
    src: string,
    name: string,
    scope: number,
    visibility: string,
    members: Iterable<VariableDeclaration>,
    isStub: boolean,
    namelocation?: string,
    raw?: any,
  ) {
    super(id, src, name, scope, visibility, members, namelocation, raw);
    this.isStub = isStub;
  }
}
