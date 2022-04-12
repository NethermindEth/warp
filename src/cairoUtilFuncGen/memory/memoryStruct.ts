import assert = require('assert');
import {
  DataLocation,
  FunctionCall,
  getNodeType,
  IdentifierPath,
  PointerType,
  StructDefinition,
  typeNameToSpecializedTypeNode,
  UserDefinedTypeName,
} from 'solc-typed-ast';
import { CairoStruct, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { uint256 } from '../../warplib/utils';
import { add, StringIndexedFuncGen } from '../base';

export class MemoryStructGen extends StringIndexedFuncGen {
  gen(node: FunctionCall): FunctionCall {
    console.log('mem struct start');
    const structDef = node.vReferencedDeclaration;
    assert(structDef instanceof StructDefinition);

    const cairoType = CairoType.fromSol(
      getNodeType(node, this.ast.compilerVersion),
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
    assert(cairoType instanceof CairoStruct);
    const name = this.getOrCreate(cairoType);

    const stub = createCairoFunctionStub(
      name,
      structDef.vMembers.map((decl) => {
        assert(decl.vType !== undefined);
        const type = typeNameToSpecializedTypeNode(decl.vType, DataLocation.Memory);
        return [
          decl.name,
          cloneASTNode(decl.vType, this.ast),
          type instanceof PointerType ? type.location : DataLocation.Default,
        ];
      }),
      [
        [
          'res',
          new UserDefinedTypeName(
            this.ast.reserveId(),
            '',
            `struct ${structDef.canonicalName}`,
            undefined,
            structDef.id,
            new IdentifierPath(this.ast.reserveId(), '', structDef.name, structDef.id),
          ),
          DataLocation.Memory,
        ],
      ],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      node,
    );

    stub.vScope.removeChild(stub);
    structDef.vScope.appendChild(stub);
    structDef.vScope.acceptChildren();

    console.log('mem struct end');

    return createCallToFunction(stub, node.vArguments, this.ast);
  }

  private getOrCreate(structType: CairoStruct): string {
    const key = structType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `WM${this.generatedFunctions.size}_struct_${structType.name}`;

    const argString = [...structType.members.entries()]
      .map(([name, type]) => `${name}: ${type.toString()}`)
      .join(', ');

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory: DictAccess*}(${argString}) -> (res):`,
        `    alloc_locals`,
        `    let (start) = wm_alloc(${uint256(BigInt(structType.width))})`,
        [...structType.members.entries()]
          .flatMap(([name, type]) => type.serialiseMembers(name))
          .map(write)
          .join('\n'),
        `    return (start)`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('warplib.memory', 'wm_alloc');
    this.requireImport('starkware.cairo.common.dict', 'dict_write');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');

    return funcName;
  }
}

function write(name: string, offset: number): string {
  return `dict_write{dict_ptr=warp_memory}(${add('start', offset)}, ${name})`;
}
