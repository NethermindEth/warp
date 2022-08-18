import {
  VariableDeclaration,
  FunctionCall,
  DataLocation,
  Identifier,
  FunctionStateMutability,
  ArrayType,
  Expression,
  ASTNode,
  generalizeType,
  BytesType,
  StringType,
} from 'solc-typed-ast';
import assert from 'assert';
import { createCairoFunctionStub, createCallToFunction } from '../../../utils/functionGeneration';
import {
  CairoType,
  generateCallDataDynArrayStructName,
  TypeConversionContext,
} from '../../../utils/cairoTypeSystem';
import { StringIndexedFuncGen } from '../../base';
import { createIdentifier } from '../../../utils/nodeTemplates';
import { FunctionStubKind } from '../../../ast/cairoNodes';
import { typeNameFromTypeNode } from '../../../utils/utils';
import { printTypeNode } from '../../../utils/astPrinter';
import {
  getElementType,
  isDynamicArray,
  safeGetNodeType,
  safeGetNodeTypeInCtx,
} from '../../../utils/nodeTypeProcessing';

const INDENT = ' '.repeat(4);

export class ExternalDynArrayStructConstructor extends StringIndexedFuncGen {
  gen(astNode: VariableDeclaration, nodeInSourceUnit?: ASTNode): FunctionCall;
  gen(astNode: Expression, nodeInSourceUnit?: ASTNode): void;
  gen(
    astNode: VariableDeclaration | Expression,
    nodeInSourceUnit?: ASTNode,
  ): FunctionCall | undefined {
    const type = generalizeType(
      safeGetNodeTypeInCtx(astNode, this.ast.compilerVersion, nodeInSourceUnit ?? astNode),
    )[0];
    assert(
      isDynamicArray(type),
      `Attempted to create dynArray struct for non-dynarray type ${printTypeNode(type)}`,
    );

    const name = this.getOrCreate(type);
    const structDefStub = createCairoFunctionStub(
      name,
      [['darray', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      [['darray_struct', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      [],
      this.ast,
      nodeInSourceUnit ?? astNode,
      {
        mutability: FunctionStateMutability.View,
        stubKind: FunctionStubKind.StructDefStub,
        acceptsRawDArray: true,
      },
    );

    if (astNode instanceof VariableDeclaration) {
      const functionInputs: Identifier[] = [
        createIdentifier(astNode, this.ast, DataLocation.CallData, nodeInSourceUnit ?? astNode),
      ];
      return createCallToFunction(structDefStub, functionInputs, this.ast);
    } else {
      // When CallData DynArrays are being returned and we do not need the StructConstructor to be returned, we just need
      // the StructDefinition to be in the contract.
      return;
    }
  }

  getOrCreate(type: ArrayType | BytesType | StringType): string {
    const elemType = getElementType(type);
    const elementCairoType = CairoType.fromSol(
      elemType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );
    const key = generateCallDataDynArrayStructName(elemType, this.ast);

    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    this.generatedFunctions.set(key, {
      name: key,
      code: [
        `struct ${key}:`,
        `${INDENT}member len : felt `,
        `${INDENT}member ptr : ${elementCairoType.toString()}*`,
        `end`,
      ].join('\n'),
    });

    return key;
  }
}
