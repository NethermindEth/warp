import {
  Expression,
  FunctionCall,
  TypeNode,
  getNodeType,
  ASTNode,
  DataLocation,
  PointerType,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { add, StringIndexedFuncGen } from '../base';

export class StorageWriteGen extends StringIndexedFuncGen {
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
        ['loc', argTypeName, DataLocation.Storage],
        [
          'value',
          cloneASTNode(argTypeName, this.ast),
          typeToWrite instanceof PointerType ? DataLocation.Storage : DataLocation.Default,
        ],
      ],
      [
        [
          'res',
          cloneASTNode(argTypeName, this.ast),
          typeToWrite instanceof PointerType ? DataLocation.Storage : DataLocation.Default,
        ],
      ],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? storageLocation,
    );
    return createCallToFunction(functionStub, [storageLocation, writeValue], this.ast);
  }

  private getOrCreate(typeToWrite: TypeNode): string {
    const cairoTypeToWrite = CairoType.fromSol(
      typeToWrite,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const key = cairoTypeToWrite.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const cairoTypeString = cairoTypeToWrite.toString();
    const funcName = `WS_WRITE${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, {
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
