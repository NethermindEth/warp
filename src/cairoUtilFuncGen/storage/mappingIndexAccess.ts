import assert from 'assert';
import {
  DataLocation,
  FunctionCall,
  generalizeType,
  IndexAccess,
  MappingType,
  PointerType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition, FunctionStubKind } from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import {
  createCairoGeneratedFunction,
  createCallToFunction,
  ParameterInfo,
} from '../../utils/functionGeneration';
import { createUint8TypeName, createUintNTypeName } from '../../utils/nodeTemplates';
import {
  getElementType,
  isDynamicArray,
  isReferenceType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase, GeneratedFunctionInfo, locationIfComplexType } from '../base';
import { DynArrayGen } from './dynArray';

export class MappingIndexAccessGen extends CairoUtilFuncGenBase {
  private indexAccesFunctions = new Map<string, CairoFunctionDefinition>();
  private stringHashFunctions = new Map<string, CairoFunctionDefinition>();
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  public gen(node: IndexAccess): FunctionCall {
    console.log('gen in ', 'MappingIndexAccessGen ');

    const base = node.vBaseExpression;
    let index = node.vIndexExpression;
    assert(index !== undefined);

    const nodeType = safeGetNodeType(node, this.ast.inference);
    const baseType = safeGetNodeType(base, this.ast.inference);
    assert(baseType instanceof PointerType && baseType.to instanceof MappingType);

    if (isReferenceType(baseType.to.keyType)) {
      const [stringType, stringLoc] = generalizeType(safeGetNodeType(index, this.ast.inference));
      assert(stringLoc !== undefined);
      const stringHashFunc = this.getOrCreateStringHashFunction(stringType, stringLoc);
      index = createCallToFunction(stringHashFunc, [index], this.ast, this.sourceUnit);
    }

    const funcDef = this.getOrCreateIndexAccessFunction(baseType.to.keyType, nodeType);
    return createCallToFunction(funcDef, [base, index], this.ast);
  }

  public getOrCreateIndexAccessFunction(indexType: TypeNode, nodeType: TypeNode) {
    const indexKey = CairoType.fromSol(
      indexType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).fullStringRepresentation;
    const nodeKey = CairoType.fromSol(
      nodeType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).fullStringRepresentation;
    const key = indexKey + '-' + nodeKey;
    const existing = this.indexAccesFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.generateIndexAccess(indexType, nodeType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['name', typeNameFromTypeNode(indexType, this.ast), DataLocation.Storage],
        [
          'index',
          typeNameFromTypeNode(indexType, this.ast),
          locationIfComplexType(indexType, DataLocation.Memory),
        ],
      ],
      [
        [
          'res',
          typeNameFromTypeNode(nodeType, this.ast),
          locationIfComplexType(nodeType, DataLocation.Storage),
        ],
      ],
      this.ast,
      this.sourceUnit,
    );
    this.indexAccesFunctions.set(key, funcDef);
    return funcDef;
  }

  private generateIndexAccess(indexType: TypeNode, valueType: TypeNode): GeneratedFunctionInfo {
    const indexCairoType = CairoType.fromSol(indexType, this.ast);
    const valueCairoType = CairoType.fromSol(
      valueType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const identifier = this.indexAccesFunctions.size;
    const funcName = `WS_INDEX_${indexCairoType.typeName}_to_${valueCairoType.typeName}${identifier}`;
    const mappingName = `WARP_MAPPING${identifier}`;
    const indexTypeString = indexCairoType.toString();

    const mappingFuncInfo: GeneratedFunctionInfo = {
      name: mappingName,
      code: [`${mappingName}:LegacyMap::<(felt, ${indexTypeString}), felt}>`].join('\n'),
      functionsCalled: [],
    };
    const mappingFunc = createCairoGeneratedFunction(
      mappingFuncInfo,
      [
        ['name', createUintNTypeName(248, this.ast)],
        ['index', typeNameFromTypeNode(indexType, this.ast)],
      ],
      [],
      this.ast,
      this.sourceUnit,
      { stubKind: FunctionStubKind.StorageDefStub },
    );

    return {
      name: funcName,
      code: [
        `fn ${funcName}(name: felt, index: ${indexTypeString}) -> felt {`,
        `    let existing = ${mappingName}::read(name, index);`,
        `    if existing == 0 {`,
        `        let used = WARP_USED_STORAGE::read();`,
        `        WARP_USED_STORAGE::write(used + ${valueCairoType.width});`,
        `        ${mappingName}::write(name, index, used);`,
        `        used`,
        `    } else {`,
        `        existing`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: [mappingFunc],
    };
  }

  public getOrCreateStringHashFunction(
    indexType: TypeNode,
    dataLocation: DataLocation,
  ): CairoFunctionDefinition {
    assert(dataLocation !== DataLocation.Default);

    const key = indexType.pp() + dataLocation;
    const existing = this.stringHashFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const indexTypeName = typeNameFromTypeNode(indexType, this.ast);

    const inputInfo: ParameterInfo[] = [['str', indexTypeName, dataLocation]];
    const outputInfo: ParameterInfo[] = [
      ['hashed_str', createUint8TypeName(this.ast), DataLocation.Default],
    ];

    if (dataLocation === DataLocation.CallData) {
      const importFunction = this.ast.registerImport(
        this.sourceUnit,
        'warplib.string_hash',
        'string_hash',
        inputInfo,
        outputInfo,
      );
      return importFunction;
    }

    if (dataLocation === DataLocation.Memory) {
      const importFunction = this.ast.registerImport(
        this.sourceUnit,
        'warplib.string_hash',
        'wm_string_hash',
        inputInfo,
        outputInfo,
      );
      return importFunction;
    }

    // Datalocation is storage
    const funcInfo = this.generateStringHashFunction(indexType);
    const genFunc = createCairoGeneratedFunction(
      funcInfo,
      inputInfo,
      outputInfo,
      this.ast,
      this.sourceUnit,
    );
    this.stringHashFunctions.set(key, genFunc);
    return genFunc;
  }

  private generateStringHashFunction(indexType: TypeNode): GeneratedFunctionInfo {
    assert(isDynamicArray(indexType));
    const elemenT = getElementType(indexType);

    const [dynArray, dynArrayLen] = this.dynArrayGen.getOrCreateFuncDef(elemenT);
    const arrayName = dynArray.name;
    const lenName = dynArrayLen.name;

    const funcName = `WS_STRING_HASH${this.stringHashFunctions.size}`;
    const helperFuncName = `WS_TO_FELT_ARRAY${this.stringHashFunctions.size}`;
    return {
      name: funcName,
      code: [
        `fn ${helperFuncName}(name : felt, ptr : felt*, len : felt){`,
        `    if len == 0{`,
        `        return;`,
        `    }`,
        `    let index = len - 1;`,
        `    let index256 = felt_to_uint256(index);`,
        `    let loc = ${arrayName}::read(name, index256);`,
        `    let value = WARP_STORAGE::read(loc);`,
        `    assert ptr[index] = value;`,
        `    ${helperFuncName}(name, ptr, index);`,
        `}`,
        `fn ${funcName}(name: felt) -> felt {`,
        `    let len256 = ${lenName}::read(name);`,
        `    let len = narrow_safe(len256);`,
        `    let ptr = alloc();`,
        `    ${helperFuncName}(name, ptr, len);`,
        `    string_hash(len, ptr)`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport('warplib.maths.utils', 'narrow_safe'),
        this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
        this.requireImport('starkware.cairo.common.alloc', 'alloc'),
        this.requireImport('warplib.string_hash', 'string_hash'),
        dynArray,
        dynArrayLen,
      ],
    };
  }
}
