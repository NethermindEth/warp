import { StructDefinition, VariableDeclaration } from 'solc-typed-ast';

/*
 An extension of StructDefinition. This is used for handelling dynArrays in external functions. 
 The length and pointer are stored in this sub-class. Only dynArrays repersented as structs should 
 use this definition, since there are coniditionals in the CairoWriter that make sure that a single 
 dynArray Identifier is written as 2 seperate Identifiers  when passed to StructConstructor that
 references this subclass of StructDefintion. This class has to be used instead of a CairoFunctionDefintion 
 since the value returned from a FunctionCall.kind === FunctionCall will have the value unpacked 
 with brackets, but unpacking a struct returned from a StructConstructor is not a valid Cairo Statement 
 and the program will not compile.
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
    raw?: unknown,
  ) {
    super(id, src, name, scope, visibility, members, namelocation, raw);
    this.isStub = isStub;
  }
}
