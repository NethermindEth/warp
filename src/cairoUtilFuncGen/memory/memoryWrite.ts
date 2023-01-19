import {
  Expression,
  FunctionCall,
  TypeNode,
  ASTNode,
  DataLocation,
  PointerType,
  FunctionDefinition,
} from 'solc-typed-ast';
import { CairoFelt, CairoType, CairoUint256 } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { add, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

/*
  Produces functions to write a given value into warp_memory, returning that value (to simulate assignments)
  This involves serialising the data into a series of felts and writing each one into the DictAccess
*/
export class MemoryWriteGen extends StringIndexedFuncGen {
  gen(memoryRef: Expression, writeValue: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const typeToWrite = safeGetNodeType(memoryRef, this.ast.inference);
    const funcDef = this.getOrCreateFuncDef(typeToWrite, memoryRef, nodeInSourceUnit);
    return createCallToFunction(funcDef, [memoryRef, writeValue], this.ast);
  }

  getOrCreateFuncDef(typeToWrite: TypeNode, node: Expression, nodeInSourceUnit?: ASTNode) {
    const cairoTypeToWrite = CairoType.fromSol(typeToWrite, this.ast);

    if (cairoTypeToWrite instanceof CairoFelt) {
      return this.requireImport('warplib.memory', 'wm_write_felt');
    } else if (
      cairoTypeToWrite.fullStringRepresentation === CairoUint256.fullStringRepresentation
    ) {
      return this.requireImport('warplib.memory', 'wm_write_256');
    }
    const funcInfo = this.getOrCreate(typeToWrite);
    const argTypeName = typeNameFromTypeNode(typeToWrite, this.ast);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['loc', argTypeName, DataLocation.Memory],
        [
          'value',
          cloneASTNode(argTypeName, this.ast),
          typeToWrite instanceof PointerType ? DataLocation.Memory : DataLocation.Default,
        ],
      ],
      [
        [
          'res',
          cloneASTNode(argTypeName, this.ast),
          typeToWrite instanceof PointerType ? DataLocation.Memory : DataLocation.Default,
        ],
      ],
      ['warp_memory'],
      this.ast,
      nodeInSourceUnit ?? node,
    );
    return funcDef;
  }

  getOrCreate(typeToWrite: TypeNode): GeneratedFunctionInfo {
    const cairoTypeToWrite = CairoType.fromSol(typeToWrite, this.ast);
    const key = cairoTypeToWrite.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(this.requireImport('starkware.cairo.common.dict', 'dict_write'));

    const cairoTypeString = cairoTypeToWrite.toString();
    const funcName = `WM_WRITE${this.generatedFunctions.size}`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}{warp_memory : DictAccess*}(loc: felt, value: ${cairoTypeString}) -> (res: ${cairoTypeString}){`,
        ...cairoTypeToWrite
          .serialiseMembers('value')
          .map((name, index) => `    ${write(index, name)};`),
        '    return (value,);',
        '}',
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    this.generatedFunctions.set(key, funcInfo);

    return funcInfo;
  }
}

function write(offset: number, value: string): string {
  return `dict_write{dict_ptr=warp_memory}(${add('loc', offset)}, ${value});`;
}
