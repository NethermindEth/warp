import endent from 'endent';
import {
  Expression,
  FunctionCall,
  DataLocation,
  FunctionStateMutability,
  TypeNode,
  TypeName,
  FunctionDefinition,
} from 'solc-typed-ast';
import { typeNameFromTypeNode } from '../../export';
import {
  CairoContractAddress,
  CairoType,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { add, GeneratedFunctionInfo, locationIfComplexType, StringIndexedFuncGen } from '../base';
import { serialiseReads } from '../serialisation';
import { createImport } from '../../utils/importFuncGenerator';
import {
  CONTRACT_ADDRESS,
  CONTRACT_ADDRESS_FROM_FELT,
  OPTION_TRAIT,
} from '../../utils/importPaths';

export class StorageReadGen extends StringIndexedFuncGen {
  // TODO: is typename safe to remove?
  public gen(storageLocation: Expression, typeName?: TypeName): FunctionCall {
    const valueType = safeGetNodeType(storageLocation, this.ast.inference);

    const funcDef = this.getOrCreateFuncDef(valueType, typeName);

    return createCallToFunction(funcDef, [storageLocation], this.ast);
  }

  public getOrCreateFuncDef(valueType: TypeNode, typeName?: TypeName) {
    typeName = typeName ?? typeNameFromTypeNode(valueType, this.ast);
    const resultCairoType = CairoType.fromSol(
      valueType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = resultCairoType.fullStringRepresentation + typeName.typeString;
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.getOrCreate(resultCairoType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', cloneASTNode(typeName, this.ast), DataLocation.Storage]],
      [
        [
          'val',
          cloneASTNode(typeName, this.ast),
          locationIfComplexType(valueType, DataLocation.Storage),
        ],
      ],
      this.ast,
      this.sourceUnit,
      { mutability: FunctionStateMutability.View },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(typeToRead: CairoType): GeneratedFunctionInfo {
    const functionsCalled: FunctionDefinition[] = [];

    // register require imports
    if (typeToRead instanceof CairoContractAddress) {
      createImport(...OPTION_TRAIT, this.sourceUnit, this.ast, [], [], {
        isTrait: true,
      });
      createImport(...CONTRACT_ADDRESS, this.sourceUnit, this.ast);
      functionsCalled.push(createImport(...CONTRACT_ADDRESS_FROM_FELT, this.sourceUnit, this.ast));
    }

    const funcName = `WS${this.generatedFunctionsDef.size}_READ_${typeToRead.typeName}`;
    const resultCairoType = typeToRead.toString();
    const [reads, pack] = serialiseReads(typeToRead, readFelt, readId, readAddress, uNread);
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: endent`
        fn ${funcName}(loc: felt252) -> ${resultCairoType}{
          ${reads.map((s) => `  ${s}`).join('\n')}
          ${pack}
        }
      `,
      functionsCalled: functionsCalled,
    };
    return funcInfo;
  }
}

function readFelt(offset: number): string {
  return `let read${offset} = WARP_STORAGE::read(${add('loc', offset)});`;
}

function readAddress(offset: number): string {
  return `let read${offset} =  starknet::contract_address_try_from_felt252(WARP_STORAGE::read(${add(
    'loc',
    offset,
  )})).unwrap();`;
}

function readId(offset: number): string {
  return `let read${offset} = readId(${add('loc', offset)});`;
}

function uNread(offset: number, nBits: number) {
  return `let read${offset} = core::integer::u${nBits}_from_felt252(WARP_STORAGE::read(${add(
    'loc',
    offset,
  )}));`;
}
