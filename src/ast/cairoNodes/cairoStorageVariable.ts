import { ASTNode, Expression, Identifier, TypeName } from 'solc-typed-ast';
import CairoASTNode from './cairoASTNode';

export enum CairoStorageVariableKind {
  Read = 'read',
  Write = 'write',
}

export class CairoStorageVariable extends CairoASTNode {
  //TODO: Add documentation
  typeString: string;

  vType: TypeName;

  name: Identifier;

  isEnum: boolean;

  args: Expression[];

  kind: CairoStorageVariableKind;

  constructor(
    id: number,
    src: string,
    type: string,
    typeString: string,
    vType: TypeName,
    name: Identifier,
    isEnum: boolean,
    args: Expression[],
    kind: CairoStorageVariableKind,
  ) {
    super(id, src, type);
    this.id = id;
    this.src = src;
    this.type = type;
    this.typeString = typeString;
    this.vType = vType;
    this.name = name;
    this.isEnum = isEnum;
    this.args = args;
    this.kind = kind;
  }

  get children(): readonly ASTNode[] {
    return this.pickNodes(this.name);
  }
}
