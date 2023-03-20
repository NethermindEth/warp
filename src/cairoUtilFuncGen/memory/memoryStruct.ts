import assert = require('assert');
import {
  DataLocation,
  FunctionCall,
  IdentifierPath,
  PointerType,
  StructDefinition,
  TypeNode,
  UserDefinedTypeName,
} from 'solc-typed-ast';
import { CairoStruct, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { DICT_ACCESS, DICT_WRITE, GET_U128, WM_ALLOC } from '../../utils/importPaths';
import { safeGetNodeType, typeNameToSpecializedTypeNode } from '../../utils/nodeTypeProcessing';
import { uint256 } from '../../warplib/utils';
import { add, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';

/*
  Produces functions to allocate memory structs, assign their members, and return their location
  This replaces StructConstructorCalls referencing memory with normal FunctionCalls
*/
export class MemoryStructGen extends StringIndexedFuncGen {
  public gen(node: FunctionCall): FunctionCall {
    const structDef = node.vReferencedDeclaration;
    assert(structDef instanceof StructDefinition);

    const nodeType = safeGetNodeType(node, this.ast.inference);
    const funcDef = this.getOrCreateFuncDef(nodeType, structDef);

    structDef.vScope.acceptChildren();
    return createCallToFunction(funcDef, node.vArguments, this.ast);
  }

  public getOrCreateFuncDef(nodeType: TypeNode, structDef: StructDefinition) {
    const key = `memoryStruct(${nodeType.pp()},${structDef.name})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const cairoType = CairoType.fromSol(nodeType, this.ast, TypeConversionContext.MemoryAllocation);
    assert(cairoType instanceof CairoStruct);
    const funcInfo = this.getOrCreate(cairoType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      structDef.vMembers.map((decl) => {
        assert(decl.vType !== undefined);
        const type = typeNameToSpecializedTypeNode(
          decl.vType,
          DataLocation.Memory,
          this.ast.inference,
        );
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
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(structType: CairoStruct): GeneratedFunctionInfo {
    const funcName = `WM${this.generatedFunctionsDef.size}_struct_${structType.name}`;

    const mangledStructMembers: [string, CairoType][] = [...structType.members.entries()].map(
      ([name, type]) => [`member_${name}`, type],
    );
    const argString = mangledStructMembers
      .map(([name, type]) => `${name}: ${type.toString()}`)
      .join(', ');

    return {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory: DictAccess*}(${argString}) -> (res:felt){`,
        `    alloc_locals;`,
        `    let (start) = wm_alloc(${uint256(structType.width)});`,
        mangledStructMembers
          .flatMap(([name, type]) => type.serialiseMembers(name))
          .map(write)
          .join('\n'),
        `    return (start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport(...WM_ALLOC),
        this.requireImport(...DICT_WRITE),
        this.requireImport(...DICT_ACCESS),
        this.requireImport(...GET_U128),
      ],
    };
  }
}

function write(name: string, offset: number): string {
  return `dict_write{dict_ptr=warp_memory}(${add('start', offset)}, ${name});`;
}
