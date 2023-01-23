import assert from 'assert';
import {
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  MemberAccess,
  SourceUnit,
  TypeName,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayPushWithoutArgGen extends StringIndexedFuncGen {
  private genNode: Expression = new Expression(0, '', '');
  private genNodeInSourceUnit?: ASTNode;
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  gen(push: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    this.genNode = push;
    this.genNodeInSourceUnit = nodeInSourceUnit;
    assert(push.vExpression instanceof MemberAccess);
    const arrayType = safeGetNodeType(push.vExpression.vExpression, this.ast.inference);
    const elementType = safeGetNodeType(push, this.ast.inference);
    const funcDef = this.getOrCreateFuncDef(arrayType, elementType);

    return createCallToFunction(funcDef, [push.vExpression.vExpression], this.ast);
  }

  getOrCreateFuncDef(arrayType: TypeNode, elementType: TypeNode) {
    const key = `dynArrayPushWithoutArg(${arrayType.pp()},${elementType.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(elementType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [['newElemLoc', typeNameFromTypeNode(elementType, this.ast), DataLocation.Storage]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(elementTypeName: TypeNode): GeneratedFunctionInfo {
    const elementType = CairoType.fromSol(
      elementTypeName,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add'),
    );

    const arrayDef = this.dynArrayGen.getOrCreateFuncDef(elementTypeName);
    funcsCalled.push(arrayDef);
    const arrayName = arrayDef.name;
    const lengthName = arrayName + '_LENGTH';
    const funcName = `${arrayName}_PUSH`;
    const funcInfo: GeneratedFunctionInfo = {
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
        `        WARP_USED_STORAGE.write(used + ${elementType.width});`,
        `        ${arrayName}.write(loc, len, used);`,
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
