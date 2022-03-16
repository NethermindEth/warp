import { Expression, FunctionCall, TypeNode, getNodeType, ASTNode } from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../utils/cairoTypeSystem';
import { cloneASTNode } from '../utils/cloning';
import { createCairoFunctionStub, createCallToStub } from '../utils/functionStubbing';
import { typeNameFromTypeNode } from '../utils/utils';
import { add, CairoFunction, CairoUtilFuncGenBase } from './base';

export class StorageWriteGen extends CairoUtilFuncGenBase {
  private generatedStorageWrites: Map<string, CairoFunction> = new Map();

  // Concatenate all the generated cairo code into a single string
  getGeneratedCode(): string {
    return [...this.generatedStorageWrites.values()].map((func) => func.code).join('\n\n');
  }

  gen(
    storageLocation: Expression,
    writeValue: Expression,
    nodeInSourceUnit?: ASTNode,
  ): FunctionCall {
    const typeToWrite = getNodeType(storageLocation, this.ast.compilerVersion);
    const name = this.getOrCreate(typeToWrite);
    const argTypeName = typeNameFromTypeNode(typeToWrite, this.ast);
    const functionStub = createCairoFunctionStub(
      name,
      [
        ['loc', argTypeName],
        ['value', cloneASTNode(argTypeName, this.ast)],
      ],
      [['res', cloneASTNode(argTypeName, this.ast)]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? storageLocation,
    );
    return createCallToStub(functionStub, [storageLocation, writeValue], this.ast);
  }

  private getOrCreate(typeToWrite: TypeNode): string {
    const cairoTypeToWrite = CairoType.fromSol(
      typeToWrite,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const key = cairoTypeToWrite.fullStringRepresentation;
    const existing = this.generatedStorageWrites.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const cairoTypeString = cairoTypeToWrite.toString();
    const funcName = `WS_WRITE${this.generatedStorageWrites.size}`;
    this.generatedStorageWrites.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: ${cairoTypeString}) -> (res: ${cairoTypeString}):`,
        ...cairoTypeToWrite
          .serialiseMembers('value')
          .map((name, index) => `    ${write(add('loc', index), name)}`),
        '    return (value)',
        'end',
      ].join('\n'),
    });
    return funcName;
  }
}

function write(offset: string, value: string): string {
  return `WARP_STORAGE.write(${offset}, ${value})`;
}
