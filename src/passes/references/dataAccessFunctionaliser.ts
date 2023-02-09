import assert from 'assert';

import {
  Assignment,
  Identifier,
  IndexAccess,
  MappingType,
  PointerType,
  VariableDeclaration,
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
  FixedBytesType,
  BytesType,
  StringType,
  TypeNameType,
} from 'solc-typed-ast';
import { TranspileFailedError, WillNotSupportError } from '../../utils/errors';
import { printNode, printTypeNode } from '../../utils/astPrinter';

import { AST } from '../../ast/ast';
import { isCairoConstant, typeNameFromTypeNode } from '../../utils/utils';
import { error } from '../../utils/formatting';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import {
  createNumberLiteral,
  createUint256TypeName,
  createUint8TypeName,
} from '../../utils/nodeTemplates';
import { cloneASTNode } from '../../utils/cloning';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { ReferenceSubPass } from './referenceSubPass';
import { StorageToStorageGen } from '../../cairoUtilFuncGen/storage/copyToStorage';
import { MemoryWriteGen } from '../../cairoUtilFuncGen/memory/memoryWrite';
import { CalldataToStorageGen } from '../../cairoUtilFuncGen/calldata/calldataToStorage';
import { StorageWriteGen } from '../../cairoUtilFuncGen/storage/storageWrite';
import { MemoryToStorageGen } from '../../cairoUtilFuncGen/memory/memoryToStorage';
import { getElementType, safeGetNodeType } from '../../utils/nodeTypeProcessing';

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
    // First, collect data before any processing
    const originalNode = node;
    const [actualLoc, expectedLoc] = this.getLocations(node);
    if (expectedLoc === undefined) {
      return this.commonVisit(node, ast);
    }

    const nodeType = safeGetNodeType(node, ast.inference);
    const utilFuncGen = ast.getUtilFuncGen(node);
    const parent = node.parent;

    // Finally if a copy from actual to expected location is required, insert this last
    let copyFunc: Expression | null = null;
    if (actualLoc !== expectedLoc) {
      if (actualLoc === DataLocation.Storage) {
        switch (expectedLoc) {
          case DataLocation.Default: {
            copyFunc = utilFuncGen.storage.read.gen(node, typeNameFromTypeNode(nodeType, ast));
            break;
          }
          case DataLocation.Memory: {
            copyFunc = utilFuncGen.storage.toMemory.gen(node);
            break;
          }
          case DataLocation.CallData: {
            copyFunc = ast.getUtilFuncGen(node).storage.toCallData.gen(node);
            break;
          }
        }
      } else if (actualLoc === DataLocation.Memory) {
        switch (expectedLoc) {
          case DataLocation.Default: {
            copyFunc = utilFuncGen.memory.read.gen(node, typeNameFromTypeNode(nodeType, ast));
            break;
          }
          case DataLocation.Storage: {
            // Such conversions should be handled in specific visit functions, as the storage location must be known
            throw new TranspileFailedError(
              `Unhandled memory -> storage conversion ${printNode(node)}`,
            );
          }
          case DataLocation.CallData: {
            copyFunc = utilFuncGen.memory.toCallData.gen(node);
            break;
          }
        }
      } else if (actualLoc === DataLocation.CallData) {
        switch (expectedLoc) {
          case DataLocation.Default:
            // Nothing to do here
            break;
          case DataLocation.Memory:
            copyFunc = ast.getUtilFuncGen(node).calldata.toMemory.gen(node);
            break;
          case DataLocation.Storage:
            // Such conversions should be handled in specific visit functions, as the storage location must be known
            throw new TranspileFailedError(
              `Unhandled calldata -> storage conversion ${printNode(node)}`,
            );
        }
      }
    }

    // Update the expected location of the node to be equal to its
    // actual location, now that any discrepency has been handled

    if (copyFunc) {
      this.replace(node, copyFunc, parent, expectedLoc, expectedLoc, ast);
    }

    if (actualLoc === undefined) {
      this.expectedDataLocations.delete(node);
    } else {
      this.expectedDataLocations.set(node, actualLoc);
    }

    // Now that node has been inserted into the appropriate functions, read its children
    this.commonVisit(originalNode, ast);
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (shouldLeaveAsCairoAssignment(node.vLeftHandSide)) {
      return this.visitExpression(node, ast);
    }

    const [actualLoc, expectedLoc] = this.getLocations(node);
    const fromLoc = this.getLocations(node.vRightHandSide)[1];
    const toLoc = this.getLocations(node.vLeftHandSide)[1];
    let funcGen:
      | MemoryWriteGen
      | StorageToStorageGen
      | MemoryToStorageGen
      | CalldataToStorageGen
      | StorageWriteGen
      | null = null;
    if (toLoc === DataLocation.Memory) {
      funcGen = ast.getUtilFuncGen(node).memory.write;
    } else if (toLoc === DataLocation.Storage) {
      if (fromLoc === DataLocation.Storage) {
        funcGen = ast.getUtilFuncGen(node).storage.toStorage;
      } else if (fromLoc === DataLocation.Memory) {
        const [convert, result] = ast
          .getUtilFuncGen(node)
          .memory.convert.genIfNecesary(
            node.vLeftHandSide,
            safeGetNodeType(node.vRightHandSide, ast.inference),
          );
        if (result) {
          ast.replaceNode(node.vRightHandSide, convert, node);
        }
        funcGen = ast.getUtilFuncGen(node).memory.toStorage;
      } else if (fromLoc === DataLocation.CallData) {
        const [convertExpression, result] = ast
          .getUtilFuncGen(node)
          .calldata.convert.genIfNecessary(node.vLeftHandSide, node.vRightHandSide);
        if (result) {
          const parent = node.parent;
          assert(parent !== undefined);
          ast.replaceNode(node, convertExpression, parent);
        } else {
          funcGen = ast.getUtilFuncGen(node).calldata.toStorage;
        }
      } else {
        funcGen = ast.getUtilFuncGen(node).storage.write;
      }
    }

    if (funcGen) {
      const replacementFunc = funcGen.gen(node.vLeftHandSide, node.vRightHandSide);
      this.replace(node, replacementFunc, undefined, actualLoc, expectedLoc, ast);
      return this.dispatchVisit(replacementFunc, ast);
    }

    this.visitExpression(node, ast);
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
      throw new WillNotSupportError(
        `Writing to Non-variable ${actualLoc} identifier ${printNode(node)} not supported`,
      );
    }

    assert(
      decl.vType !== undefined,
      error('VariableDeclaration.vType should be defined for compiler versions > 0.4.x'),
    );

    if (actualLoc === DataLocation.Storage && isCairoConstant(decl)) {
      return;
    }

    this.visitExpression(node, ast);
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

    const type = safeGetNodeType(node.vExpression, ast.inference);
    if (!(type instanceof PointerType)) {
      assert(
        (type instanceof UserDefinedType && type.definition instanceof ContractDefinition) ||
          type instanceof FixedBytesType,
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
    const nodeType = safeGetNodeType(node, ast.inference);
    if (nodeType instanceof TypeNameType) return this.commonVisit(node, ast);
    assert(node.vIndexExpression !== undefined);

    const [actualLoc, expectedLoc] = this.getLocations(node);

    const baseType = safeGetNodeType(node.vBaseExpression, ast.inference);
    let replacement: FunctionCall | null = null;
    if (baseType instanceof PointerType) {
      if (actualLoc === DataLocation.Storage) {
        if (baseType.to instanceof ArrayType) {
          if (baseType.to.size === undefined) {
            replacement = ast.getUtilFuncGen(node).storage.dynArrayIndexAccess.gen(node);
          } else {
            replacement = ast.getUtilFuncGen(node).storage.staticArrayIndexAccess.gen(node);
          }
        } else if (baseType.to instanceof BytesType || baseType.to instanceof StringType) {
          replacement = ast.getUtilFuncGen(node).storage.dynArrayIndexAccess.gen(node);
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
        } else if (baseType.to instanceof BytesType || baseType.to instanceof StringType) {
          replacement = createMemoryDynArrayIndexAccess(node, ast);
        } else {
          throw new TranspileFailedError(
            `Unexpected index access base type ${printTypeNode(baseType.to)} at ${printNode(node)}`,
          );
        }
      }
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
  const arrayType = generalizeType(safeGetNodeType(indexAccess.vBaseExpression, ast.inference))[0];
  const arrayTypeName = typeNameFromTypeNode(arrayType, ast);
  const returnTypeName =
    arrayTypeName instanceof ArrayTypeName
      ? cloneASTNode(arrayTypeName.vBaseType, ast)
      : createUint8TypeName(ast);

  const stub = createCairoFunctionStub(
    'wm_index_dyn',
    [
      ['arrayLoc', arrayTypeName, DataLocation.Memory],
      ['index', createUint256TypeName(ast)],
      ['width', createUint256TypeName(ast)],
    ],
    [['loc', returnTypeName, DataLocation.Memory]],
    ['range_check_ptr', 'warp_memory'],
    ast,
    indexAccess,
  );

  assert(indexAccess.vIndexExpression);
  assert(
    arrayType instanceof ArrayType ||
      arrayType instanceof BytesType ||
      arrayType instanceof StringType,
  );
  const elementCairoTypeWidth = CairoType.fromSol(
    getElementType(arrayType),
    ast,
    TypeConversionContext.Ref,
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
