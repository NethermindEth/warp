import {
  Expression,
  TypeName,
  FunctionCall,
  DataLocation,
  FunctionStateMutability,
  TypeNode,
  ASTNode,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { add, GeneratedFunctionInfo, locationIfComplexType, StringIndexedFuncGen } from '../base';
import { serialiseReads } from '../serialisation';

export class StorageReadGen extends StringIndexedFuncGen {
  gen(storageLocation: Expression, type: TypeName, nodeInSourceUnit?: ASTNode): FunctionCall {
    const valueType = safeGetNodeType(storageLocation, this.ast.compilerVersion);
    const resultCairoType = CairoType.fromSol(
      valueType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const funcInfo = this.getOrCreate(resultCairoType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', cloneASTNode(type, this.ast), DataLocation.Storage]],
      [
        [
          'val',
          cloneASTNode(type, this.ast),
          locationIfComplexType(valueType, DataLocation.Storage),
        ],
      ],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? storageLocation,
      { mutability: FunctionStateMutability.View },
    );
    return createCallToFunction(funcDef, [storageLocation], this.ast);
  }

  genFuncName(type: TypeNode) {
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation);
    return this.getOrCreate(cairoType);
  }

  private getOrCreate(typeToRead: CairoType): GeneratedFunctionInfo {
    const key = typeToRead.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcName = `WS${this.generatedFunctions.size}_READ_${typeToRead.typeName}`;
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
    this.generatedFunctions.set(key, funcInfo);

    return funcInfo;
  }
}

function readFelt(offset: number): string {
  return `let (read${offset}) = WARP_STORAGE.read(${add('loc', offset)});`;
}

function readId(offset: number): string {
  return `let (read${offset}) = readId(${add('loc', offset)});`;
}
