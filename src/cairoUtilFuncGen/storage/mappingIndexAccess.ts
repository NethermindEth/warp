import assert from 'assert';
import {
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  generalizeType,
  IndexAccess,
  MappingType,
  PointerType,
  SourceUnit,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { createUint8TypeName } from '../../utils/nodeTemplates';
import { isReferenceType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { GeneratedFunctionInfo, locationIfComplexType, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class MappingIndexAccessGen extends StringIndexedFuncGen {
  private generatedHashFunctionNumber = 0;

  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  gen(node: IndexAccess, nodeInSourceUnit?: ASTNode): FunctionCall {
    const base = node.vBaseExpression;
    let index = node.vIndexExpression;
    assert(index !== undefined);

    const nodeType = safeGetNodeType(node, this.ast.compilerVersion);
    const baseType = safeGetNodeType(base, this.ast.compilerVersion);

    assert(baseType instanceof PointerType && baseType.to instanceof MappingType);

    const indexCairoType = CairoType.fromSol(baseType.to.keyType, this.ast);
    const valueCairoType = CairoType.fromSol(
      nodeType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    if (isReferenceType(baseType.to.keyType)) {
      const stringLoc = generalizeType(safeGetNodeType(index, this.ast.compilerVersion))[1];
      assert(stringLoc !== undefined);
      const call = this.createStringHashFunction(node, stringLoc, indexCairoType);
      index = call;
    }

    const funcInfo = this.getOrCreate(indexCairoType, valueCairoType);

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
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
    );

    return createCallToFunction(funcDef, [base, index], this.ast);
  }

  private getOrCreate(indexType: CairoType, valueType: CairoType): GeneratedFunctionInfo {
    const key = `${indexType.fullStringRepresentation}/${valueType.fullStringRepresentation}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcName = `WS${this.generatedFunctions.size - this.generatedHashFunctionNumber}_INDEX_${
      indexType.typeName
    }_to_${valueType.typeName}`;
    const mappingName = `WARP_MAPPING${
      this.generatedFunctions.size - this.generatedHashFunctionNumber
    }`;
    const indexTypeString = indexType.toString();
    const funcInfo: GeneratedFunctionInfo = {
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
    this.generatedFunctions.set(key, funcInfo);
    return funcInfo;
  }

  private createStringHashFunction(
    node: IndexAccess,
    loc: DataLocation,
    indexCairoType: CairoType,
  ): FunctionCall {
    assert(node.vIndexExpression instanceof Expression);
    const indexType = safeGetNodeType(node.vIndexExpression, this.ast.compilerVersion);
    const indexTypeName = typeNameFromTypeNode(indexType, this.ast);
    if (loc === DataLocation.CallData) {
      const stub = createCairoFunctionStub(
        'string_hash',
        [['str', indexTypeName, DataLocation.CallData]],
        [['hashedStr', createUint8TypeName(this.ast), DataLocation.Default]],
        ['pedersen_ptr'],
        this.ast,
        node,
      );
      const call = createCallToFunction(stub, [node.vIndexExpression], this.ast);
      this.ast.registerImport(call, 'warplib.string_hash', 'string_hash');
      return call;
    } else if (loc === DataLocation.Memory) {
      const stub = createCairoFunctionStub(
        'wm_string_hash',
        [['str', indexTypeName, DataLocation.Memory]],
        [['hashedStr', createUint8TypeName(this.ast), DataLocation.Default]],
        ['pedersen_ptr', 'range_check_ptr', 'warp_memory'],
        this.ast,
        node,
      );
      const call = createCallToFunction(stub, [node.vIndexExpression], this.ast);
      this.ast.registerImport(call, 'warplib.string_hash', 'wm_string_hash');
      return call;
    } else {
      const funcsCalled: FunctionDefinition[] = [];
      funcsCalled.push(
        this.requireImport('warplib.maths.utils', 'narrow_safe'),
        this.requireImport('warplib.maths.utils', 'felt_to_uint256'),
        this.requireImport('starkware.cairo.common.alloc', 'alloc'),
        this.requireImport('warplib.string_hash', 'string_hash'),
      );
      const dataInfo = this.dynArrayGen.gen(indexCairoType);
      const lenName = dataInfo.name + '_LENGTH';
      const key = `${dataInfo.name}/${lenName}_hash`;
      let funcName = `ws_string_hash${this.generatedHashFunctionNumber}`;
      const helperFuncName = `ws_to_felt_array${this.generatedHashFunctionNumber}`;

      const existing = this.generatedFunctions.get(key);
      let funcInfo: GeneratedFunctionInfo;
      if (existing === undefined) {
        funcInfo = {
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
            `    let (loc) = ${dataInfo.name}.read(name, index256);`,
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
          functionsCalled: funcsCalled,
        };
        this.generatedFunctions.set(key, funcInfo);
        this.generatedHashFunctionNumber++;
      } else {
        funcInfo = existing;
      }
      const funcDef = createCairoGeneratedFunction(
        funcInfo,
        [['name', indexTypeName, DataLocation.Storage]],
        [['hashedStr', createUint8TypeName(this.ast), DataLocation.Default]],
        ['pedersen_ptr', 'range_check_ptr', 'syscall_ptr'],
        this.ast,
        node,
      );

      const call = createCallToFunction(funcDef, [node.vIndexExpression], this.ast);
      // TODO: Can this be deleted?
      this.ast.registerImport(call, 'warplib.maths.utils', 'narrow_safe');
      this.ast.registerImport(call, 'warplib.maths.utils', 'felt_to_uint256');
      this.ast.registerImport(call, 'starkware.cairo.common.alloc', 'alloc');
      this.ast.registerImport(call, 'warplib.string_hash', 'string_hash');
      return call;
    }
  }
}
