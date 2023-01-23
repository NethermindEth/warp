import assert from 'assert';
import {
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  IndexAccess,
  PointerType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayIndexAccessGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  gen(node: IndexAccess): FunctionCall {
    const base = node.vBaseExpression;
    const index = node.vIndexExpression;
    assert(index !== undefined);

    const nodeType = safeGetNodeType(node, this.ast.inference);
    const baseType = safeGetNodeType(base, this.ast.inference);

    assert(baseType instanceof PointerType && isDynamicArray(baseType.to));

    const funcDef = this.getOrCreateFuncDef(nodeType);
    return createCallToFunction(funcDef, [base, index], this.ast);
  }

  getOrCreateFuncDef(nodeType: TypeNode) {
    const key = `dynArrayIndexAccess(${nodeType.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(nodeType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        // ['loc', typeNameFromTypeNode(baseType, this.ast), DataLocation.Storage],
        ['offset', createUint256TypeName(this.ast)],
      ],
      [['resLoc', typeNameFromTypeNode(nodeType, this.ast), DataLocation.Storage]],
      // ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(valueType: TypeNode): GeneratedFunctionInfo {
    const valueCairoType = CairoType.fromSol(
      valueType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_lt'),
    );

    const arrayDef = this.dynArrayGen.getOrCreateFuncDef(valueType);
    funcsCalled.push(arrayDef);
    const arrayName = arrayDef.name;
    const lengthName = arrayName + '_LENGTH';
    const funcName = `${arrayName}_IDX`;
    const funcInfo: GeneratedFunctionInfo = {
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
        `        WARP_USED_STORAGE.write(used + ${valueCairoType.width});`,
        `        ${arrayName}.write(ref, index, used);`,
        `        return (used,);`,
        `    }else{`,
        `        return (existing,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }
}
