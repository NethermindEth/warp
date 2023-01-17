import assert from 'assert';
import {
  MemberAccess,
  ASTNode,
  FunctionCall,
  PointerType,
  UserDefinedType,
  VariableDeclaration,
  DataLocation,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext, CairoStruct } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode, countNestedMapItems } from '../../utils/utils';
import { CairoUtilFuncGenBase, CairoFunction, add, GeneratedFunctionInfo } from '../base';

export class StorageMemberAccessGen extends CairoUtilFuncGenBase {
  // cairoType -> property name -> code
  private generatedFunctions: Map<string, Map<string, GeneratedFunctionInfo>> = new Map();

  getGeneratedCode(): string {
    return [...this.generatedFunctions.values()]
      .flatMap((map) => [...map.values()])
      .map((cairoMapping) => cairoMapping.code)
      .join('\n\n');
  }

  gen(memberAccess: MemberAccess, nodeInSourceUnit?: ASTNode): FunctionCall {
    const solType = safeGetNodeType(memberAccess.vExpression, this.ast.compilerVersion);
    assert(solType instanceof PointerType);
    assert(solType.to instanceof UserDefinedType);
    const structCairoType = CairoType.fromSol(
      solType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const funcInfo = this.getOrCreate(structCairoType, memberAccess.memberName);
    const referencedDeclaration = memberAccess.vReferencedDeclaration;
    assert(referencedDeclaration instanceof VariableDeclaration);
    const outType = referencedDeclaration.vType;
    assert(outType !== undefined);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', typeNameFromTypeNode(solType, this.ast), DataLocation.Storage]],
      [['memberLoc', cloneASTNode(outType, this.ast), DataLocation.Storage]],
      [],
      this.ast,
      nodeInSourceUnit ?? memberAccess,
    );
    return createCallToFunction(funcDef, [memberAccess.vExpression], this.ast);
  }

  private getOrCreate(structCairoType: CairoType, memberName: string): GeneratedFunctionInfo {
    const existingMemberAccesses =
      this.generatedFunctions.get(structCairoType.fullStringRepresentation) ??
      new Map<string, GeneratedFunctionInfo>();
    const existing = existingMemberAccesses.get(memberName);
    if (existing !== undefined) {
      return existing;
    }

    const structName = structCairoType.toString();
    assert(
      structCairoType instanceof CairoStruct,
      `Attempting to access struct member ${memberName} of non-struct type ${structName}`,
    );

    const offset = structCairoType.offsetOf(memberName);
    const funcName = `WSM${countNestedMapItems(
      this.generatedFunctions,
    )}_${structName}_${memberName}`;

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}(loc: felt) -> (memberLoc: felt){`,
        `    return (${add('loc', offset)},);`,
        `}`,
      ].join('\n'),
      functionsCalled: [],
    };
    existingMemberAccesses.set(memberName, funcInfo);
    this.generatedFunctions.set(structCairoType.fullStringRepresentation, existingMemberAccesses);
    return funcInfo;
  }
}
