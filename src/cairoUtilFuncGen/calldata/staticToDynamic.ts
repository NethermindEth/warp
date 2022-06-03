import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  Expression,
  generalizeType,
  getNodeType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createIdentifier } from '../../utils/nodeTemplates';
import { mapRange, narrowBigInt, typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGen } from '../base';
import { ExternalDynArrayStructConstructor } from './externalDynArray/externalDynArrayStructConstructor';

export class StaticToDynArray extends StringIndexedFuncGen {
  constructor(private dynArrayCreator: ExternalDynArrayStructConstructor, ast: AST) {
    super(ast);
  }

  gen(lhs: VariableDeclaration, rhs: Expression) {
    const lhsType = getNodeType(lhs, this.ast.compilerVersion);
    const rhsType = getNodeType(rhs, this.ast.compilerVersion);

    assert(lhsType instanceof ArrayType && rhsType instanceof ArrayType);

    const name = this.getOrCreate(lhsType, rhsType, lhs);

    const functionStub = createCairoFunctionStub(
      name,
      [['static_array', typeNameFromTypeNode(lhsType, this.ast), DataLocation.CallData]],
      [['dyn_array', typeNameFromTypeNode(rhsType, this.ast), DataLocation.CallData]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      lhs ?? rhs,
    );

    return createCallToFunction(
      functionStub,
      [createIdentifier(lhs, this.ast, DataLocation.CallData)],
      this.ast,
    );
  }

  private getOrCreate(lhsType: ArrayType, rhsType: ArrayType, lhs: VariableDeclaration): string {
    const key = lhsType.pp() + 'to' + rhsType.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }
    const cairoElm = CairoType.fromSol(
      generalizeType(rhsType.elementT)[0],
      this.ast,
      TypeConversionContext.CallDataRef,
    );
    const length = rhsType.size;
    assert(length !== undefined);
    const lengthNum = narrowBigInt(length);
    assert(lengthNum !== null);
    const funcName = `static_to_dynamic_${cairoElm}`;

    const assertionCode = mapRange(lengthNum, (index) => {
      index++;
      return `    assert ptr[${index}] = static_array[${index}]`;
    });

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}(static_array: (felt, felt, felt)) -> (dyn_array : cd_dynarray_felt):`,
        `alloc_locals`,
        `    let (ptr : felt) = alloc()`,
        ...assertionCode,
        `    local dynarray: cd_dynarray_felt = ${this.dynArrayCreator.gen(lhs, lhs)}(${
          rhsType.size
        }, ptr)`,
        `    return (dynarray)`,
        `end`,
      ].join('\n'),
    });

    return funcName;
  }
}
