import endent from 'endent';
import { Expression, FunctionCall, TypeNode, DataLocation, PointerType } from 'solc-typed-ast';
import {
  CairoBool,
  CairoType,
  CairoUint256,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { U128_TO_FELT } from '../../utils/importPaths';
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
      .map((name, index) => {
        if (cairoTypeToWrite instanceof CairoBool) {
          // It will store a felt corresponding to the bool value
          // True -> `1`   False -> `0`
          return endent`
            if ${name} {
              ${write(add('loc', index), `1`)}
            }
            else {
              ${write(add('loc', index), `0`)}
            }
          `;
        }
        if (cairoTypeToWrite.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
          name = `u128_to_felt(${name})`;
        }
        return `  ${write(add('loc', index), name)}`;
      })
      .join('\n');

    const funcName = `WS${this.generatedFunctionsDef.size}_WRITE_${cairoTypeToWrite.typeName}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: endent`
        fn ${funcName}(loc: felt, value: ${cairoTypeString}) -> ${cairoTypeString}{
          ${writeCode}
          return value;
        }
      `,
      functionsCalled: [this.requireImport(...U128_TO_FELT)],
    };
    return funcInfo;
  }
}

function write(offset: string, value: string): string {
  return `WARP_STORAGE::write(${offset}, ${value});`;
}
