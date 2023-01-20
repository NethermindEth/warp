import {
  Expression,
  FunctionCall,
  TypeNode,
  ASTNode,
  DataLocation,
  PointerType,
} from 'solc-typed-ast';
import { CairoFelt, CairoType, CairoUint256 } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { add, StringIndexedFuncGen } from '../base';

/*
  Produces functions to write a given value into warp_memory, returning that value (to simulate assignments)
  This involves serialising the data into a series of felts and writing each one into the DictAccess
*/
export class MemoryWriteGen extends StringIndexedFuncGen {
  gen(memoryRef: Expression, writeValue: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const typeToWrite = safeGetNodeType(memoryRef, this.ast.inference);
    const name = this.getOrCreate(typeToWrite);
    const argTypeName = typeNameFromTypeNode(typeToWrite, this.ast);
    const functionStub = createCairoFunctionStub(
      name,
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
      nodeInSourceUnit ?? memoryRef,
    );
    return createCallToFunction(functionStub, [memoryRef, writeValue], this.ast);
  }

  getOrCreate(typeToWrite: TypeNode): string {
    const cairoTypeToWrite = CairoType.fromSol(typeToWrite, this.ast);

    if (cairoTypeToWrite instanceof CairoFelt) {
      this.requireImport('warplib.memory', 'wm_write_felt');
      return 'wm_write_felt';
    } else if (
      cairoTypeToWrite.fullStringRepresentation === CairoUint256.fullStringRepresentation
    ) {
      this.requireImport('warplib.memory', 'wm_write_256');
      return 'wm_write_256';
    }

    const key = cairoTypeToWrite.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const cairoTypeString = cairoTypeToWrite.toString();
    const funcName = `WM_WRITE${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{warp_memory : DictAccess*}(loc: felt, value: ${cairoTypeString}) -> (res: ${cairoTypeString}){`,
        ...cairoTypeToWrite
          .serialiseMembers('value')
          .map((name, index) => `    ${write(index, name)};`),
        '    return (value,);',
        '}',
      ].join('\n'),
    });

    this.requireImport('starkware.cairo.common.dict', 'dict_write');

    return funcName;
  }
}

function write(offset: number, value: string): string {
  return `dict_write{dict_ptr=warp_memory}(${add('loc', offset)}, ${value});`;
}
