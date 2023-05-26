import {
  Expression,
  TypeName,
  FunctionCall,
  DataLocation,
  generalizeType,
  TypeNode,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, typeNameFromTypeNode } from '../../export';
import {
  CairoFelt,
  CairoType,
  MemoryLocation,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCallToFunction } from '../../utils/functionGeneration';
import { WM_READ, WM_GET_ID, WM_RETRIEVE } from '../../utils/importPaths';
import {
  createFeltLiteral,
  createFeltTypeName,
  createNumberLiteral,
  createNumberTypeName,
} from '../../utils/nodeTemplates';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { locationIfComplexType, StringIndexedFuncGen } from '../base';

/*
  Produces functions that when given a start location in warp_memory, deserialise all necessary
  felts to produce a full value. For example, a function to read a Uint256 reads the given location
  and the next one, and combines them into a Uint256 struct
*/
export class MemoryReadGen extends StringIndexedFuncGen {
  gen(memoryRef: Expression): FunctionCall {
    const valueType = generalizeType(safeGetNodeType(memoryRef, this.ast.inference))[0];
    const resultCairoType = CairoType.fromSol(valueType, this.ast);

    const args = [memoryRef];

    if (!(resultCairoType instanceof CairoFelt)) {
      // The size parameter represents how much space to allocate
      // for the contents of the newly accessed subobject
      args.push(
        createFeltLiteral(
          isDynamicArray(valueType)
            ? 1
            : CairoType.fromSol(valueType, this.ast, TypeConversionContext.MemoryAllocation).width,
          this.ast,
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

    const input: [string, TypeName, DataLocation] = [
      'loc',
      cloneASTNode(typeToReadName, this.ast),
      DataLocation.Memory,
    ];
    const output: [string, TypeName, DataLocation] = [
      'val',
      cloneASTNode(typeToReadName, this.ast),
      locationIfComplexType(typeToRead, DataLocation.Memory),
    ];

    let funcDef: CairoFunctionDefinition;
    if (resultCairoType instanceof MemoryLocation) {
      funcDef = this.requireImport(
        ...WM_GET_ID,
        [input, ['size', createFeltTypeName(this.ast), DataLocation.Default]],
        [output],
      );
    } else if (resultCairoType instanceof CairoFelt) {
      funcDef = this.requireImport(...WM_READ, [input], [output]);
    } else {
      funcDef = this.requireImport(
        ...WM_RETRIEVE,
        [input, ['size', createFeltTypeName(this.ast), DataLocation.Default]],
        [output],
      );
    }
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }
}
