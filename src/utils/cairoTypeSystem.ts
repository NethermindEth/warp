export interface CairoType {
  toString(): string;
  get width(): number;
  // An array of the member-accesses required to access all the underlying felts
  serialiseMembers(name: string): string[];
}

export class CairoFelt implements CairoType {
  toString(): string {
    return 'felt';
  }
  get width(): number {
    return 1;
  }
  serialiseMembers(name: string): string[] {
    return [name];
  }
}

export class CairoStruct implements CairoType {
  constructor(public name: string, public members: Map<string, CairoType>) {}
  toString(): string {
    return this.name;
  }
  get width(): number {
    return [...this.members.values()].reduce((acc, t) => acc + t.width, 0);
  }
  serialiseMembers(name: string): string[] {
    return [...this.members.entries()].flatMap(([memberName, type]) =>
      type.serialiseMembers(`${name}.${memberName}`),
    );
  }
}

export class CairoTuple implements CairoType {
  constructor(public members: CairoType[]) {}
  toString(): string {
    return `(${this.members.map((m) => m.toString).join(', ')})`;
  }
  get width(): number {
    return this.members.reduce((acc, t) => acc + t.width, 0);
  }
  serialiseMembers(name: string): string[] {
    return this.members.flatMap((memberType, index) =>
      memberType.serialiseMembers(`${name}[${index}]`),
    );
  }
}

export class CairoPointer implements CairoType {
  constructor(public to: CairoType) {}
  toString(): string {
    return `${this.to.toString()}*`;
  }
  get width(): number {
    return 1;
  }
  serialiseMembers(name: string): string[] {
    return [name];
  }
}

export const CairoUint256 = new CairoStruct(
  'Uint256',
  new Map([
    ['low', new CairoFelt()],
    ['high', new CairoFelt()],
  ]),
);
