import assert from 'assert';
import {
  MemberAccess,
  FunctionCall,
  PointerType,
  UserDefinedType,
  VariableDeclaration,
  DataLocation,
  StructDefinition,
} from 'solc-typed-ast';
import { CairoFunctionDefinition } from '../../ast/cairoNodes';
import { printTypeNode } from '../../export';
import { CairoType, TypeConversionContext, CairoStruct } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { add, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

export class StorageMemberAccessGen extends StringIndexedFuncGen {
  public gen(memberAccess: MemberAccess): FunctionCall {
    const solType = safeGetNodeType(memberAccess.vExpression, this.ast.inference);
    assert(
      solType instanceof PointerType &&
        solType.to instanceof UserDefinedType &&
        solType.to.definition instanceof StructDefinition,
      `Trying to generate a member access for a type different than a struct: ${printTypeNode(
        solType,
      )}`,
    );

    const referencedDeclaration = memberAccess.vReferencedDeclaration;
    assert(referencedDeclaration instanceof VariableDeclaration);

    const outType = referencedDeclaration.vType;
    assert(outType !== undefined);

    const funcDef = this.getOrCreateFuncDef(solType.to, memberAccess.memberName);
    return createCallToFunction(funcDef, [memberAccess.vExpression], this.ast);
  }

  public getOrCreateFuncDef(solType: UserDefinedType, memberName: string): CairoFunctionDefinition {
    assert(solType.definition instanceof StructDefinition);
    const structCairoType = CairoType.fromSol(
      solType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = structCairoType.fullStringRepresentation + memberName;
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.getOrCreate(structCairoType, memberName);

    const solTypeName = typeNameFromTypeNode(solType, this.ast);
    const [outTypeName] = solType.definition.vMembers
      .filter((member) => member.name === memberName)
      .map((member) => member.vType);
    assert(outTypeName !== undefined);

    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', solTypeName, DataLocation.Storage]],
      [['memberLoc', cloneASTNode(outTypeName, this.ast), DataLocation.Storage]],
      this.ast,
      this.sourceUnit,
    );

    this.generatedFunctionsDef.set(key, funcDef);

    return funcDef;
  }

  private getOrCreate(structCairoType: CairoType, memberName: string): GeneratedFunctionInfo {
    const structName = structCairoType.toString();
    assert(
      structCairoType instanceof CairoStruct,
      `Attempting to access struct member ${memberName} of non-struct type ${structName}`,
    );

    const offset = structCairoType.offsetOf(memberName);
    const funcName = `WSM_${structName}_${memberName}`;

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}(loc: felt) -> (memberLoc: felt){`,
        `    return (${add('loc', offset)},);`,
        `}`,
      ].join('\n'),
      functionsCalled: [],
    };
    return funcInfo;
  }
}
