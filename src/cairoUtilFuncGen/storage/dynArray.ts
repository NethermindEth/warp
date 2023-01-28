import assert from 'assert';
import {
  ArrayType,
  BytesType,
  FunctionCall,
  FunctionStateMutability,
  MemberAccess,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import {
  CairoFunctionDefinition,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class DynArrayGen extends StringIndexedFuncGen {
  public genLength(
    node: MemberAccess,
    arrayType: ArrayType | BytesType | StringType,
  ): FunctionCall {
    const [_dynArray, dynArrayLength] = this.getOrCreateFuncDef(arrayType);
    return createCallToFunction(dynArrayLength, [node.vExpression], this.ast);
  }

  public getOrCreateFuncDef(type: TypeNode): [CairoFunctionDefinition, CairoFunctionDefinition] {
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation);

    const key = cairoType.fullStringRepresentation;
    const lenghtKey = key + '_LENGTH';
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      const exsitingLength = this.generatedFunctionsDef.get(lenghtKey);
      assert(exsitingLength !== undefined);
      return [existing, exsitingLength];
    }

    const dynArrayInfo = this.getOrCreate(cairoType);
    const [dynArray, dynArrayLength] = dynArrayInfo.map((funcInfo) =>
      createCairoGeneratedFunction(funcInfo, [], [], this.ast, this.sourceUnit, {
        // Can this option be deleted??
        mutability: FunctionStateMutability.View,
      }),
    );

    this.generatedFunctionsDef.set(key, dynArray);
    this.generatedFunctionsDef.set(lenghtKey, dynArrayLength);
    return [dynArray, dynArrayLength];
  }

  private getOrCreate(valueCairoType: CairoType): [GeneratedFunctionInfo, GeneratedFunctionInfo] {
    const mappingName = `WARP_DARRAY${this.generatedFunctionsDef.size}_${valueCairoType.typeName}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: mappingName,
      code: [
        `@storage_var`,
        `func ${mappingName}(name: felt, index: Uint256) -> (resLoc : felt){`,
        `}`,
      ].join('\n'),
      functionsCalled: [],
    };

    const lengthFuncInfo: GeneratedFunctionInfo = {
      name: `${mappingName}_LENGTH`,
      code: [
        `@storage_var`,
        `func ${mappingName}_LENGTH(name: felt) -> (index: Uint256){`,
        `}`,
      ].join('\n'),
      functionsCalled: [],
    };
    return [funcInfo, lengthFuncInfo];
  }
}
