import assert = require('assert');
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
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode, countNestedMapItems } from '../../utils/utils';
import { CairoUtilFuncGenBase, CairoFunction, add } from '../base';

/*
  Produces a separate function for each struct type and member name, that when given
  the location of a struct produces the location of that member
  The actual code in the function is very simple, but is placed in a cairo function
  so that it doesn't get converted into fixed-width solidity arithmetic. A CairoExpression
  node could serve as an optimisation here
*/
export class MemoryMemberAccessGen extends CairoUtilFuncGenBase {
  // cairoType -> property name -> code
  private generatedFunctions: Map<string, Map<string, CairoFunction>> = new Map();

  // Concatenate all the generated cairo code into a single string
  getGeneratedCode(): string {
    return [...this.generatedFunctions.values()]
      .flatMap((map) => [...map.values()])
      .map((cairoMapping) => cairoMapping.code)
      .join('\n\n');
  }

  gen(memberAccess: MemberAccess, nodeInSourceUnit?: ASTNode): FunctionCall {
    const solType = safeGetNodeType(memberAccess.vExpression, this.ast.inference);
    assert(solType instanceof PointerType);
    assert(solType.to instanceof UserDefinedType);
    const structCairoType = CairoType.fromSol(
      solType,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const name = this.getOrCreate(structCairoType, memberAccess.memberName);
    const referencedDeclaration = memberAccess.vReferencedDeclaration;
    assert(referencedDeclaration instanceof VariableDeclaration);
    const outType = referencedDeclaration.vType;
    assert(outType !== undefined);
    const functionStub = createCairoFunctionStub(
      name,
      [['loc', typeNameFromTypeNode(solType, this.ast), DataLocation.Memory]],
      [['memberLoc', cloneASTNode(outType, this.ast), DataLocation.Memory]],
      [],
      this.ast,
      nodeInSourceUnit ?? memberAccess,
    );
    return createCallToFunction(functionStub, [memberAccess.vExpression], this.ast);
  }

  private getOrCreate(structCairoType: CairoType, memberName: string): string {
    const existingMemberAccesses =
      this.generatedFunctions.get(structCairoType.fullStringRepresentation) ??
      new Map<string, CairoFunction>();
    const existing = existingMemberAccesses.get(memberName);
    if (existing !== undefined) {
      return existing.name;
    }

    const structName = structCairoType.toString();
    assert(
      structCairoType instanceof CairoStruct,
      `Attempting to access struct member ${memberName} of non-struct type ${structName}`,
    );

    const offset = structCairoType.offsetOf(memberName);
    const funcName = `WM${countNestedMapItems(
      this.generatedFunctions,
    )}_${structName}_${memberName}`;

    existingMemberAccesses.set(memberName, {
      name: funcName,
      code: [
        `func ${funcName}(loc: felt) -> (memberLoc: felt){`,
        `    return (${add('loc', offset)},);`,
        `}`,
      ].join('\n'),
    });

    this.generatedFunctions.set(structCairoType.fullStringRepresentation, existingMemberAccesses);
    return funcName;
  }
}
