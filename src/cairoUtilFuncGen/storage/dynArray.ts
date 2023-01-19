import {
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
} from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../../ast/cairoNodes';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes/cairoGeneratedFunctionDefinition';
import {
  createCairoGeneratedFunction,
  createCallToFunction,
  safeGetNodeType,
  typeNameFromTypeNode,
} from '../../export';
import { CairoType } from '../../utils/cairoTypeSystem';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class DynArrayGen extends StringIndexedFuncGen {
  gen(
    valueCairoType: CairoType,
    node: Expression,
    nodeInSourceUnit?: ASTNode,
  ): CairoGeneratedFunctionDefinition {
    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];

    const funcInfo = this.getOrCreate(valueCairoType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [],
      [],
      [],
      this.ast,
      nodeInSourceUnit ?? node,
      { mutability: FunctionStateMutability.View },
    );
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
