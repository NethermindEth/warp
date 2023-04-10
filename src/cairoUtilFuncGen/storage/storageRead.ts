import assert from 'assert';
import endent from 'endent';
import {
  Expression,
  FunctionCall,
  DataLocation,
  FunctionStateMutability,
  TypeNode,
  TypeName,
} from 'solc-typed-ast';
import { typeNameFromTypeNode } from '../../export';
import {
  CairoBool,
  CairoFelt,
  CairoType,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
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
    const funcName = `WS${this.generatedFunctionsDef.size}_READ_${typeToRead.typeName}`;
    const resultCairoType = typeToRead.toString();
    let funcBody: string;
    if (typeToRead instanceof CairoBool) {
      const equivalentStoredType = new CairoFelt();
      // Given that only 1 variable was generated, then, in `pack` is stored its name
      const [reads, pack] = serialiseReads(equivalentStoredType, readFelt, readId);
      assert(reads.length === 1, 'Storage read for Cairo Bools should generate only 1 variable');
      // It's assumed here that `1` -> True and `0` -> False. With simplification purposes it´s
      // infered that if is not `1` then it must be false.
      funcBody = endent`
        ${reads.map((s) => `  ${s}`).join('\n')}
        ${pack} == 1
      `;
    } else {
      const [reads, pack] = serialiseReads(typeToRead, readFelt, readId);
      funcBody = endent`
        ${reads.map((s) => `  ${s}`).join('\n')}
        ${pack}
      `;
    }
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: endent`
        fn ${funcName}(loc: felt252) -> ${resultCairoType}{
          ${funcBody}
        }
      `,
      functionsCalled: [],
    };
    return funcInfo;
  }
}

function readFelt(offset: number): string {
  return `let read${offset} = WARP_STORAGE::read(${add('loc', offset)});`;
}

function readId(offset: number): string {
  return `let read${offset} = readId(${add('loc', offset)});`;
}
