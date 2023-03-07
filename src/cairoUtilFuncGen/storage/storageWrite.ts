import endent from 'endent';
import { Expression, FunctionCall, TypeNode, DataLocation, PointerType } from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { add, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class StorageWriteGen extends StringIndexedFuncGen {
  public gen(storageLocation: Expression, writeValue: Expression): FunctionCall {
    const typeToWrite = safeGetNodeType(storageLocation, this.ast.inference);
    const funcDef = this.getOrCreateFuncDef(typeToWrite);
    return createCallToFunction(funcDef, [storageLocation, writeValue], this.ast);
  }

  public getOrCreateFuncDef(typeToWrite: TypeNode) {
    const key = typeToWrite.pp();
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

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
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(typeToWrite: TypeNode): GeneratedFunctionInfo {
    const cairoTypeToWrite = CairoType.fromSol(
      typeToWrite,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const cairoTypeString = cairoTypeToWrite.toString();
    const writeCode = cairoTypeToWrite
      .serialiseMembers('value')
      .map((name, index) => `  ${write(add('loc', index), name)}`)
      .join('\n');

    const funcName = `WS_WRITE${this.generatedFunctionsDef.size}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: endent`
        fn ${funcName}(loc: felt, value: ${cairoTypeString}) -> ${cairoTypeString}{
          ${writeCode}
          return value;
        }
      `,
      functionsCalled: [],
    };
    return funcInfo;
  }
}

function write(offset: string, value: string): string {
  return `WARP_STORAGE::write(${offset}, ${value});`;
}
