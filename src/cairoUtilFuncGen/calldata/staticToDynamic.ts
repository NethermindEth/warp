import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  getNodeType,
  IntType,
  PointerType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
import { getBaseType, getNestedNumber } from '../memory/implicitCoversion';
import { StorageWriteGen } from '../storage/storageWrite';

// There are 3 conditions here:
// These are only supported with ints.
// The first is that any static calldata array can become a larger storage static array uint[2] -> uint[3].
// The second is that any static calldata array can become a dynamic calldata array uint[2] -> uint[].
// The third is that any int can become a larger int in the above two cases uint8[2] -> uint256[]
export class StaticToDynArray extends StringIndexedFuncGen {
  constructor(private storageWriteGen: StorageWriteGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  genIfNecessary(
    targetExpression: Expression,
    sourceExpression: Expression,
  ): [Expression, boolean] {
    const lhsType = generalizeType(getNodeType(targetExpression, this.ast.compilerVersion))[0];
    const rhsType = generalizeType(getNodeType(sourceExpression, this.ast.compilerVersion))[0];

    if (this.checkDims(lhsType, rhsType) || this.checkSizes(lhsType, rhsType)) {
      return [this.gen(targetExpression, sourceExpression), true];
    } else {
      return [sourceExpression, false];
    }
    // Think of condition uint[2][2] -> uint[2][3] - This will not be obvious and will need to be explored using the same code as the unsupported input features.
    //   if (targetExpression instanceof ArrayType && sourceExpression instanceof ArrayType){
    //      if (targetExpression.size !== undefined && sourceExpression.size !== undefined &&
    //         )
    //      }
    //   } else {
    //     return [sourceExpression, false];
    //   }
    // }
  }
  checkSizes(lhsType: TypeNode, rhsType: TypeNode): boolean {
    const lhsBaseType = getBaseType(lhsType);
    const rhsBaseType = getBaseType(rhsType);
    assert(lhsBaseType instanceof IntType && rhsBaseType instanceof IntType);
    return lhsBaseType.nBits > rhsBaseType.nBits;
  }
  // Right now this will only check that the uint[3] -> uint[4]
  checkDims(lhsType: TypeNode, rhsType: TypeNode): boolean {
    const lhsBaseType = generalizeType(lhsType)[0];
    const rhsBaseType = generalizeType(rhsType)[0];

    if (lhsBaseType instanceof ArrayType && rhsBaseType instanceof ArrayType) {
      const lhsSize = lhsBaseType.size;
      const rhsSize = rhsBaseType.size;
      const lhsElm = generalizeType(lhsBaseType.elementT)[0];
      const rhsElm = generalizeType(rhsBaseType.elementT)[0];

      //Checking for staticArrays
      if (lhsSize !== undefined && rhsSize !== undefined) {
        if (lhsSize > rhsSize) {
          return true;
        } else if (lhsElm instanceof ArrayType && rhsElm instanceof ArrayType) {
          return this.checkDims(lhsElm, rhsElm);
        } else {
          return false;
        }
      } else if (lhsSize === undefined && rhsSize !== undefined) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  gen(lhs: Expression, rhs: Expression): FunctionCall {
    const lhsType = getNodeType(lhs, this.ast.compilerVersion);
    const rhsType = getNodeType(rhs, this.ast.compilerVersion);

    const name = this.getOrCreate(lhsType, rhsType);

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['lhs', typeNameFromTypeNode(lhsType, this.ast), DataLocation.Storage],
        ['rhs', typeNameFromTypeNode(rhsType, this.ast), DataLocation.CallData],
      ],
      [['lhs', typeNameFromTypeNode(lhsType, this.ast), DataLocation.Storage]],
      ['range_check_ptr', 'bitwise_ptr', 'warp_memory'],
      this.ast,
      rhs,
    );
    return createCallToFunction(
      functionStub,
      [cloneASTNode(lhs, this.ast), cloneASTNode(rhs, this.ast)],
      this.ast,
    );
  }

  getOrCreate(lhsType: TypeNode, rhsType: TypeNode): string {
    const targetBaseCairoType = CairoType.fromSol(
      getBaseType(rhsType),
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = `${targetBaseCairoType.fullStringRepresentation}_${getNestedNumber(
      lhsType,
    )}_${getNestedNumber(rhsType)}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const cairoFunc = this.staticArrayConversion(key, lhsType, rhsType);

    return cairoFunc.name;
  }

  private staticArrayConversion(
    key: string,
    targetType: TypeNode,
    sourceType: TypeNode,
  ): CairoFunction {
    assert(targetType instanceof PointerType && sourceType instanceof PointerType);
    assert(targetType.to instanceof ArrayType && sourceType.to instanceof ArrayType);

    assert(
      targetType.to.size !== undefined &&
        sourceType.to.size !== undefined &&
        targetType.to.size >= sourceType.to.size,
    );

    const targetElementType = targetType.to.elementT;

    const funcName = `WS_CD_TO_WS${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const sourceElementType = sourceType.to.elementT;

    const cairoTargetElementType = CairoType.fromSol(
      targetType.to.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const cairoSourceType = CairoType.fromSol(
      sourceType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );

    const cairoSourceTypeString = cairoSourceType.toString();

    const sizeSource = narrowBigIntSafe(sourceType.to.size);
    const sizeTarget = narrowBigIntSafe(targetType.to.size);

    assert(sizeSource !== undefined && sizeTarget !== undefined);
    // Make sure these are the right way round.
    let offset = 0;
    const conversionCode = mapRange(sizeSource, (index) => {
      if (targetElementType instanceof IntType) {
        assert(sourceElementType instanceof IntType);
        if (targetElementType.signed) {
          this.requireImport(
            'warplib.maths.int_conversions',
            `warp_int${sourceElementType.nBits}_to_int${targetElementType.nBits}`,
          );
          const code = `    let (target_elem${index}) = warp_int${sourceElementType.nBits}_to_int${
            targetElementType.nBits
          }(source_elem[${index}])
             ${this.storageWriteGen.getOrCreate(targetElementType)}(${add(
            'loc',
            offset,
          )}, target_elem${index})`;
          offset = offset + cairoTargetElementType.width;
          return code;
        } else {
          `    let (target_elem${index}) = felt_to_uint256(source_elem[${index}])
             ${this.storageWriteGen.getOrCreate(targetElementType)}(${add(
            'loc',
            cairoTargetElementType.width,
          )}, target_elem${index})`;
        }
      } else {
        const code = `    ${this.getOrCreate(targetElementType, sourceElementType)}(${add(
          'loc',
          offset,
        )}, source_elem[${index}])`;
        offset = offset + cairoTargetElementType.width;
        return code;
      }
    });

    // let storageOffset = 0;
    // const writerCode = mapRange(sizeSource, (index) => {
    //   storageOffset = storageOffset + cairoSourceElementType.width;
    //   return `${this.storageWriteGen.getOrCreate(
    //     targetElementType,
    //   )}(loc + ${storageOffset}, target_elem${index})`;
    // });

    // TODO check implicit order does not matter.
    const implicit =
      '{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, warp_memory : DictAccess*}';
    const code = [
      `func ${funcName}${implicit}(loc: felt, source_elem: ${cairoSourceTypeString}) -> (loc: felt):`,
      `alloc_locals`,
      ...conversionCode,
      '    return (loc)',
      'end',
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return { name: funcName, code: code };
  }
  //func funcName(ws_loc, calldata_array: (felt, felt)) -> (res: felt)
  //   ws.write(ws_loc, calldata_array[])
  //   ws.write(ws_loc, calldata_array[])
  //return (ws_loc)
  //
  //
  //
  //
}

//----------------------//
// genIfNecessary(
//   targetExpression: Expression,
//   sourceExpression: Expression,
// ): [Expression, boolean] {
//   // const targetType = getNodeType(targetExpression, this.ast.compilerVersion);
//   // const sourceType = getNodeType(sourceExpression, this.ast.compilerVersion);

//   // const targetBaseType = getBaseType(targetType);
//   // const sourceBaseType = getBaseType(sourceType);

//   // const targetCairoType = CairoType.fromSol(
//   //   targetBaseType,
//   //   this.ast,
//   //   TypeConversionContext.CallDataRef,
//   // );

//   // const sourceCairoType = CairoType.fromSol(
//   //   sourceBaseType,
//   //   this.ast,
//   //   TypeConversionContext.CallDataRef,
//   // );

//   return [this.gen(targetExpression, sourceExpression), true];
// }

// gen(lhs: Expression, rhs: Expression) {
//   const lhsType = generalizeType(getNodeType(lhs, this.ast.compilerVersion))[0];
//   const rhsType = generalizeType(getNodeType(rhs, this.ast.compilerVersion))[0];

//   assert(lhsType instanceof ArrayType && rhsType instanceof ArrayType);

//   const name = this.getOrCreate(lhsType, rhsType, lhs);

//   const functionStub = createCairoFunctionStub(
//     name,
//     [['static_array', typeNameFromTypeNode(rhsType, this.ast), DataLocation.CallData]],
//     [['dyn_array', typeNameFromTypeNode(lhsType, this.ast), DataLocation.CallData]],
//     ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
//     this.ast,
//     lhs ?? rhs,
//   );
//   // rhs will need to be cloned surely
//   return createCallToFunction(functionStub, [rhs], this.ast);
// }

// private getOrCreate(lhsType: ArrayType, rhsType: ArrayType, lhs: Expression): string {
//   const key = lhsType.pp() + 'to' + rhsType.pp();
//   const existing = this.generatedFunctions.get(key);
//   if (existing !== undefined) {
//     return existing.name;
//   }
//   // Both the arrays are still in calldata, even though the statement which triggered this function is CallData -> Storage.
//   // The CallData -> Storage is handeled in a later pass.
//   const lhsCairoType = CairoType.fromSol(lhsType, this.ast, TypeConversionContext.CallDataRef);
//   const rhsCairoType = CairoType.fromSol(rhsType, this.ast, TypeConversionContext.CallDataRef);
//   assert(lhsCairoType instanceof CairoDynArray && rhsCairoType instanceof CairoTuple);

//   // This should only support those types that can be fed into Calldata static arrays.
//   // uintx -> uint256[] will be supported later.

//   // this case is supporting vanilla uint[x] -> uintx[].
//   // but what happens when we have uint[x][x] -> uint[][].
//   // this needs to be supported, but isn't because uint[][] does not exist in calldata dynarray at the moment,
//   // but does exist in calldata staticArray.

//   const cairoElm = CairoType.fromSol(
//     generalizeType(rhsType.elementT)[0],
//     this.ast,
//     TypeConversionContext.CallDataRef,
//   );

//   const length = rhsType.size;
//   assert(length !== undefined);
//   const lengthNum = narrowBigInt(length);
//   assert(lengthNum !== null);
//   const funcName = `static_to_dynamic_array_${cairoElm}`;

//   const assertionCode = mapRange(lengthNum, (index) => {
//     return `    assert ptr[${index}] = arg[${index}]`;
//   });

//   this.dynArrayCreator.gen(lhs, lhs);
//   this.generatedFunctions.set(key, {
//     name: funcName,
//     code: [
//       `func ${funcName}(arg: ${rhsCairoType.toString()}) -> (dyn_array : ${lhsCairoType.toString()}):`,
//       `alloc_locals`,
//       // Change this to the cairo type
//       `    let (ptr : ${lhsCairoType.ptr_member.toString()}) = alloc()`,
//       ...assertionCode,
//       `    local dynarray: ${lhsCairoType.toString()} = ${lhsCairoType.toString()}(${
//         rhsType.size
//       }, ptr)`,
//       `    return (dynarray)`,
//       `end`,
//     ].join('\n'),
//   });
//   // This import problem is happening again, add it to the storage variables
//   this.requireImport('starkware.cairo.common.uint256', 'Uint256');
//   this.requireImport('starkware.cairo.common.alloc', 'alloc');
//   return funcName;
// }
