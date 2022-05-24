import {
  VariableDeclaration,
  FunctionCall,
  DataLocation,
  Identifier,
  FunctionStateMutability,
  getNodeType,
  ArrayType,
  Expression,
  ASTNode,
  generalizeType,
} from 'solc-typed-ast';
import assert from 'assert';
import { createCairoFunctionStub, createCallToFunction } from '../../../utils/functionGeneration';

import { CairoType, TypeConversionContext } from '../../../utils/cairoTypeSystem';
import { StringIndexedFuncGen } from '../../base';
import { createIdentifier } from '../../../utils/nodeTemplates';
import { FunctionStubKind } from '../../../ast/cairoNodes';
import { typeNameFromTypeNode } from '../../../utils/utils';

const INDENT = ' '.repeat(4);

export class ExternalDynArrayStructConstructor extends StringIndexedFuncGen {
  gen(astNode: VariableDeclaration | Expression, node: ASTNode): FunctionCall | undefined {
    const type = generalizeType(getNodeType(astNode, this.ast.compilerVersion))[0];
    assert(type instanceof ArrayType && type.size === undefined);

    const name = this.getOrCreate(type);

    const structDefStub = createCairoFunctionStub(
      name,
      [['darray', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      [['darray_struct', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      [],
      this.ast,
      node,
      FunctionStateMutability.View,
      FunctionStubKind.StructDefStub,
    );

    if (astNode instanceof VariableDeclaration) {
      const functionInputs: Identifier[] = [
        createIdentifier(astNode, this.ast, DataLocation.CallData),
      ];
      return createCallToFunction(structDefStub, [...functionInputs], this.ast);
    } else {
      // When CallData DynArrays are being returned and we do not need the StructConstructor to be returned, we just need
      // the StructDefinition to be in the contract.
      return;
    }
  }

  private getOrCreate(type: ArrayType): string {
    const elemType = type.elementT;
    const elementCairoType = CairoType.fromSol(
      elemType,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const key = elementCairoType.toString();
    const name = `cd_dynarray_${key}`;

    const existing = this.generatedFunctions.get(name);
    if (existing !== undefined) {
      return existing.name;
    }

    this.generatedFunctions.set(key, {
      name: name,
      code: [
        `struct ${name}:`,
        `${INDENT}member len : felt `,
        `${INDENT}member ptr : ${key}*`,
        `end`,
      ].join('\n'),
    });

    return name;
  }
}
