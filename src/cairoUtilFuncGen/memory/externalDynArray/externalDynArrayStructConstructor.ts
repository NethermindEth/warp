import {
  VariableDeclaration,
  FunctionCall,
  FunctionDefinition,
  ArrayTypeName,
  typeNameToTypeNode,
  DataLocation,
  Identifier,
  FunctionStateMutability,
} from 'solc-typed-ast';
import assert from 'assert';
import { createCairoFunctionStub, createCallToFunction } from '../../../utils/functionGeneration';

import { CairoType, TypeConversionContext } from '../../../utils/cairoTypeSystem';
import { StringIndexedFuncGen } from '../../base';
import { cloneASTNode } from '../../../utils/cloning';
import { createIdentifier } from '../../../utils/nodeTemplates';
import { FunctionStubKind } from '../../../ast/cairoNodes';

const INDENT = ' '.repeat(4);

export class ExternalDynArrayStructConstructor extends StringIndexedFuncGen {
  gen(dArrayVarDecl: VariableDeclaration, node: FunctionDefinition): FunctionCall {
    assert(dArrayVarDecl.vType !== undefined);

    const name = this.getOrCreate(dArrayVarDecl);

    const structDefStub = createCairoFunctionStub(
      name,
      [['darray', cloneASTNode(dArrayVarDecl.vType, this.ast), DataLocation.CallData]],
      [['darray_struct', cloneASTNode(dArrayVarDecl, this.ast), DataLocation.CallData]],
      [],
      this.ast,
      node,
      FunctionStateMutability.View,
      FunctionStubKind.StructDefStub,
    );

    const functionInputs: Identifier[] = [
      createIdentifier(dArrayVarDecl, this.ast, DataLocation.CallData),
    ];
    return createCallToFunction(structDefStub, [...functionInputs], this.ast);
  }

  private getOrCreate(dArrayVarDecl: VariableDeclaration): string {
    assert(dArrayVarDecl.vType instanceof ArrayTypeName);
    const elementCairoType = CairoType.fromSol(
      typeNameToTypeNode(dArrayVarDecl.vType.vBaseType),
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const key = elementCairoType.toString();
    const name = `dynarray_struct_${key}`;

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
