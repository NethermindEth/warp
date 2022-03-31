import { CairoType } from '../../utils/cairoTypeSystem';
import { StringIndexedFuncGen } from '../base';

export class DynArrayGen extends StringIndexedFuncGen {
  gen(valueCairoType: CairoType): [data: string, len: string] {
    const key = valueCairoType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return [existing.name, `${existing.name}_LENGTH`];
    }

    const mappingName = `WARP_DARRAY${this.generatedFunctions.size}_${valueCairoType.typeName}`;
    this.generatedFunctions.set(key, {
      name: mappingName,
      code: [
        `@storage_var`,
        `func ${mappingName}(name: felt, index: Uint256) -> (resLoc : felt):`,
        `end`,
        `@storage_var`,
        `func ${mappingName}_LENGTH(name: felt) -> (index: Uint256):`,
        `end`,
      ].join('\n'),
    });
    return [mappingName, `${mappingName}_LENGTH`];
  }
}
