import { CairoType } from '../../utils/cairoTypeSystem';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class DynArrayGen extends StringIndexedFuncGen {
  gen(valueCairoType: CairoType): GeneratedFunctionInfo {
    const key = valueCairoType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const mappingName = `WARP_DARRAY${this.generatedFunctions.size}_${valueCairoType.typeName}`;
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
