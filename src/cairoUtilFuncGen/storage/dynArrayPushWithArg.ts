import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  FunctionCall,
  getNodeType,
  MemberAccess,
  PointerType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { typeNameFromTypeNode } from '../../utils/utils';
import { add, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayPushWithArgGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST) {
    super(ast);
  }

  gen(push: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(push.vExpression instanceof MemberAccess);
    const arrayType = getNodeType(push.vExpression.vExpression, this.ast.compilerVersion);
    assert(arrayType instanceof PointerType && arrayType.to instanceof ArrayType);

    const name = this.getOrCreate(
      CairoType.fromSol(arrayType.to.elementT, this.ast, TypeConversionContext.StorageAllocation),
    );

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage],
        [
          'value',
          typeNameFromTypeNode(arrayType.to.elementT, this.ast),
          arrayType.to.elementT instanceof PointerType
            ? DataLocation.Storage
            : DataLocation.Default,
        ],
      ],
      [],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? push,
    );

    return createCallToFunction(
      functionStub,
      [push.vExpression.vExpression, push.vArguments[0]],
      this.ast,
    );
  }

  private getOrCreate(elementType: CairoType): string {
    const key = elementType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const [arrayName, lengthName] = this.dynArrayGen.gen(elementType);
    const funcName = `${arrayName}_PUSHV`;

    const pushCode = (loc: string) =>
      elementType
        .serialiseMembers('value')
        .map((name, index) => `    ${write(add(loc, index), name)}`);

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: ${elementType.toString()}) -> ():`,
        `    alloc_locals`,
        `    let (len) = ${lengthName}.read(loc)`,
        `    let (newLen, carry) = uint256_add(len, Uint256(1,0))`,
        `    assert carry = 0`,
        `    ${lengthName}.write(loc, newLen)`,
        `    let (existing) = ${arrayName}.read(loc, len)`,
        `    if (existing) == 0:`,
        `        let (used) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(used + ${elementType.width})`,
        `        ${arrayName}.write(loc, len, used)`,
        ...pushCode('used'),
        `    else:`,
        ...pushCode('existing'),
        `    end`,
        `    return ()`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    return funcName;
  }
}

function write(offset: string, value: string): string {
  return `WARP_STORAGE.write(${offset}, ${value})`;
}
