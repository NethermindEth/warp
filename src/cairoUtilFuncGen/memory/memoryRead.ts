import endent from 'endent';
import {
  Expression,
  TypeName,
  FunctionCall,
  DataLocation,
  FunctionStateMutability,
  generalizeType,
  TypeNode,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, typeNameFromTypeNode } from '../../export';
import {
  CairoFelt,
  CairoType,
  CairoUint,
  MemoryLocation,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { WM_READ, WM_GET_ID, WM_RETRIEVE } from '../../utils/importPaths';
import { createNumberLiteral, createNumberTypeName } from '../../utils/nodeTemplates';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { GeneratedFunctionInfo, locationIfComplexType, StringIndexedFuncGen } from '../base';

/*
  Produces functions that when given a start location in warp_memory, deserialise all necessary
  felts to produce a full value. For example, a function to read a Uint256 reads the given location
  and the next one, and combines them into a Uint256 struct
*/
// TODO: Replace the whole class with a call to warp_memory.retrieve?
export class MemoryReadGen extends StringIndexedFuncGen {
  gen(memoryRef: Expression): FunctionCall {
    const valueType = generalizeType(safeGetNodeType(memoryRef, this.ast.inference))[0];
    const resultCairoType = CairoType.fromSol(valueType, this.ast);

    const args = [memoryRef];

    if (resultCairoType instanceof MemoryLocation) {
      // The size parameter represents how much space to allocate
      // for the contents of the newly accessed subobject
      args.push(
        createNumberLiteral(
          isDynamicArray(valueType)
            ? 2
            : CairoType.fromSol(valueType, this.ast, TypeConversionContext.MemoryAllocation).width,
          this.ast,
          'uint256',
        ),
      );
    }
    const funcDef = this.getOrCreateFuncDef(valueType);
    return createCallToFunction(funcDef, args, this.ast);
  }

  getOrCreateFuncDef(typeToRead: TypeNode) {
    const key = typeToRead.pp();
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const typeToReadName = typeNameFromTypeNode(typeToRead, this.ast);
    const resultCairoType = CairoType.fromSol(typeToRead, this.ast);

    const inputs: [string, TypeName, DataLocation][] =
      resultCairoType instanceof MemoryLocation
        ? [
            ['loc', cloneASTNode(typeToReadName, this.ast), DataLocation.Memory],
            ['size', createNumberTypeName(256, false, this.ast), DataLocation.Default],
          ]
        : [['loc', cloneASTNode(typeToReadName, this.ast), DataLocation.Memory]];
    const outputs: [string, TypeName, DataLocation][] = [
      [
        'val',
        cloneASTNode(typeToReadName, this.ast),
        locationIfComplexType(typeToRead, DataLocation.Memory),
      ],
    ];

    let funcDef: CairoFunctionDefinition;
    if (resultCairoType instanceof MemoryLocation) {
      funcDef = this.requireImport(...WM_GET_ID, inputs, outputs);
    } else if (resultCairoType instanceof CairoFelt) {
      funcDef = this.requireImport(...WM_READ, inputs, outputs);
    } else if (resultCairoType instanceof CairoUint) {
      funcDef = this.requireImport(...WM_RETRIEVE, inputs, outputs);
    } else {
      const funcInfo = this.getOrCreate(resultCairoType);
      funcDef = createCairoGeneratedFunction(funcInfo, inputs, outputs, this.ast, this.sourceUnit, {
        mutability: FunctionStateMutability.View,
      });
    }
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(typeToRead: CairoType): GeneratedFunctionInfo {
    const funcName = `WM${this.generatedFunctionsDef.size}_READ_${typeToRead.typeName}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: endent`
      #[implicits(warp_memory: WarpMemory)]
      fn ${funcName}(loc: felt) -> ${typeToRead.toString()}{
        warp_memory.retrieve(loc, loc + ${typeToRead.width})
      }`,
      functionsCalled: [this.requireImport(...WM_RETRIEVE)],
    };
    return funcInfo;
  }
}
