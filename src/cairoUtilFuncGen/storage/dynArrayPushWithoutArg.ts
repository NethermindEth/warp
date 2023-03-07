import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  FunctionCall,
  generalizeType,
  MemberAccess,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { uint256AddImport, uint256Import } from '../../utils/importPaths';
import { getElementType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayPushWithoutArgGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  gen(push: FunctionCall): FunctionCall {
    assert(push.vExpression instanceof MemberAccess);
    const arrayType = generalizeType(
      safeGetNodeType(push.vExpression.vExpression, this.ast.inference),
    )[0];
    assert(
      arrayType instanceof ArrayType || arrayType instanceof BytesType,
      `Pushing without args to a non array: ${printTypeNode(arrayType)}`,
    );
    const funcDef = this.getOrCreateFuncDef(arrayType);

    return createCallToFunction(funcDef, [push.vExpression.vExpression], this.ast);
  }

  getOrCreateFuncDef(arrayType: ArrayType | BytesType) {
    const elementType = getElementType(arrayType);
    const cairoElementType = CairoType.fromSol(
      elementType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = elementType.pp(); //cairoElementType.fullStringRepresentation;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(elementType, cairoElementType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [['new_elem_loc', typeNameFromTypeNode(elementType, this.ast), DataLocation.Storage]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(elementType: TypeNode, cairoElementType: CairoType): GeneratedFunctionInfo {
    const [dynArray, dynArrayLength] = this.dynArrayGen.getOrCreateFuncDef(elementType);
    const arrayName = dynArray.name;
    const lengthName = dynArrayLength.name;
    const funcName = `${arrayName}_PUSH`;
    return {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (newElemLoc: felt){`,
        `    alloc_locals;`,
        `    let (len) = ${lengthName}.read(loc);`,
        `    let (newLen, carry) = uint256_add(len, Uint256(1,0));`,
        `    assert carry = 0;`,
        `    ${lengthName}.write(loc, newLen);`,
        `    let (existing) = ${arrayName}.read(loc, len);`,
        `    if ((existing) == 0){`,
        `        let (used) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(used + ${cairoElementType.width});`,
        `        ${arrayName}.write(loc, len, used);`,
        `        return (used,);`,
        `    }else{`,
        `        return (existing,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport(...uint256Import()),
        this.requireImport(...uint256AddImport()),
        dynArray,
        dynArrayLength,
      ],
    };
  }
}
