import assert from 'assert';
import {
  ArrayType,
  ASTWriter,
  DataLocation,
  FunctionCall,
  generalizeType,
  SrcDesc,
  TupleType,
  TypeNode,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, FunctionStubKind } from '../../ast/cairoNodes';
import { TranspileFailedError } from '../../utils/errors';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { isExternalCall } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation, getStaticArrayCallInfo } from '../utils';

export class VariableDeclarationStatementWriter extends CairoASTNodeWriter {
  gapVarCounter = 0;
  writeInner(node: VariableDeclarationStatement, writer: ASTWriter): SrcDesc {
    assert(
      node.vInitialValue !== undefined,
      'Variables should be initialised. Did you use VariableDeclarationInitialiser?',
    );

    const documentation = getDocumentation(node.documentation, writer);
    const initialValueType = safeGetNodeType(node.vInitialValue, this.ast.inference);

    const getValueN = (n: number): TypeNode => {
      if (initialValueType instanceof TupleType) {
        return initialValueType.elements[n];
      } else if (n === 0) return initialValueType;
      throw new TranspileFailedError(
        `Attempted to extract value at index ${n} of non-tuple return`,
      );
    };

    const getDeclarationForId = (id: number): VariableDeclaration => {
      const declaration = node.vDeclarations.find((decl) => decl.id === id);
      assert(declaration !== undefined, `Unable to find variable declaration for assignment ${id}`);
      return declaration;
    };

    let isStaticArray = false;

    const nodeType = generalizeType(getValueN(0))[0];

    const funcName = (node.vInitialValue as FunctionCall).vFunctionName;

    let staticArrayCallInfo = undefined;
    if (
      nodeType instanceof ArrayType &&
      (nodeType as ArrayType).size !== undefined &&
      funcName?.includes('static_array') &&
      !funcName?.includes('calldata') &&
      !funcName?.includes('memory') &&
      !funcName?.includes('storage')
    ) {
      isStaticArray = true;
      staticArrayCallInfo = getStaticArrayCallInfo(node, nodeType, this.ast.inference, funcName);
    }

    const declarations = node.assignments.flatMap((id, index) => {
      const type = generalizeType(getValueN(index))[0];
      if (
        isDynamicArray(type) &&
        node.vInitialValue instanceof FunctionCall &&
        isExternalCall(node.vInitialValue)
      ) {
        if (id === null) {
          const uniqueSuffix = this.gapVarCounter++;
          return [`__warp_gv_len${uniqueSuffix}`, `__warp_gv${uniqueSuffix}`];
        }
        const declaration = getDeclarationForId(id);
        assert(
          declaration.storageLocation === DataLocation.CallData,
          `WARNING: declaration receiving calldata dynarray has location ${declaration.storageLocation}`,
        );
        const writtenVar = writer.write(declaration);
        return [`${writtenVar}_len`, writtenVar];
      } else {
        if (id === null) {
          return [`__warp_gv${this.gapVarCounter++}`];
        }
        return [writer.write(getDeclarationForId(id))];
      }
    });
    if (
      node.vInitialValue instanceof FunctionCall &&
      node.vInitialValue.vReferencedDeclaration instanceof CairoFunctionDefinition &&
      node.vInitialValue.vReferencedDeclaration.functionStubKind === FunctionStubKind.StructDefStub
    ) {
      // This local statement is needed since Cairo is not supporting member access of structs with let.
      // The type hint also needs to be placed there since Cairo's default type hint is a felt.
      return [
        [
          documentation,
          `local ${declarations.join(', ')} : ${
            node.vInitialValue.vReferencedDeclaration.name
          } = ${writer.write(node.vInitialValue)};`,
        ].join('\n'),
      ];
    } else if (declarations.length > 1 || node.vInitialValue instanceof FunctionCall) {
      return [
        [
          documentation,
          isStaticArray
            ? staticArrayCallInfo!.isStringArray
              ? [
                  'let (__fp__, _) = get_fp_and_pc();',
                  staticArrayCallInfo!.stringInitCalls.join('\n'),
                ].join('\n')
              : ''
            : '',
          isStaticArray ? staticArrayCallInfo!.structInitCalls.join('\n') : '',
          `let (${declarations.join(', ')}) = ${
            isStaticArray ? staticArrayCallInfo!.staticArrayCall : writer.write(node.vInitialValue)
          };`,
        ].join('\n'),
      ];
    }
    return [
      [documentation, `let ${declarations[0]} = ${writer.write(node.vInitialValue)};`].join('\n'),
    ];
  }
}
