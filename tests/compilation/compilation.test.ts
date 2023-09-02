import { describe } from 'mocha';
import {
  cairoCompileResultTypes,
  getTestsWithUnexpectedResults,
  postTestCleanup,
  preTestChecks,
  printResults,
  ResultType,
  runCairoFileTest,
  solCompileResultTypes,
  runSolFileTest,
} from '../testing';

import path from 'path';

import { passingContracts } from './passingContracts';
import { expect } from 'chai';
import { findSolSourceFilePaths } from '../../src/io';
import Bottleneck from 'bottleneck';
import { PARALLEL_COUNT } from '../config';
import { error } from '../../src/utils/formatting';

const WARP_TEST = 'warpTest';
const WARP_COMPILATION_TEST_PATH = 'tests/compilation/contracts';
const WARP_TEST_FOLDER = path.join(WARP_TEST, WARP_COMPILATION_TEST_PATH);
const TIME_LIMIT = 2 * 60 * 60 * 1000;

const expectedResults = new Map<string, ResultType>(
  [
    ['ERC20.sol', 'Success'],
    ['ERC20Storage.sol', 'Success'],
    ['address/8/160NotAllowed.sol', 'SolCompileFailed'],
    ['address/8/256Address.sol', 'Success'],
    ['address/8/maxPrime.sol', 'SolCompileFailed'],
    ['address/8/maxPrimeExplicit.sol', 'Success'],
    ['address/8/padding.sol', 'Success'],
    ['address/8/primeField.sol', 'Success'],
    ['address/7/160NotAllowed.sol', 'SolCompileFailed'],
    ['address/7/256Address.sol', 'Success'],
    ['address/7/maxPrime.sol', 'SolCompileFailed'],
    ['address/7/maxPrimeExplicit.sol', 'Success'],
    ['address/7/padding.sol', 'Success'],
    ['address/7/primeField.sol', 'Success'],
    ['boolOpNoSideEffects.sol', 'Success'],
    ['boolOpSideEffects.sol', 'Success'],
    ['bytesXAccess.sol', 'Success'],
    ['c2c.sol', 'Success'],
    ['conditional.sol', 'Success'],
    ['conditionalSimple.sol', 'Success'],
    ['contractToContract.sol', 'Success'],
    ['calldatacopy.sol', 'WillNotSupport'],
    ['calldataCrossContractCalls.sol', 'Success'],
    ['calldataload.sol', 'WillNotSupport'],
    ['calldatasize.sol', 'WillNotSupport'],
    ['comments.sol', 'Success'],
    ['constructorsDyn.sol', 'Success'],
    ['constructorsNonDyn.sol', 'Success'],
    ['contractsAsInput.sol', 'Success'],
    ['dai.sol', 'Success'],
    ['delete.sol', 'SolCompileFailed'],
    ['deleteUses.sol', 'Success'],
    ['enums.sol', 'Success'],
    ['enums7.sol', 'Success'],
    ['errorHandling/assertHandling.sol', 'Success'],
    ['errorHandling/requireHandling.sol', 'Success'],
    ['errorHandling/revertHandling.sol', 'Success'],
    ['events.sol', 'Success'],
    ['expressionSplitter/assignSimple.sol', 'Success'],
    ['expressionSplitter/funcCallSimple.sol', 'Success'],
    ['expressionSplitter/tupleAssign.sol', 'Success'],
    ['externalFunction.sol', 'Success'],
    ['fallbackWithoutArgs.sol', 'Success'],
    ['fallbackWithArgs.sol', 'WillNotSupport'],
    ['fileWithMinusSignIncluded-.sol', 'Success'],
    ['freeFunction.sol', 'Success'],
    ['freeStruct.sol', 'Success'],
    ['functionWithNestedReturn.sol', 'Success'],
    ['functionArgumentConversions.sol', 'Success'],
    ['functionInputs/arrayTest/arrayArrayArray.sol', 'Success'],
    ['functionInputs/arrayTest/arrayArrayBytes.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayArrayStruct.sol', 'Success'],
    ['functionInputs/arrayTest/arrayDynArrayArray.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayDynArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayDynArrayStruct.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayStructArray.sol', 'Success'],
    ['functionInputs/arrayTest/arrayStructDynArray.sol', 'WillNotSupport'],
    ['functionInputs/arrayTest/arrayStructStruct.sol', 'Success'],
    ['functionInputs/dynArrayTest/dynArrayArrayArray.sol', 'Success'],
    ['functionInputs/dynArrayTest/dynArrayArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayArrayStruct.sol', 'Success'],
    ['functionInputs/dynArrayTest/dynArrayDynArrayArray.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayDynArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayDynArrayStruct.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayStructArray.sol', 'Success'],
    ['functionInputs/dynArrayTest/dynArrayStructDynArray.sol', 'WillNotSupport'],
    ['functionInputs/dynArrayTest/dynArrayStructStruct.sol', 'Success'],
    ['functionInputs/structTest/structArrayArray.sol', 'Success'],
    ['functionInputs/structTest/structArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structArrayStruct.sol', 'Success'],
    ['functionInputs/structTest/structDynArrayArray.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structDynArrayDynArray.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structDynArrayStruct.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structString.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structStructArray.sol', 'Success'],
    ['functionInputs/structTest/structStructBytes.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structStructDynArray.sol', 'WillNotSupport'],
    ['functionInputs/structTest/structStructStruct.sol', 'Success'],
    ['idManglingTest8.sol', 'Success'],
    ['idManglingTest9.sol', 'Success'],
    ['ifFlattening.sol', 'Success'],
    ['implicitsFromStub.sol', 'Success'],
    ['imports/importContract.sol', 'Success'],
    ['imports/importEnum.sol', 'Success'],
    ['imports/importfrom.sol', 'Success'],
    ['imports/importInterface.sol', 'Success'],
    ['imports/importLibrary.sol', 'Success'],
    ['imports/importStruct.sol', 'Success'],
    ['indexParam.sol', 'Success'],
    ['inheritance/simple.sol', 'Success'],
    ['inheritance/super/base.sol', 'Success'],
    ['inheritance/super/derived.sol', 'Success'],
    ['inheritance/super/mid.sol', 'Success'],
    ['inheritance/variables.sol', 'Success'],
    ['interfaces.sol', 'Success'],
    ['interfaceFromBaseContract.sol', 'Success'],
    ['internalFunctions.sol', 'Success'],
    ['invalidSolidity.sol', 'SolCompileFailed'],
    ['lib.sol', 'Success'],
    ['libraries/usingForStar.sol', 'Success'],
    ['literalOperations.sol', 'Success'],
    ['loops/forLoopWithBreak.sol', 'Success'],
    ['loops/forLoopWithContinue.sol', 'Success'],
    ['loops/forLoopWithNestedReturn.sol', 'Success'],
    ['rejectedTerms/contractName$.sol', 'WillNotSupport'],
    ['rejectedTerms/reservedContract.sol', 'WillNotSupport'],
    ['rejectedTerms/contractNameLib.sol', 'WillNotSupport'],
    ['memberAccess/balance.sol', 'WillNotSupport'],
    ['memberAccess/call.sol', 'WillNotSupport'],
    ['memberAccess/code.sol', 'WillNotSupport'],
    ['memberAccess/codehash.sol', 'WillNotSupport'],
    ['memberAccess/delegatecall.sol', 'WillNotSupport'],
    ['memberAccess/send.sol', 'WillNotSupport'],
    ['memberAccess/staticcall.sol', 'WillNotSupport'],
    ['memberAccess/transfer.sol', 'WillNotSupport'],
    ['msg.sol', 'WillNotSupport'],
    ['multipleVariables.sol', 'Success'],
    ['mutableReferences/deepDelete.sol', 'Success'],
    ['mutableReferences/memory.sol', 'Success'],
    ['mutableReferences/mutableReferences.sol', 'Success'],
    ['mutableReferences/scalarStorage.sol', 'Success'],
    ['namedArgs/constructor.sol', 'Success'],
    ['namedArgs/eventsAndErrors.sol', 'Success'],
    ['namedArgs/function.sol', 'Success'],
    ['oldCodeGenErr.sol', 'WillNotSupport'],
    ['oldCodeGenErr7.sol', 'WillNotSupport'],
    ['payableFunction.sol', 'Success'],
    ['pureFunction.sol', 'Success'],
    ['rejectNaming.sol', 'WillNotSupport'],
    ['removeUnreachableFunctions.sol', 'Success'],
    ['returnVarCapturing.sol', 'Success'],
    ['returndatasize.sol', 'WillNotSupport'],
    ['returnInserter.sol', 'Success'],
    ['sstoreSload.sol', 'WillNotSupport'],
    ['stateVariables/scalars.sol', 'Success'],
    ['stateVariables/enums.sol', 'Success'],
    ['stateVariables/arrays.sol', 'Success'],
    ['stateVariables/arraysInit.sol', 'Success'],
    ['stateVariables/mappings.sol', 'Success'],
    ['stateVariables/structs.sol', 'Success'],
    ['stateVariables/structsNested.sol', 'Success'],
    ['stateVariables/misc.sol', 'Success'],
    ['thisMethodsCall.sol', 'Success'],
    ['tryCatch.sol', 'WillNotSupport'],
    ['tupleAssignment7.sol', 'Success'],
    ['tupleAssignment8.sol', 'SolCompileFailed'],
    ['typeConversion/explicitIntConversion.sol', 'Success'],
    ['typeConversion/explicitTypeConversion.sol', 'Success'],
    ['typeConversion/implicitReturnConversion.sol', 'Success'],
    ['typeConversion/implicitTypeConv.sol', 'Success'],
    ['typeConversion/shifts.sol', 'Success'],
    ['typeConversion/toAddressConversion.sol', 'Success'],
    ['typeConversion/unusedArrayConversion.sol', 'Success'],
    ['typeMinMax.sol', 'Success'],
    ['typestrings/basicArrays.sol', 'Success'],
    ['typestrings/scalars.sol', 'Success'],
    ['typestrings/structArrays.sol', 'Success'],
    ['typestrings/structs.sol', 'Success'],
    ['units.sol', 'Success'],
    ['unsupportedFunctions/abi.sol', `Success`],
    ['unsupportedFunctions/keccak256.sol', `Success`],
    ['unsupportedFunctions/ecrecover.sol', `Success`],
    ['unsupportedFunctions/addmod.sol', `Success`],
    ['unsupportedFunctions/gasleft.sol', `WillNotSupport`],
    // Supported precompiles
    ['precompiles/ecrecover.sol', 'Success'],
    ['precompiles/keccak256.sol', 'Success'],
    // Uses bytes memory
    ['unsupportedFunctions/shadowAbi.sol', `Success`],
    // Uses bytes memory
    ['unsupportedFunctions/shadowKeccak256.sol', `Success`],
    ['unsupportedFunctions/shadowEcrecover.sol', `Success`],
    // uses modulo (%)
    ['unsupportedFunctions/shadowAddmod.sol', 'Success'],
    // Uses WARP_STORAGE in a free function
    ['usingFor/imports/userDefined.sol', 'Success'],
    // global_directive.sol cannot resolve struct when file imported as identifier
    ['usingFor/imports/globalDirective.sol', 'Success'],
    ['usingFor/complexLibraries.sol', 'Success'],
    ['usingFor/function.sol', 'WillNotSupport'],
    ['usingFor/private.sol', 'Success'],
    ['usingFor/library.sol', 'Success'],
    ['usingFor/simple.sol', 'Success'],
    ['usingReturnValues.sol', 'Success'],
    ['userDefinedFunctionCalls.sol', 'Success'],
    ['userdefinedtypes.sol', 'Success'],
    ['userdefinedidentifier.sol', 'Success'],
    ['variableDeclarations.sol', 'Success'],
    ['viewFunction.sol', 'Success'],
    ['typestrings/enumArrays.sol', 'Success'],
    //uses 'this' keyword in the constructor
    ['thisAtConstructor/externalFunctionCallAtConstruction.sol', 'WillNotSupport'],
    ['thisAtConstructor/multipleExternalFunctionCallsAtConstruction.sol', 'WillNotSupport'],
    ['thisAtConstructor/validThisUseAtConstructor.sol', 'Success'],
    ['warpMemorySystems/arrayLength.sol', 'Success'],
    ['warpMemorySystems/implicitPropagation.sol', 'Success'],
    ['warpMemorySystems/nestedStaticArrayStruct.sol', 'Success'],
    ['warpMemorySystems/nestedStructStaticArray.sol', 'Success'],
    ['warpMemorySystems/nestedStructs.sol', 'Success'],
    ['warpMemorySystems/nestedTuple.sol', 'WillNotSupport'],
    ['warpMemorySystems/returnDynArray.sol', 'Success'],
    ['warpMemorySystems/simpleStorageVar.sol', 'Success'],
    ['warpMemorySystems/structs.sol', 'Success'],
    ['warpMemorySystems/uint256StaticArrayCasting.sol', 'Success'],
  ].map(([key, result]) => {
    return [path.join(WARP_TEST_FOLDER, key), result] as [string, ResultType];
  }),
);

