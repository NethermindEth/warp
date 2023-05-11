import endent from 'endent';
import { Expression, FunctionCall, TypeNode, DataLocation, PointerType } from 'solc-typed-ast';
import { CairoFelt, CairoType, CairoUint } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import {
  createCairoGeneratedFunction,
  createCallToFunction,
  ParameterInfo,
} from '../../utils/functionGeneration';
import { DICT_WRITE, WM_STORE, WM_UNSAFE_WRITE, WM_WRITE } from '../../utils/importPaths';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { add, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

/*
  Produces functions to write a given value into warp_memory, returning that value (to simulate assignments)
  This involves serialising the data into a series of felts and writing each one into the DictAccess
*/
export class MemoryWriteGen extends StringIndexedFuncGen {
  public gen(memoryRef: Expression, writeValue: Expression): FunctionCall {
    const typeToWrite = safeGetNodeType(memoryRef, this.ast.inference);
    const funcDef = this.getOrCreateFuncDef(typeToWrite);
    return createCallToFunction(funcDef, [memoryRef, writeValue], this.ast);
  }

  public getOrCreateFuncDef(typeToWrite: TypeNode) {
    const key = typeToWrite.pp();
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const argTypeName = typeNameFromTypeNode(typeToWrite, this.ast);
    const inputs: ParameterInfo[] = [
      ['loc', argTypeName, DataLocation.Memory],
      [
        'value',
        cloneASTNode(argTypeName, this.ast),
        typeToWrite instanceof PointerType ? DataLocation.Memory : DataLocation.Default,
      ],
    ];
    const outputs: ParameterInfo[] = [
      [
        'res',
        cloneASTNode(argTypeName, this.ast),
        typeToWrite instanceof PointerType ? DataLocation.Memory : DataLocation.Default,
      ],
    ];

    const cairoTypeToWrite = CairoType.fromSol(typeToWrite, this.ast);
    if (cairoTypeToWrite instanceof CairoFelt) {
      return this.requireImport(...WM_WRITE, inputs, outputs);
    }

    if (cairoTypeToWrite instanceof CairoUint) {
      return this.requireImport(...WM_STORE, inputs, outputs);
    }

    const funcInfo = this.getOrCreate(typeToWrite);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      inputs,
      outputs,
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(typeToWrite: TypeNode): GeneratedFunctionInfo {
    const cairoTypeToWrite = CairoType.fromSol(typeToWrite, this.ast);
    const cairoTypeString = cairoTypeToWrite.toString();

    const writeInstructions = cairoTypeToWrite
      .serialiseMembers('value')
      .map((name, index) => `${write(index, name)};`);

    const funcName = `wm_write${this.generatedFunctionsDef.size}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: endent`
        fn ${funcName}(mem_loc: felt252, value: ${cairoTypeString}) -> ${cairoTypeString} {
          ${writeInstructions}
          value
        }
      `,
      functionsCalled: [this.requireImport(...WM_UNSAFE_WRITE)],
    };
    return funcInfo;
  }
}

function write(offset: number, value: string): string {
  return `warp_memory.unsafe_write(${add('loc', offset)}, ${value});`;
}
