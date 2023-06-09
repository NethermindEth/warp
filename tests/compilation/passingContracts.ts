export const passingContracts = [
  // FIXME: uncomment, when storage is ready for Cairo 1
  // 'tests/compilation/contracts/ERC20.sol',
  // 'tests/compilation/contracts/ERC20Storage.sol',
  'tests/compilation/contracts/address/7/160NotAllowed.sol',
  // 'tests/compilation/contracts/address/7/256Address.sol',
  'tests/compilation/contracts/address/7/maxPrime.sol',
  'tests/compilation/contracts/address/7/maxPrimeExplicit.sol',
  'tests/compilation/contracts/address/7/padding.sol',
  'tests/compilation/contracts/address/7/primeField.sol',
  'tests/compilation/contracts/address/8/160NotAllowed.sol',
  // 'tests/compilation/contracts/address/8/256Address.sol',
  'tests/compilation/contracts/address/8/maxPrime.sol',
  'tests/compilation/contracts/address/8/maxPrimeExplicit.sol',
  'tests/compilation/contracts/address/8/padding.sol',
  'tests/compilation/contracts/address/8/primeField.sol',
  // 'tests/compilation/contracts/warpMemorySystems/arrayLength.sol',
  // 'tests/compilation/contracts/boolOpNoSideEffects.sol',
  // 'tests/compilation/contracts/boolOpSideEffects.sol',
  // 'tests/compilation/contracts/bytesXAccess.sol',
  // 'tests/compilation/contracts/c2c.sol',
  // 'tests/compilation/contracts/calldataCrossContractCalls.sol',
  // 'tests/compilation/contracts/calldatacopy.sol',
  // 'tests/compilation/contracts/calldataload.sol',
  // 'tests/compilation/contracts/calldatasize.sol',
  'tests/compilation/contracts/comments.sol',
  // 'tests/compilation/contracts/conditional.sol',
  // 'tests/compilation/contracts/conditionalSimple.sol',
  // 'tests/compilation/contracts/constructorsDyn.sol',
  // 'tests/compilation/contracts/constructorsNonDyn.sol',
  // 'tests/compilation/contracts/contractToContract.sol',
  // 'tests/compilation/contracts/contractsAsInput.sol',
  // 'tests/compilation/contracts/dai.sol',
  // 'tests/compilation/contracts/delete.sol',
  // 'tests/compilation/contracts/deleteUses.sol',
  'tests/compilation/contracts/enums.sol',
  // 'tests/compilation/contracts/enums7.sol',
  // 'tests/compilation/contracts/errorHandling/assert.sol',
  // 'tests/compilation/contracts/errorHandling/require.sol',
  // 'tests/compilation/contracts/errorHandling/revert.sol',
  // 'tests/compilation/contracts/events.sol',
  // 'tests/compilation/contracts/expressionSplitter/assignSimple.sol',
  // 'tests/compilation/contracts/expressionSplitter/funcCallSimple.sol',
  // 'tests/compilation/contracts/expressionSplitter/tupleAssign.sol',
  'tests/compilation/contracts/externalFunction.sol',
  // 'tests/compilation/contracts/fallbackWithArgs.sol',
  // 'tests/compilation/contracts/fallbackWithoutArgs.sol',
  'tests/compilation/contracts/fileWithMinusSignIncluded-.sol',
  'tests/compilation/contracts/freeFunction.sol',
  // 'tests/compilation/contracts/freeStruct.sol',
  // 'tests/compilation/contracts/functionArgumentConversions.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayArrayArray.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayArrayBytes.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayArrayDynArray.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayArrayStruct.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayDynArrayArray.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayDynArrayDynArray.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayDynArrayStruct.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayStructArray.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayStructDynArray.sol',
  // 'tests/compilation/contracts/functionInputs/arrayTest/arrayStructStruct.sol',
  // 'tests/compilation/contracts/functionInputs/dynArrayTest/dynArrayArrayArray.sol',
  // 'tests/compilation/contracts/functionInputs/dynArrayTest/dynArrayArrayDynArray.sol',
  // 'tests/compilation/contracts/functionInputs/dynArrayTest/dynArrayArrayStruct.sol',
  // 'tests/compilation/contracts/functionInputs/dynArrayTest/dynArrayDynArrayArray.sol',
  // 'tests/compilation/contracts/functionInputs/dynArrayTest/dynArrayDynArrayDynArray.sol',
  // 'tests/compilation/contracts/functionInputs/dynArrayTest/dynArrayDynArrayStruct.sol',
  // 'tests/compilation/contracts/functionInputs/dynArrayTest/dynArrayStructArray.sol',
  // 'tests/compilation/contracts/functionInputs/dynArrayTest/dynArrayStructDynArray.sol',
  // 'tests/compilation/contracts/functionInputs/dynArrayTest/dynArrayStructStruct.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structArrayArray.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structArrayDynArray.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structArrayStruct.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structDynArrayArray.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structDynArrayDynArray.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structDynArrayStruct.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structString.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structStructArray.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structStructBytes.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structStructDynArray.sol',
  // 'tests/compilation/contracts/functionInputs/structTest/structStructStruct.sol',
  // 'tests/compilation/contracts/functionWithNestedReturn.sol',
  // 'tests/compilation/contracts/idManglingTest8.sol',
  'tests/compilation/contracts/idManglingTest9.sol',
  // 'tests/compilation/contracts/ifFlattening.sol',
  // 'tests/compilation/contracts/implicitsFromStub.sol',
  // 'tests/compilation/contracts/imports/importContract.sol',
  // 'tests/compilation/contracts/imports/importEnum.sol',
  // 'tests/compilation/contracts/imports/importInterface.sol',
  // 'tests/compilation/contracts/imports/importLibrary.sol',
  // 'tests/compilation/contracts/imports/importStruct.sol',
  // 'tests/compilation/contracts/imports/importfrom.sol',
  // 'tests/compilation/contracts/indexParam.sol',
  'tests/compilation/contracts/inheritance/simple.sol',
  'tests/compilation/contracts/inheritance/super/base.sol',
  // 'tests/compilation/contracts/inheritance/super/derived.sol',
  'tests/compilation/contracts/inheritance/super/mid.sol',
  'tests/compilation/contracts/inheritance/variables.sol',
  // 'tests/compilation/contracts/interfaceFromBaseContract.sol',
  // 'tests/compilation/contracts/interfaces.sol',
  // 'tests/compilation/contracts/internalFunctions.sol',
  // 'tests/compilation/contracts/invalidSolidity.sol',
  'tests/compilation/contracts/lib.sol',
  // 'tests/compilation/contracts/libraries/usingForStar.sol',
  // 'tests/compilation/contracts/literalOperations.sol',
  // 'tests/compilation/contracts/loops/forLoopWithBreak.sol',
  // 'tests/compilation/contracts/loops/forLoopWithContinue.sol',
  // 'tests/compilation/contracts/loops/forLoopWithNestedReturn.sol',
  // 'tests/compilation/contracts/memberAccess/balance.sol',
  // 'tests/compilation/contracts/memberAccess/call.sol',
  // 'tests/compilation/contracts/memberAccess/code.sol',
  // 'tests/compilation/contracts/memberAccess/codehash.sol',
  // 'tests/compilation/contracts/memberAccess/delegatecall.sol',
  // 'tests/compilation/contracts/memberAccess/send.sol',
  // 'tests/compilation/contracts/memberAccess/staticcall.sol',
  // 'tests/compilation/contracts/memberAccess/transfer.sol',
  // 'tests/compilation/contracts/msg.sol',
  'tests/compilation/contracts/multipleVariables.sol',
  // 'tests/compilation/contracts/mutableReferences/deepDelete.sol',
  // 'tests/compilation/contracts/mutableReferences/memory.sol',
  // 'tests/compilation/contracts/mutableReferences/mutableReferences.sol',
  // 'tests/compilation/contracts/mutableReferences/scalarStorage.sol',
  // 'tests/compilation/contracts/namedArgs/constructor.sol',
  // 'tests/compilation/contracts/namedArgs/eventsAndErrors.sol',
  // FIXME: uncomment, when storage is ready for Cairo 1
  // 'tests/compilation/contracts/namedArgs/function.sol',
  // 'tests/compilation/contracts/nestedStaticArrayStruct.sol',
  // 'tests/compilation/contracts/nestedStructStaticArray.sol',
  'tests/compilation/contracts/nestedStructs.sol',
  // 'tests/compilation/contracts/nestedTuple.sol',
  // 'tests/compilation/contracts/oldCodeGenErr.sol',
  // 'tests/compilation/contracts/oldCodeGenErr7.sol',
  // 'tests/compilation/contracts/payableFunction.sol',
  // 'tests/compilation/contracts/precompiles/ecrecover.sol',
  // 'tests/compilation/contracts/precompiles/keccak256.sol',
  // 'tests/compilation/contracts/pureFunction.sol',
  // 'tests/compilation/contracts/rejectNaming.sol',
  // 'tests/compilation/contracts/rejectedTerms/contractName$.sol',
  // 'tests/compilation/contracts/rejectedTerms/contractNameLib.sol',
  // 'tests/compilation/contracts/rejectedTerms/reservedContract.sol',
  // 'tests/compilation/contracts/removeUnreachableFunctions.sol',
  // 'tests/compilation/contracts/warpMemorySystems/returnDynArray.sol',
  // 'tests/compilation/contracts/returnInserter.sol',
  // 'tests/compilation/contracts/returnVarCapturing.sol',
  // 'tests/compilation/contracts/returndatasize.sol',
  'tests/compilation/contracts/warpMemorySystems/simpleStorageVar.sol',
  // 'tests/compilation/contracts/sstoreSload.sol',
  // 'tests/compilation/contracts/stateVariables/arrays.sol',
  // 'tests/compilation/contracts/stateVariables/arraysInit.sol',
  'tests/compilation/contracts/stateVariables/enums.sol',
  // 'tests/compilation/contracts/stateVariables/mappings.sol',
  // 'tests/compilation/contracts/stateVariables/misc.sol',
  // 'tests/compilation/contracts/stateVariables/scalars.sol',
  // 'tests/compilation/contracts/stateVariables/warpMemorySystems/structs.sol',
  // 'tests/compilation/contracts/stateVariables/structsNested.sol',
  'tests/compilation/contracts/structs.sol',
  // 'tests/compilation/contracts/thisAtConstructor/externalFunctionCallAtConstruction.sol',
  // 'tests/compilation/contracts/thisAtConstructor/multipleExternalFunctionCallsAtConstruction.sol',
  // 'tests/compilation/contracts/thisAtConstructor/validThisUseAtConstructor.sol',
  // 'tests/compilation/contracts/thisMethodsCall.sol',
  // 'tests/compilation/contracts/tryCatch.sol',
  // 'tests/compilation/contracts/tupleAssignment7.sol',
  // 'tests/compilation/contracts/tupleAssignment8.sol',
  'tests/compilation/contracts/typeConversion/explicitIntConversion.sol',
  'tests/compilation/contracts/typeConversion/explicitTypeConversion.sol',
  // 'tests/compilation/contracts/typeConversion/implicitReturnConversion.sol',
  // 'tests/compilation/contracts/typeConversion/implicitTypeConv.sol',
  // 'tests/compilation/contracts/typeConversion/shifts.sol',
  'tests/compilation/contracts/typeConversion/toAddressConversion.sol',
  // 'tests/compilation/contracts/typeConversion/unusedArrayConversion.sol',
  // 'tests/compilation/contracts/typeMinMax.sol',
  // 'tests/compilation/contracts/typestrings/basicArrays.sol',
  // 'tests/compilation/contracts/typestrings/enumArrays.sol',
  // 'tests/compilation/contracts/typestrings/scalars.sol',
  // 'tests/compilation/contracts/typestrings/structArrays.sol',
  // 'tests/compilation/contracts/typestrings/structs.sol',
  // 'tests/compilation/contracts/warpMemorySystems/uint256StaticArrayCasting.sol',
  // 'tests/compilation/contracts/units.sol',
  // 'tests/compilation/contracts/unsupportedFunctions/abi.sol',
  // 'tests/compilation/contracts/unsupportedFunctions/addmod.sol',
  // 'tests/compilation/contracts/unsupportedFunctions/ecrecover.sol',
  // 'tests/compilation/contracts/unsupportedFunctions/gasleft.sol',
  // 'tests/compilation/contracts/unsupportedFunctions/keccak256.sol',
  // 'tests/compilation/contracts/unsupportedFunctions/shadowAbi.sol',
  // 'tests/compilation/contracts/unsupportedFunctions/shadowAddmod.sol',
  // 'tests/compilation/contracts/unsupportedFunctions/shadowEcrecover.sol',
  // 'tests/compilation/contracts/unsupportedFunctions/shadowKeccak256.sol',
  'tests/compilation/contracts/userDefinedFunctionCalls.sol',
  'tests/compilation/contracts/userdefinedidentifier.sol',
  // 'tests/compilation/contracts/userdefinedtypes.sol',
  // 'tests/compilation/contracts/usingFor/complexLibraries.sol',
  // 'tests/compilation/contracts/usingFor/function.sol',
  // 'tests/compilation/contracts/usingFor/imports/globalDirective.sol',
  // 'tests/compilation/contracts/usingFor/imports/userDefined.sol',
  // 'tests/compilation/contracts/usingFor/library.sol',
  'tests/compilation/contracts/usingFor/private.sol',
  'tests/compilation/contracts/usingFor/simple.sol',
  // 'tests/compilation/contracts/usingReturnValues.sol',
  // 'tests/compilation/contracts/variableDeclarations.sol',
  // 'tests/compilation/contracts/viewFunction.sol',
  'tests/compilation/contracts/warpMemorySystems/implicitPropagation.sol',
];
