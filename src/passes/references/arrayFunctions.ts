import {
  ArrayType,
  BytesType,
  DataLocation,
  ExternalReferenceType,
  FixedBytesType,
  FunctionCall,
  generalizeType,
  MemberAccess,
  PointerType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { createCallToFunction } from '../../utils/functionGeneration';
import {
  getSize,
  isDynamicArray,
  isDynamicCallDataArray,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { createNumberLiteral } from '../../utils/nodeTemplates';
import { expressionHasSideEffects, typeNameFromTypeNode } from '../../utils/utils';
import { ReferenceSubPass } from './referenceSubPass';
import { FELT_TO_UINT256 } from '../../utils/importPaths';

/*
  Replaces array members (push, pop, length) with standalone functions that implement
  the same purpose in our models of storage and memory.
  Functions like push and pop are special cases due to not having a referenced
  FunctionDefinition and being member functions of non-contract objects, so
  it's easiest to handle them separately before dataAccessFunctionaliser
  Additionally length needs to be separated as it's handled differently to most member
  accesses (length is handled as a function that directly returns the length, whereas
  most member access become a read/write function and an offset function)
*/
export class ArrayFunctions extends ReferenceSubPass {
  counter = 0;

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.visitExpression(node, ast);

    // This pass is specifically looking for predefined solidity members
    if (node.vFunctionCallType !== ExternalReferenceType.Builtin) return;

    const [actualLoc, expectedLoc] = this.getLocations(node);
    const utilGen = ast.getUtilFuncGen(node);

    if (node.vFunctionName === 'pop') {
      const replacement = utilGen.storage.dynArrayPop.gen(node);
      this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
    } else if (node.vFunctionName === 'push') {
      let replacement: FunctionCall;
      if (node.vArguments.length > 0) {
        replacement = utilGen.storage.dynArrayPush.withArg.gen(node);
        this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
        const actualArgLoc = this.getLocations(node.vArguments[0])[0];
        if (actualArgLoc) {
          this.expectedDataLocations.set(node.vArguments[0], actualArgLoc);
        }
      } else {
        const type = safeGetNodeType(node, ast.inference);
        replacement = utilGen.storage.dynArrayPush.withoutArg.gen(node);
        this.replace(node, replacement, node.parent, DataLocation.Storage, expectedLoc, ast);
        if (isDynamicArray(type)) {
          const readReplacement = utilGen.storage.read.gen(
            replacement,
            typeNameFromTypeNode(type, ast),
          );
          this.replace(
            replacement,
            readReplacement,
            node.parent,
            DataLocation.Storage,
            expectedLoc,
            ast,
          );
        }
      }
    } else if (node.vFunctionName === 'concat') {
      const replacement = utilGen.memory.concat.gen(node);
      this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitExpression(node, ast);

    if (node.memberName !== 'length') return;

    const expectedLoc = this.getLocations(node)[1];

    const baseType = safeGetNodeType(node.vExpression, ast.inference);
    if (baseType instanceof FixedBytesType) {
      const literal = createNumberLiteral(baseType.size, ast, 'uint8');
      if (expressionHasSideEffects(node.vExpression)) {
        ast.extractToConstant(
          node.vExpression,
          typeNameFromTypeNode(baseType, ast),
          `__warp_tb${this.counter++}`,
        );
      }
      this.replace(node, literal, node.parent, DataLocation.Default, expectedLoc, ast);
    } else if (
      baseType instanceof PointerType &&
      (baseType.to instanceof ArrayType || baseType.to instanceof BytesType)
    ) {
      if (isDynamicCallDataArray(baseType)) {
        const parent = node.parent;
        const type = generalizeType(safeGetNodeType(node, ast.inference))[0];

        const importedFunc = ast.registerImport(
          node,
          ...FELT_TO_UINT256,
          [['cd_dstruct_array_len', typeNameFromTypeNode(type, ast)]],
          [['len256', typeNameFromTypeNode(type, ast)]],
        );

        const funcCall = createCallToFunction(importedFunc, [node], ast);

        this.replace(
          node,
          funcCall,
          parent,
          DataLocation.Default,
          this.expectedDataLocations.get(node),
          ast,
        );

        this.expectedDataLocations.set(node, DataLocation.Default);
        node.memberName = 'len';
        return;
      }
      const size = getSize(baseType.to);
      if (size !== undefined) {
        this.replace(
          node,
          createNumberLiteral(size, ast, 'uint256'),
          undefined,
          DataLocation.Default,
          DataLocation.Default,
          ast,
        );
      } else {
        const replacement =
          baseType.location === DataLocation.Storage
            ? ast.getUtilFuncGen(node).storage.dynArray.genLength(node, baseType.to)
            : ast.getUtilFuncGen(node).memory.dynArrayLength.gen(node, ast);
        // The length function returns the actual length rather than a storage pointer to it,
        // so the new actual location is Default
        this.replace(node, replacement, undefined, DataLocation.Default, expectedLoc, ast);
      }
    }
  }
}
