import {
  ArrayType,
  DataLocation,
  ExternalReferenceType,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
  getNodeType,
  MemberAccess,
  PointerType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { FunctionStubKind } from '../../ast/cairoNodes';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createNumberLiteral } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { ReferenceSubPass } from './referenceSubPass';

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
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.visitExpression(node, ast);

    // This pass is specifically looking for predefined solidity members
    if (node.vFunctionCallType !== ExternalReferenceType.Builtin) return;

    const [actualLoc, expectedLoc] = this.getLocations(node);

    if (node.vFunctionName === 'pop') {
      const replacement = ast.getUtilFuncGen(node).storage.dynArrayPop.gen(node);
      this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
    } else if (node.vFunctionName === 'push') {
      let replacement: FunctionCall;
      if (node.vArguments.length > 0) {
        if (this.getLocations(node.vArguments[0])[0] !== DataLocation.Default) {
          throw new NotSupportedYetError(`Pushing non-scalar types not supported yet`);
        }
        replacement = ast.getUtilFuncGen(node).storage.dynArrayPush.withArg.gen(node);
        this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
      } else {
        replacement = ast.getUtilFuncGen(node).storage.dynArrayPush.withoutArg.gen(node);
        this.replace(node, replacement, undefined, DataLocation.Storage, expectedLoc, ast);
      }
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitExpression(node, ast);

    if (node.memberName !== 'length') return;

    const expectedLoc = this.getLocations(node)[1];

    const baseType = getNodeType(node.vExpression, ast.compilerVersion);
    if (baseType instanceof PointerType && baseType.to instanceof ArrayType) {
      if (baseType.location === DataLocation.CallData) {
        const parent = node.parent;
        const type = generalizeType(getNodeType(node, ast.compilerVersion))[0];

        const funcStub = createCairoFunctionStub(
          'felt_to_uint256',
          [['cd_dstruct_array_len', typeNameFromTypeNode(type, ast)]],
          [['len256', typeNameFromTypeNode(type, ast)]],
          ['range_check_ptr'],
          ast,
          node,
          FunctionStateMutability.Pure,
          FunctionStubKind.FunctionDefStub,
        );

        const funcCall = createCallToFunction(funcStub, [node], ast);

        ast.registerImport(funcCall, 'warplib.maths.utils', 'felt_to_uint256');
        ast.replaceNode(node, funcCall, parent);
        node.memberName = 'len';
      } else if (
        baseType.location === DataLocation.Storage ||
        baseType.location === DataLocation.Memory
      ) {
        if (baseType.to.size !== undefined) {
          const size = baseType.to.size.toString();
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
              ? ast.getUtilFuncGen(node).storage.dynArrayLength.gen(node, baseType.to)
              : ast.getUtilFuncGen(node).memory.dynArrayLength.gen(node, ast);
          // The length function returns the actual length rather than a storage pointer to it,
          // so the new actual location is Default
          this.replace(node, replacement, undefined, DataLocation.Default, expectedLoc, ast);
        }
      }
    }
  }
}
