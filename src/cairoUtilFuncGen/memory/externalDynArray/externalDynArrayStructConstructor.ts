import {
  VariableDeclaration,
  FunctionCall,
  FunctionDefinition,
  ArrayTypeName,
  typeNameToTypeNode,
} from 'solc-typed-ast';
import assert from 'assert';
import {
  createCairoStructConstructorStub,
  createCallToStructConstuctor,
} from '../../../utils/structGeneration';

import { CairoType, TypeConversionContext } from '../../../utils/cairoTypeSystem';
import { StringIndexedStructGen } from '../../base';

const INDENT = ' '.repeat(4);

export class ExternalDynArrayStructConstructor extends StringIndexedStructGen {
  gen(dArrayVarDecl: VariableDeclaration, node: FunctionDefinition): FunctionCall {
    assert(dArrayVarDecl.vType !== undefined);

    const name = this.getOrCreate(dArrayVarDecl);

    const structDefStub = createCairoStructConstructorStub(name, dArrayVarDecl, this.ast);
    return createCallToStructConstuctor(name, structDefStub, dArrayVarDecl, this.ast, node);
  }

  private getOrCreate(dArrayVarDecl: VariableDeclaration): string {
    assert(dArrayVarDecl.vType instanceof ArrayTypeName);
    const elementCairoType = CairoType.fromSol(
      typeNameToTypeNode(dArrayVarDecl.vType.vBaseType),
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    const key = elementCairoType.toString();

    const existing = this.generatedStructDefs.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

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

    return name;
  }
}
