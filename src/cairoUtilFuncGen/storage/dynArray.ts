import { FunctionStateMutability, TypeNode } from 'solc-typed-ast';
import { CairoFunctionDefinition, createCairoGeneratedFunction } from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class DynArrayGen extends StringIndexedFuncGen {
  public getOrCreateFuncDef(type: TypeNode): CairoFunctionDefinition {
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation);

    const key = cairoType.fullStringRepresentation;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(cairoType);
    const funcDef = createCairoGeneratedFunction(funcInfo, [], [], this.ast, this.sourceUnit, {
      mutability: FunctionStateMutability.View,
    });
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(valueCairoType: CairoType): GeneratedFunctionInfo {
    const mappingName = `WARP_DARRAY${this.generatedFunctionsDef.size}_${valueCairoType.typeName}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: mappingName,
      code: [
        `@storage_var`,
        `func ${mappingName}(name: felt, index: Uint256) -> (resLoc : felt){`,
        `}`,
        `@storage_var`,
        `func ${mappingName}_LENGTH(name: felt) -> (index: Uint256){`,
        `}`,
      ].join('\n'),
      functionsCalled: [],
    };
    return funcInfo;
  }
}
