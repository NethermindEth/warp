import assert from 'assert';
import {
  DataLocation,
  FunctionCall,
  IndexAccess,
  PointerType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { UINT256, UINT256_LT } from '../../utils/importPaths';
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayIndexAccessGen extends StringIndexedFuncGen {
  public constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  public gen(node: IndexAccess): FunctionCall {
    const base = node.vBaseExpression;
    const index = node.vIndexExpression;
    assert(index !== undefined);

    const nodeType = safeGetNodeType(node, this.ast.inference);
    const baseType = safeGetNodeType(base, this.ast.inference);

    assert(baseType instanceof PointerType && isDynamicArray(baseType.to));

    const funcDef = this.getOrCreateFuncDef(nodeType, baseType);
    return createCallToFunction(funcDef, [base, index], this.ast);
  }

  public getOrCreateFuncDef(nodeType: TypeNode, baseType: TypeNode) {
    const nodeCairoType = CairoType.fromSol(
      nodeType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = nodeCairoType.fullStringRepresentation;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(nodeType, nodeCairoType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['loc', typeNameFromTypeNode(baseType, this.ast), DataLocation.Storage],
        ['offset', createUint256TypeName(this.ast)],
      ],
      [['res_loc', typeNameFromTypeNode(nodeType, this.ast), DataLocation.Storage]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(valueType: TypeNode, valueCairoType: CairoType): GeneratedFunctionInfo {
    const [arrayDef, arrayLength] = this.dynArrayGen.getOrCreateFuncDef(valueType);
    const arrayName = arrayDef.name;
    const lengthName = arrayLength.name;
    const funcName = `${arrayName}_IDX`;
    return {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(ref: felt, index: Uint256) -> (res: felt){`,
        `    alloc_locals;`,
        `    let (length) = ${lengthName}.read(ref);`,
        `    let (inRange) = uint256_lt(index, length);`,
        `    assert inRange = 1;`,
        `    let (existing) = ${arrayName}.read(ref, index);`,
        `    if (existing == 0){`,
        `        let (used) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE::write(used + ${valueCairoType.width});`,
        `        ${arrayName}.write(ref, index, used);`,
        `        return (used,);`,
        `    }else{`,
        `        return (existing,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport(...UINT256),
        this.requireImport(...UINT256_LT),
        arrayDef,
        arrayLength,
      ],
    };
  }
}
