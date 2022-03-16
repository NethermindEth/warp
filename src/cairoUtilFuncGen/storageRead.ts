import { Expression, TypeName, ASTNode, FunctionCall, getNodeType } from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../utils/cairoTypeSystem';
import { cloneASTNode } from '../utils/cloning';
import { createCairoFunctionStub, createCallToStub } from '../utils/functionStubbing';
import { CairoUtilFuncGenBase, CairoFunction, add } from './base';
import { serialiseReads } from './serialisation';

export class StorageReadGen extends CairoUtilFuncGenBase {
  private generatedStorageReads: Map<string, CairoFunction> = new Map();

  // Concatenate all the generated cairo code into a single string
  getGeneratedCode(): string {
    return [...this.generatedStorageReads.values()].map((func) => func.code).join('\n\n');
  }

  //----------------public solidity function call generators-------------------

  gen(storageLocation: Expression, type: TypeName, nodeInSourceUnit?: ASTNode): FunctionCall {
    const valueType = getNodeType(storageLocation, this.ast.compilerVersion);
    const resultCairoType = CairoType.fromSol(
      valueType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const name = this.getOrCreate(resultCairoType);
    const functionStub = createCairoFunctionStub(
      name,
      [['loc', cloneASTNode(type, this.ast)]],
      [['val', cloneASTNode(type, this.ast)]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      // TODO add optional source unit parameter to all other methods
      nodeInSourceUnit ?? storageLocation,
    );
    return createCallToStub(functionStub, [storageLocation], this.ast);
  }

  private getOrCreate(typeToRead: CairoType): string {
    const key = typeToRead.fullStringRepresentation;
    const existing = this.generatedStorageReads.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `WS${this.generatedStorageReads.size}_READ_${typeToRead.typeName}`;
    const resultCairoType = typeToRead.toString();
    const [reads, pack] = serialiseReads(typeToRead, readFelt, readId);
    this.generatedStorageReads.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: ${resultCairoType}):`,
        `    alloc_locals`,
        ...reads.map((s) => `    ${s}`),
        `    return (${pack})`,
        'end',
      ].join('\n'),
    });
    return funcName;
  }
}

function readFelt(offset: number): string {
  return `let (read${offset}) = WARP_STORAGE.read(${add('loc', offset)})`;
}

function readId(offset: number): string {
  return `let (read${offset}) = readId(${add('loc', offset)})`;
}
