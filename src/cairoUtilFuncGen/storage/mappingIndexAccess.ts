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
import { CairoFunctionDefinition } from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import {
  createCairoGeneratedFunction,
  createCallToFunction,
  ParameterInfo,
} from '../../utils/functionGeneration';
import { createUint8TypeName } from '../../utils/nodeTemplates';
import { isReferenceType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
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
    const funcDef = this.getOrCreateIndexAccessFunction(baseType, nodeType);
    return createCallToFunction(funcDef, [base, index], this.ast);
  }

  public getOrCreateIndexAccessFunction(baseType: TypeNode, nodeType: TypeNode) {
    assert(baseType instanceof PointerType && baseType.to instanceof MappingType);
    const indexCairoType = CairoType.fromSol(baseType.to.keyType, this.ast);
    const valueCairoType = CairoType.fromSol(
      nodeType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = indexCairoType.fullStringRepresentation + valueCairoType.fullStringRepresentation;
    const existing = this.indexAccesFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.generateIndexAccess(indexCairoType, valueCairoType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['name', typeNameFromTypeNode(baseType, this.ast), DataLocation.Storage],
        [
          'index',
          typeNameFromTypeNode(baseType.to.keyType, this.ast),
          locationIfComplexType(baseType.to.keyType, DataLocation.Memory),
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

  private generateIndexAccess(indexType: CairoType, valueType: CairoType): GeneratedFunctionInfo {
    const identifier = this.indexAccesFunctions.size;
    const funcName = `WS${identifier}_INDEX_${indexType.typeName}_to_${valueType.typeName}`;
    const mappingName = `WARP_MAPPING${identifier}`;
    const indexTypeString = indexType.toString();

    return {
      name: funcName,
      code: [
        `@storage_var`,
        `func ${mappingName}(name: felt, index: ${indexTypeString}) -> (resLoc : felt){`,
        `}`,
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: ${indexTypeString}) -> (res: felt){`,
        `    alloc_locals;`,
        `    let (existing) = ${mappingName}.read(name, index);`,
        `    if (existing == 0){`,
        `        let (used) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(used + ${valueType.width});`,
        `        ${mappingName}.write(name, index, used);`,
        `        return (used,);`,
        `    }else{`,
        `        return (existing,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: [],
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
      this.stringHashFunctions.set(key, importFunction);
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
      this.stringHashFunctions.set(key, importFunction);
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
    const [dynArray, dynArrayLen] = this.dynArrayGen.getOrCreateFuncDef(indexType);
    const arrayName = dynArray.name;
    const lenName = dynArrayLen.name;

    let funcName = `ws_string_hash${this.stringHashFunctions.size}`;
    const helperFuncName = `ws_to_felt_array${this.stringHashFunctions.size}`;

    return {
      name: funcName,
      code: [
        `func ${helperFuncName}{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(`,
        `    name : felt, ptr : felt*, len : felt`,
        `){`,
        `    alloc_locals;`,
        `    if (len == 0){`,
        `        return ();`,
        `    }`,
        `    let index = len - 1;`,
        `    let (index256) = felt_to_uint256(index);`,
        `    let (loc) = ${arrayName}.read(name, index256);`,
        `    let (value) = WARP_STORAGE.read(loc);`,
        `    assert ptr[index] = value;`,
        `    ${helperFuncName}(name, ptr, index);`,
        `    return ();`,
        `}`,
        `func ${funcName}{pedersen_ptr : HashBuiltin*, range_check_ptr, syscall_ptr : felt*}(`,
        `    name : felt`,
        `) -> (hashedValue : felt){`,
        `    alloc_locals;`,
        `    let (len256) = ${lenName}.read(name);`,
        `    let (len) = narrow_safe(len256);`,
        `    let (ptr) = alloc();`,
        `    ${helperFuncName}(name, ptr, len);`,
        `    let (hashValue) = string_hash(len, ptr);`,
        `    return (hashValue,);`,
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
