import {
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
  TypeNode,
} from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../../ast/cairoNodes';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes/cairoGeneratedFunctionDefinition';
import {
  createCairoGeneratedFunction,
  createCallToFunction,
  safeGetNodeType,
  typeNameFromTypeNode,
} from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class DynArrayGen extends StringIndexedFuncGen {
  gen(valueType: TypeNode, node: Expression) {
    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];

    // TODO: Other gens create a func call node, but this one just return the func def node.
    // Check if this is necessary given that is inconsistent with other gen logic.
    return this.getOrCreateFuncDef(valueType);
  }

  getOrCreateFuncDef(type: TypeNode) {
    const key = `dynArray(${type.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation);
    const funcInfo = this.getOrCreate(cairoType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [],
      [],
      // [],
      this.ast,
      this.sourceUnit,
      { mutability: FunctionStateMutability.View },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  getOrCreate(valueCairoType: CairoType) {
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