const contractsFolder = 'tests/compilation/contracts';
const filter = process.env.FILTER;
const preFilters = passingContracts;

describe('Running compilation tests', function () {
  this.timeout(TIME_LIMIT);

  let onlyResults: boolean, unsafe: boolean, force: boolean, exact: boolean;

  const results = new Map<string, ResultType>();

  this.beforeAll(async () => {
    onlyResults = process.argv.includes('--only-results');
    unsafe = process.argv.includes('--unsafe');
    force = process.argv.includes('--force');
    exact = process.argv.includes('--exact');
    if (force) {
      await postTestCleanup(WARP_TEST_FOLDER);
    } else {
      if (!preTestChecks(WARP_TEST_FOLDER)) return;
    }
  });

  it(`Running warp compilation tests on ${contractsFolder} solidity files`, async function () {
    const filePaths = await findSolSourceFilePaths(WARP_COMPILATION_TEST_PATH, true);
    await Promise.all(
      filePaths.map(async (file) => {
        let complexFiltering = filter === undefined && preFilters === undefined;
        // if FILTER argument is passed, then only run tests that include the filter
        // and preFilters are ignored, otherwise run tests that are in preFilters
        if (filter !== undefined) {
          complexFiltering = file.includes(filter);
        } else if (preFilters !== undefined) {
          complexFiltering = preFilters.includes(file);
        }
        if (complexFiltering) {
          let compileResult: { result: ResultType; cairoProjects?: Set<string> };
          const expectedResult: ResultType | undefined = expectedResults.get(
            path.join(WARP_TEST, file),
          );

          describe(`Running compilation test on ${file}`, async function () {
            this.timeout(TIME_LIMIT);
            it(`Running warp compile on ${file}`, async () => {
              compileResult = await runSolFileTest(WARP_TEST, file, results, onlyResults, unsafe);
              expect(expectedResult).to.not.be.undefined;
              if (expectedResult === 'Success') {
                expect(compileResult.result).to.equal('Success');
              }
              if (expectedResult !== undefined && solCompileResultTypes.includes(expectedResult)) {
                expect(compileResult.result).to.equal(expectedResult);
              }
            });
            if (expectedResult !== undefined && cairoCompileResultTypes.includes(expectedResult)) {
              it(`Running cairo compile on project ${file}`, async () => {
                if (compileResult.cairoProjects !== undefined) {
                  const bottleneck = new Bottleneck({ maxConcurrent: PARALLEL_COUNT });
                  await Promise.all(
                    Array.from(compileResult.cairoProjects).map((cairoProject) =>
                      bottleneck.schedule(async () => {
                        const cairoCompileResult = await runCairoFileTest(
                          cairoProject,
                          results,
                          onlyResults,
                        );
                        expect(cairoCompileResult).to.equal(expectedResult);
                      }),
                    ),
                  );
                }
              });
            }
          });
        }
      }),
    );
  });

  this.afterAll(async () => {
    const testsWithUnexpectedResults = getTestsWithUnexpectedResults(expectedResults, results);
    printResults(expectedResults, results, testsWithUnexpectedResults);
    await postTestCleanup(WARP_TEST_FOLDER);
    if (exact) {
      if (testsWithUnexpectedResults.length > 0) {
        throw new Error(
          error(`${testsWithUnexpectedResults.length} test(s) had unexpected outcome(s)`),
        );
      }
    }
  });
});
