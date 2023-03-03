import assert from 'assert';
import {
  ArrayType,
  BoolType,
  BytesType,
  DataLocation,
  EnumDefinition,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
  IntType,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, FunctionStubKind } from '../../ast/cairoNodes';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { createIdentifier } from '../../utils/nodeTemplates';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import {
  delegateBasedOnType,
  GeneratedFunctionInfo,
  locationIfComplexType,
  StringIndexedFuncGen,
} from '../base';
import {
  checkableType,
  getElementType,
  isAddressType,
  isDynamicArray,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { cloneASTNode } from '../../utils/cloning';
import { isLeFeltImport, narrowSafeImport } from '../../utils/importFuncs';

const IMPLICITS = '{range_check_ptr : felt}';

export class InputCheckGen extends StringIndexedFuncGen {
  public gen(nodeInput: VariableDeclaration | Expression, typeToCheck: TypeNode): FunctionCall {
    let functionInput;
    let isUint256 = false;
    if (nodeInput instanceof VariableDeclaration) {
      functionInput = createIdentifier(nodeInput, this.ast);
    } else {
      functionInput = cloneASTNode(nodeInput, this.ast);
      const inputType = safeGetNodeType(nodeInput, this.ast.inference);
      this.ast.setContextRecursive(functionInput);
      isUint256 = inputType instanceof IntType && inputType.nBits === 256;
    }

    const funcDef = this.getOrCreateFuncDef(typeToCheck, isUint256);
    return createCallToFunction(funcDef, [functionInput], this.ast);
  }

  private getOrCreateFuncDef(type: TypeNode, takesUint256: boolean): CairoFunctionDefinition {
    const key = type.pp();
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    if (type instanceof FixedBytesType)
      return this.requireImport(
        ['warplib', 'maths', 'external_input_check_ints'],
        `warp_external_input_check_int${type.size * 8}`,
      );
    if (type instanceof IntType)
      return this.requireImport(
        ['warplib', 'maths', 'external_input_check_ints'],
        `warp_external_input_check_int${type.nBits}`,
      );
    if (isAddressType(type))
      return this.requireImport(
        ['warplib', 'maths', 'external_input_check_address'],
        `warp_external_input_check_address`,
      );
    if (type instanceof BoolType)
      return this.requireImport(
        ['warplib', 'maths', 'external_input_check_bool'],
        `warp_external_input_check_bool`,
      );

    const funcInfo = this.getOrCreate(type, takesUint256);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        [
          'ref_var',
          typeNameFromTypeNode(type, this.ast),
          locationIfComplexType(type, DataLocation.CallData),
        ],
      ],
      [],
      this.ast,
      this.sourceUnit,
      {
        mutability: FunctionStateMutability.Pure,
        stubKind: FunctionStubKind.FunctionDefStub,
        acceptsRawDArray: isDynamicArray(type),
      },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(type: TypeNode, takesUint: boolean): GeneratedFunctionInfo {
    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(`Input check for ${printTypeNode(type)} not defined yet.`);
    };

    return delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynArrayInputCheck(type),
      (type) => this.createStaticArrayInputCheck(type),
      (type, def) => this.createStructInputCheck(type, def),
      unexpectedTypeFunc,
      (type) => {
        if (type instanceof UserDefinedType && type.definition instanceof EnumDefinition)
          return this.createEnumInputCheck(type, takesUint);
        return unexpectedTypeFunc();
      },
    );
  }

  private createStructInputCheck(
    type: UserDefinedType,
    structDef: StructDefinition,
  ): GeneratedFunctionInfo {
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    const [inputCheckCode, funcCalls] = structDef.vMembers.reduce(
      ([inputCheckCode, funcCalls], decl) => {
        const memberType = safeGetNodeType(decl, this.ast.inference);
        if (checkableType(memberType)) {
          const memberCheckFunc = this.getOrCreateFuncDef(memberType, false);
          return [
            [...inputCheckCode, `${memberCheckFunc.name}(arg.${decl.name});`],
            [...funcCalls, memberCheckFunc],
          ];
        }
        return [inputCheckCode, funcCalls];
      },
      [new Array<string>(), new Array<CairoFunctionDefinition>()],
    );

    const funcName = `external_input_check_struct_${structDef.name}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(arg : ${cairoType.toString()}) -> (){`,
        `alloc_locals;`,
        ...inputCheckCode,
        `return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: funcCalls,
    };
    return funcInfo;
  }

  // Todo: This function can probably be made recursive for big size static arrays
  private createStaticArrayInputCheck(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined);
    const length = narrowBigIntSafe(type.size);

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const elementType = generalizeType(type.elementT)[0];

    const auxFunc = this.getOrCreateFuncDef(elementType, false);

    const funcName = `external_input_check_static_array${this.generatedFunctionsDef.size}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(arg : ${cairoType.toString()}) -> (){`,
        `alloc_locals;`,
        ...mapRange(length, (index) => {
          return [`${auxFunc.name}(arg[${index}]);`];
        }),
        `return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: [auxFunc],
    };
    return funcInfo;
  }

  // TODO: this function and EnumInputCheck single file do the same???
  // TODO: When does takesUint == true?
  private createEnumInputCheck(type: UserDefinedType, takesUint = false): GeneratedFunctionInfo {
    const enumDef = type.definition;
    assert(enumDef instanceof EnumDefinition);

    // TODO: enum names are unique right?
    const funcName = `external_input_check_enum_${enumDef.name}`;

    const importFuncs = [this.requireImport(...isLeFeltImport())];
    if (takesUint) {
      importFuncs.push(this.requireImport(...narrowSafeImport()));
    }

    const nMembers = enumDef.vMembers.length;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(arg : ${takesUint ? 'Uint256' : 'felt'}) -> (){`,
        takesUint
          ? [
              '    let (arg_0) = narrow_safe(arg);',
              `    let inRange: felt = is_le_felt(arg_0, ${nMembers - 1});`,
            ].join('\n')
          : `    let inRange : felt = is_le_felt(arg, ${nMembers - 1});`,
        `    with_attr error_message("Error: value out-of-bounds. Values passed to must be in enum range (0, ${
          nMembers - 1
        }]."){`,
        `        assert 1 = inRange;`,
        `    }`,
        `    return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: importFuncs,
    };
    return funcInfo;
  }

  private createDynArrayInputCheck(
    type: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(cairoType instanceof CairoDynArray);

    const ptrType = cairoType.vPtr;
    const elementType = generalizeType(getElementType(type))[0];

    const calledFunction = this.getOrCreateFuncDef(elementType, false);

    const funcName = `external_input_check_dynamic_array${this.generatedFunctionsDef.size}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(len: felt, ptr : ${ptrType.toString()}) -> (){`,
        `    alloc_locals;`,
        `    if (len == 0){`,
        `        return ();`,
        `    }`,
        `    ${calledFunction.name}(ptr[0]);`,
        `    ${funcName}(len = len - 1, ptr = ptr + ${ptrType.to.width});`,
        `    return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: [calledFunction],
    };
    return funcInfo;
  }
}
