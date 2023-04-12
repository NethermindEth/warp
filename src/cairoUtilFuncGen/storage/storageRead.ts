import endent from 'endent';
import {
  Expression,
  FunctionCall,
  DataLocation,
  FunctionStateMutability,
  TypeNode,
  TypeName,
  FunctionDefinition,
} from 'solc-typed-ast';
import { typeNameFromTypeNode } from '../../export';
import { CairoBool, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { FELT252_INTO_BOOL } from '../../utils/importPaths';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { add, GeneratedFunctionInfo, locationIfComplexType, StringIndexedFuncGen } from '../base';
import { serialiseReads } from '../serialisation';

export class StorageReadGen extends StringIndexedFuncGen {
  // TODO: is typename safe to remove?
  public gen(storageLocation: Expression, typeName?: TypeName): FunctionCall {
    const valueType = safeGetNodeType(storageLocation, this.ast.inference);

    const funcDef = this.getOrCreateFuncDef(valueType, typeName);

    return createCallToFunction(funcDef, [storageLocation], this.ast);
  }

  public getOrCreateFuncDef(valueType: TypeNode, typeName?: TypeName) {
    typeName = typeName ?? typeNameFromTypeNode(valueType, this.ast);
    const resultCairoType = CairoType.fromSol(
      valueType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = resultCairoType.fullStringRepresentation + typeName.typeString;
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.getOrCreate(resultCairoType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', cloneASTNode(typeName, this.ast), DataLocation.Storage]],
      [
        [
          'val',
          cloneASTNode(typeName, this.ast),
          locationIfComplexType(valueType, DataLocation.Storage),
        ],
      ],
      this.ast,
      this.sourceUnit,
      { mutability: FunctionStateMutability.View },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(typeToRead: CairoType): GeneratedFunctionInfo {
    const functionsCalled: FunctionDefinition[] = [];
    const funcName = `WS${this.generatedFunctionsDef.size}_READ_${typeToRead.typeName}`;
    const resultCairoType = typeToRead.toString();

    if (typeToRead instanceof CairoBool) {
      functionsCalled.push(this.requireImport(...FELT252_INTO_BOOL));
    }

    const [reads, pack] = serialiseReads(typeToRead, readFelt, readId, readBool);
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: endent`
        fn ${funcName}(loc: felt252) -> ${resultCairoType}{
          ${reads.map((s) => `  ${s}`).join('\n')}
          ${pack}
        }
      `,
      functionsCalled: functionsCalled,
    };
    return funcInfo;
  }
}

function readBool(offset: number): string {
  return endent`
    let read${offset}_int = WARP_STORAGE::read(${add('loc', offset)});
    let read${offset} = Felt252IntoBool::into(read${offset}_int);
  `;
}

function readFelt(offset: number): string {
  return `let read${offset} = WARP_STORAGE::read(${add('loc', offset)});`;
}

function readId(offset: number): string {
  return `let read${offset} = readId(${add('loc', offset)});`;
}
