import { Imports } from '../ast/visitor';

export function divmod(x: number, y: number): [number, number] {
  return [Math.floor(x / y), x % y];
}

export function primitiveTypeToCairo(typeString: string): string {
  switch (typeString) {
    case 'uint':
    case 'uint256':
    case 'int':
    case 'int256':
      return 'Uint256';
    case 'fixed':
    case 'ufixed':
      throw new Error('Fixed types not implemented');
    default:
      return 'felt';
  }
}

function union<T>(setA: Set<T>, setB: Set<T>) {
  let _union = new Set(setA);
  for (let elem of setB) {
    _union.add(elem);
  }
  return _union;
}

export function mergeImports(importsA: Imports, importsB: Imports): Imports {
  if (!importsA) return importsB;
  if (!importsB) return importsA;

  Object.entries(importsB).forEach(([mod, imports]) => {
    const currentImports = importsA[mod];
    importsA[mod] = currentImports ? union(currentImports, imports) : imports;
  });

  return importsA;
}

export function importsWriter(imports: Imports): string {
  if (!imports) return '';
  return Object.entries(imports)
    .map(([file, vals]) => `from ${file} import ${[...vals].join(', ')}`)
    .join('\n');
}

export function* counterGenerator(start = 0): Generator<number, number, unknown> {
  let count = start;
  while (true) {
    yield count;
    count++;
  }
}

export function canonicalMangler(name: string) {
  return name.replace("_", "__").replace(".", "_");
}
