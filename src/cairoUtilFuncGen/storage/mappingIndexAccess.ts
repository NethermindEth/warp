import assert from 'assert';
import {
  ASTNode,
  DataLocation,
  FunctionCall,
  getNodeType,
  IndexAccess,
  MappingType,
  PointerType,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGen } from '../base';

export class MappingIndexAccessGen extends StringIndexedFuncGen {
  gen(node: IndexAccess, nodeInSourceUnit?: ASTNode): FunctionCall {
    const base = node.vBaseExpression;
    const index = node.vIndexExpression;
    assert(index !== undefined);

    const nodeType = getNodeType(node, this.ast.compilerVersion);
    const baseType = getNodeType(base, this.ast.compilerVersion);

    assert(baseType instanceof PointerType && baseType.to instanceof MappingType);
    const name = this.getOrCreate(
      CairoType.fromSol(baseType.to.keyType, this.ast),
      CairoType.fromSol(nodeType, this.ast, TypeConversionContext.StorageAllocation),
    );

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['name', typeNameFromTypeNode(baseType, this.ast), DataLocation.Storage],
        // TODO check that this is always default
        ['index', typeNameFromTypeNode(baseType.to.keyType, this.ast), DataLocation.Default],
      ],
      [['res', typeNameFromTypeNode(nodeType, this.ast)]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
    );

    return createCallToFunction(functionStub, [base, index], this.ast);
  }

  private getOrCreate(indexType: CairoType, valueType: CairoType): string {
    const key = `${indexType.fullStringRepresentation}/${valueType.fullStringRepresentation}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `WS${this.generatedFunctions.size}_INDEX_${indexType.typeName}_to_${valueType.typeName}`;
    const mappingName = `WARP_MAPPING${this.generatedFunctions.size}`;
    const indexTypeString = indexType.toString();
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `@storage_var`,
        `func ${mappingName}(name: felt, index: ${indexTypeString}) -> (resLoc : felt):`,
        `end`,
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: ${indexTypeString}) -> (res: felt):`,
        `    alloc_locals`,
        `    let (existing) = ${mappingName}.read(name, index)`,
        `    if existing == 0:`,
        `        let (used) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(used + ${valueType.width})`,
        `        ${mappingName}.write(name, index, used)`,
        `        return (used)`,
        `    else:`,
        `        return (existing)`,
        `    end`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }
}
