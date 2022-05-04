import {
  VariableDeclaration,
  FunctionCall,
  FunctionDefinition,
  ArrayTypeName,
  typeNameToTypeNode,
  StructDefinition,
} from 'solc-typed-ast';
import assert from 'assert';
import {
  createCairoStructConstructorStub,
  createCallToStructConstuctor,
} from '../../../utils/structGeneration';

import { CairoType, TypeConversionContext } from '../../../utils/cairoTypeSystem';
import { StringIndexedStructGen } from '../../base';

const INDENT = ' '.repeat(4);

export class ExternalDynArrayStructBuilder extends StringIndexedStructGen {
  gen(dArrayVarDecl: VariableDeclaration, node: FunctionDefinition): FunctionCall {
    assert(dArrayVarDecl.vType !== undefined);

    const structDefNode = this.getOrCreate(dArrayVarDecl);

    return createCallToStructConstuctor(structDefNode, dArrayVarDecl, this.ast, node);
  }

  private getOrCreate(dArrayVarDecl: VariableDeclaration): StructDefinition {
    assert(dArrayVarDecl.vType instanceof ArrayTypeName);
    const elementCairoType = CairoType.fromSol(
      typeNameToTypeNode(dArrayVarDecl.vType.vBaseType),
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const key = elementCairoType.toString();

    const existingNode = this.generatedStructDefNodes.get(key);
    if (existingNode !== undefined) {
      return existingNode;
    }
    const structConstructorStub = createCairoStructConstructorStub(dArrayVarDecl, this.ast);

    const name = `dynarray_struct_${key}`;

    this.generatedStructDefs.set(key, {
      name: name,
      code: [
        `struct ${name}:`,
        `${INDENT}member len : felt `,
        `${INDENT}member ptr : ${key}*`,
        `end`,
      ].join('\n'),
    });
    this.generatedStructDefNodes.set(key, structConstructorStub);
    return structConstructorStub;
  }
}
