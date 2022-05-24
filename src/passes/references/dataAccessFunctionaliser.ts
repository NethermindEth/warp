import assert from 'assert';

import {
  Assignment,
  Identifier,
  IndexAccess,
  MappingType,
  PointerType,
  VariableDeclaration,
  getNodeType,
  MemberAccess,
  DataLocation,
  FunctionCall,
  ArrayType,
  Expression,
  ArrayTypeName,
  FunctionCallKind,
  UserDefinedType,
  ContractDefinition,
  generalizeType,
} from 'solc-typed-ast';
import { NotSupportedYetError, TranspileFailedError } from '../../utils/errors';
import { printNode, printTypeNode } from '../../utils/astPrinter';

import { AST } from '../../ast/ast';
import { isCairoConstant, typeNameFromTypeNode } from '../../utils/utils';
import { error } from '../../utils/formatting';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createNumberLiteral, createUint256TypeName } from '../../utils/nodeTemplates';
import { cloneASTNode } from '../../utils/cloning';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { ReferenceSubPass } from './referenceSubPass';

/*
  Uses the analyses of ActualLocationAnalyser and ExpectedLocationAnalyser to
  replace all references to memory and storage with the appropriate functions
  acting on warp_memory and WARP_STORAGE respectively.

  For example:
  Actual - storage, expected - default, this is a read of a storage variable, and
  so the appropriate cairoUtilFuncGen is invoked to replace the expression with a
  read function

  Most cases are handled by visitExpression, with special cases handled by the more
  specific visit methods. E.g. visitAssignment creating write functions, or visitIdentifier
  having its own rules because 'x = y' changes what x points to, whereas 'x.a = y' writes to
  where x.a points to
*/
export class DataAccessFunctionaliser extends ReferenceSubPass {
  visitExpression(node: Expression, ast: AST): void {
    const [actualLoc, expectedLoc] = this.getLocations(node);
    if (expectedLoc === undefined) {
      return this.commonVisit(node, ast);
    } else if (actualLoc === DataLocation.Storage) {
      const parent = node.parent;
      switch (expectedLoc) {
        case DataLocation.Default: {
          const replacement = ast
            .getUtilFuncGen(node)
            .storage.read.gen(
              node,
              typeNameFromTypeNode(getNodeType(node, ast.compilerVersion), ast),
            );
          this.replace(node, replacement, parent, actualLoc, expectedLoc, ast);
          break;
        }
        case DataLocation.Memory: {
          const replacement = ast.getUtilFuncGen(node).storage.toMemory.gen(node);
          this.replace(node, replacement, parent, actualLoc, expectedLoc, ast);
          break;
        }
        case DataLocation.CallData:
          throw new NotSupportedYetError(
            `Storage -> calldata not implemented yet for ${printNode(node)}`,
          );
      }
    } else if (actualLoc === DataLocation.Memory) {
      switch (expectedLoc) {
        case DataLocation.Default: {
          const parent = node.parent;
          const replacement = ast
            .getUtilFuncGen(node)
            .memory.read.gen(
              node,
              typeNameFromTypeNode(getNodeType(node, ast.compilerVersion), ast),
            );
          this.replace(node, replacement, parent, actualLoc, expectedLoc, ast);
          break;
        }
        case DataLocation.Storage: {
          // Such conversions should be handled in specific visit functions, as the storage location must be known
          throw new TranspileFailedError(
            `Unhandled memory -> storage conversion ${printNode(node)}`,
          );
        }
        case DataLocation.CallData: {
          const parent = node.parent;
          const replacement = ast.getUtilFuncGen(node).memory.toCallData.gen(node);
          this.replace(node, replacement, parent, actualLoc, expectedLoc, ast);
          break;
        }
      }
    }
    this.commonVisit(node, ast);
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (shouldLeaveAsCairoAssignment(node.vLeftHandSide)) {
      return this.visitExpression(node, ast);
    }

    const [actualLoc, expectedLoc] = this.getLocations(node);
    const fromLoc = this.getLocations(node.vRightHandSide)[1];
    const toLoc = this.getLocations(node.vLeftHandSide)[1];
    if (toLoc === DataLocation.Memory) {
      const replacementFunc = ast
        .getUtilFuncGen(node)
        .memory.write.gen(node.vLeftHandSide, node.vRightHandSide);
      this.replace(node, replacementFunc, undefined, actualLoc, expectedLoc, ast);
      this.dispatchVisit(replacementFunc, ast);
    } else if (toLoc === DataLocation.Storage) {
      if (fromLoc === DataLocation.Storage) {
        // TODO verify
        const writeFunc = ast
          .getUtilFuncGen(node)
          .storage.write.gen(node.vLeftHandSide, node.vRightHandSide);
        this.replace(node, writeFunc, undefined, actualLoc, expectedLoc, ast);
        this.dispatchVisit(writeFunc, ast);
      } else if (fromLoc === DataLocation.Memory) {
        const copyFunc = ast
          .getUtilFuncGen(node)
          .memory.toStorage.gen(node.vLeftHandSide, node.vRightHandSide);
        this.replace(node, copyFunc, undefined, actualLoc, expectedLoc, ast);
        this.dispatchVisit(copyFunc, ast);
      } else if (fromLoc === DataLocation.CallData) {
        const copyFunc = ast
          .getUtilFuncGen(node)
          .calldata.toStorage.gen(node.vLeftHandSide, node.vRightHandSide);
        this.replace(node, copyFunc, undefined, actualLoc, expectedLoc, ast);
        this.dispatchVisit(copyFunc, ast);
      } else {
        const writeFunc = ast
          .getUtilFuncGen(node)
          .storage.write.gen(node.vLeftHandSide, node.vRightHandSide);
        this.replace(node, writeFunc, undefined, actualLoc, expectedLoc, ast);
        this.dispatchVisit(writeFunc, ast);
      }
    } else {
      this.visitExpression(node, ast);
    }
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    const [actualLoc, expectedLoc] = this.getLocations(node);
    // Only replace the identifier with a read function if we need to extract the data
    if (expectedLoc === undefined || expectedLoc === actualLoc) {
      this.visitExpression(node, ast);
      return;
    }

    const decl = node.vReferencedDeclaration;
    if (decl === undefined || !(decl instanceof VariableDeclaration)) {
      throw new NotSupportedYetError(
        `Non-variable ${actualLoc} identifier ${printNode(node)} not supported`,
      );
    }

    assert(
      decl.vType !== undefined,
      error('VariableDeclaration.vType should be defined for compiler versions > 0.4.x'),
    );

    if (actualLoc === DataLocation.Storage) {
      if (!isCairoConstant(decl)) {
        this.visitExpression(node, ast);
      }
    } else if (actualLoc === DataLocation.Memory) {
      this.visitExpression(node, ast);
    }
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (node.kind === FunctionCallKind.StructConstructorCall) {
      // Memory struct constructor calls should have been replaced by memoryAllocations
      return this.commonVisit(node, ast);
    } else {
      return this.visitExpression(node, ast);
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    const [actualLoc, expectedLoc] = this.getLocations(node);
    if (actualLoc !== DataLocation.Storage && actualLoc !== DataLocation.Memory) {
      return this.visitExpression(node, ast);
    }

    const type = getNodeType(node.vExpression, ast.compilerVersion);
    if (!(type instanceof PointerType)) {
      assert(
        type instanceof UserDefinedType && type.definition instanceof ContractDefinition,
        `Unexpected unhandled non-pointer non-contract member access. Found at ${printNode(node)}`,
      );
      return this.visitExpression(node, ast);
    }

    const utilFuncGen = ast.getUtilFuncGen(node);
    // To transform a struct member access to cairo, there are two steps
    // First get the location in storage of the specific struct member
    // Then use a standard storage read call to read it out
    const referencedDeclaration = node.vReferencedDeclaration;
    assert(referencedDeclaration instanceof VariableDeclaration);
    assert(referencedDeclaration.vType !== undefined);
    const replacementAccessFunc =
      actualLoc === DataLocation.Storage
        ? utilFuncGen.storage.memberAccess.gen(node)
        : utilFuncGen.memory.memberAccess.gen(node);

    this.replace(node, replacementAccessFunc, undefined, actualLoc, expectedLoc, ast);
    this.dispatchVisit(replacementAccessFunc, ast);
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    assert(node.vIndexExpression !== undefined);

    const [actualLoc, expectedLoc] = this.getLocations(node);

    const baseType = getNodeType(node.vBaseExpression, ast.compilerVersion);
    let replacement: FunctionCall | null = null;
    if (baseType instanceof PointerType) {
      if (actualLoc === DataLocation.Storage) {
        if (baseType.to instanceof ArrayType) {
          if (baseType.to.size === undefined) {
            replacement = ast.getUtilFuncGen(node).storage.dynArrayIndexAccess.gen(node);
          } else {
            replacement = ast.getUtilFuncGen(node).storage.staticArrayIndexAccess.gen(node);
          }
        } else if (baseType.to instanceof MappingType) {
          replacement = ast.getUtilFuncGen(node).storage.mappingIndexAccess.gen(node);
        } else {
          throw new TranspileFailedError(
            `Unexpected index access base type ${printTypeNode(baseType.to)} at ${printNode(node)}`,
          );
        }
      } else if (actualLoc === DataLocation.Memory) {
        if (baseType.to instanceof ArrayType) {
          if (baseType.to.size === undefined) {
            replacement = createMemoryDynArrayIndexAccess(node, ast);
          } else {
            replacement = ast
              .getUtilFuncGen(node)
              .memory.staticArrayIndexAccess.gen(node, baseType.to);
          }
        } else {
          throw new TranspileFailedError(
            `Unexpected index access base type ${printTypeNode(baseType.to)} at ${printNode(node)}`,
          );
        }
      }
    } else {
      console.log(`Non-pointer index access ${printNode(node)}`);
    }

    if (replacement !== null) {
      this.replace(node, replacement, undefined, actualLoc, expectedLoc, ast);
      this.dispatchVisit(replacement, ast);
    } else {
      this.visitExpression(node, ast);
    }
  }
}

function createMemoryDynArrayIndexAccess(indexAccess: IndexAccess, ast: AST): FunctionCall {
  const arrayType = generalizeType(
    getNodeType(indexAccess.vBaseExpression, ast.compilerVersion),
  )[0];
  const arrayTypeName = typeNameFromTypeNode(arrayType, ast);
  assert(
    arrayTypeName instanceof ArrayTypeName,
    `Created unexpected typename ${printNode(arrayTypeName)} for base of ${printNode(indexAccess)}`,
  );

  const stub = createCairoFunctionStub(
    'wm_index_dyn',
    [
      ['arrayLoc', arrayTypeName, DataLocation.Memory],
      ['index', createUint256TypeName(ast)],
      ['width', createUint256TypeName(ast)],
    ],
    [['loc', cloneASTNode(arrayTypeName.vBaseType, ast), DataLocation.Memory]],
    ['range_check_ptr', 'warp_memory'],
    ast,
    indexAccess,
  );

  assert(indexAccess.vIndexExpression);
  assert(arrayType instanceof ArrayType);
  const elementCairoTypeWidth = CairoType.fromSol(
    arrayType.elementT,
    ast,
    TypeConversionContext.MemoryAllocation,
  ).width;

  const call = createCallToFunction(
    stub,
    [
      indexAccess.vBaseExpression,
      indexAccess.vIndexExpression,
      createNumberLiteral(elementCairoTypeWidth, ast, 'uint256'),
    ],
    ast,
  );

  ast.registerImport(call, 'warplib.memory', 'wm_index_dyn');

  return call;
}

function shouldLeaveAsCairoAssignment(lhs: Expression): boolean {
  return (
    lhs instanceof Identifier &&
    !(
      lhs.vReferencedDeclaration instanceof VariableDeclaration &&
      lhs.vReferencedDeclaration.stateVariable
    )
  );
}
