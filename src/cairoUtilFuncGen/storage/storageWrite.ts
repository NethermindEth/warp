import {
  Expression,
  FunctionCall,
  TypeNode,
  ASTNode,
  DataLocation,
  PointerType,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { add, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class StorageWriteGen extends StringIndexedFuncGen {
  gen(
    storageLocation: Expression,
    writeValue: Expression,
    nodeInSourceUnit?: ASTNode,
  ): FunctionCall {
    const typeToWrite = safeGetNodeType(storageLocation, this.ast.inference);
    const funcInfo = this.getOrCreate(typeToWrite);
    const argTypeName = typeNameFromTypeNode(typeToWrite, this.ast);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
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
    return createCallToFunction(funcDef, [storageLocation, writeValue], this.ast);
  }

  getOrCreate(typeToWrite: TypeNode): GeneratedFunctionInfo {
    const cairoTypeToWrite = CairoType.fromSol(
      typeToWrite,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const key = cairoTypeToWrite.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const cairoTypeString = cairoTypeToWrite.toString();
    const funcName = `WS_WRITE${this.generatedFunctions.size}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: ${cairoTypeString}) -> (res: ${cairoTypeString}){`,
        ...cairoTypeToWrite
          .serialiseMembers('value')
          .map((name, index) => `    ${write(add('loc', index), name)}`),
        '    return (value,);',
        '}',
      ].join('\n'),
      functionsCalled: [],
    };
    this.generatedFunctions.set(key, funcInfo);

    return funcInfo;
  }
}

function write(offset: string, value: string): string {
  return `WARP_STORAGE.write(${offset}, ${value});`;
}
