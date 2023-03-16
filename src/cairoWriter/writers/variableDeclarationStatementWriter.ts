import assert from 'assert';
import {
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
import { TranspileFailedError } from '../../utils/errors';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { isExternalCall } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

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
    if (declarations.length > 1) {
      return [
        [
          documentation,
          `let (${declarations.join(', ')}) = ${writer.write(node.vInitialValue)};`,
        ].join('\n'),
      ];
    }
    return [
      [documentation, `let ${declarations[0]} = ${writer.write(node.vInitialValue)};`].join('\n'),
    ];
  }
}
