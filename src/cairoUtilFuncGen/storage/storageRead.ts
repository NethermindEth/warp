import {
  Expression,
  FunctionCall,
  DataLocation,
  FunctionStateMutability,
  TypeNode,
  TypeName,
} from 'solc-typed-ast';
import { typeNameFromTypeNode } from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { add, GeneratedFunctionInfo, locationIfComplexType, StringIndexedFuncGen } from '../base';
import { serialiseReads } from '../serialisation';

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
    const funcName = `WS${this.generatedFunctionsDef.size}_READ_${typeToRead.typeName}`;
    const resultCairoType = typeToRead.toString();
    const [reads, pack] = serialiseReads(typeToRead, readFelt, readId);
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: ${resultCairoType}){`,
        `    alloc_locals;`,
        ...reads.map((s) => `    ${s}`),
        `    return (${pack},);`,
        '}',
      ].join('\n'),
      functionsCalled: [],
    };
    return funcInfo;
  }
}

function readFelt(offset: number): string {
  return `let (read${offset}) = WARP_STORAGE.read(${add('loc', offset)});`;
}

function readId(offset: number): string {
  return `let (read${offset}) = readId(${add('loc', offset)});`;
}
