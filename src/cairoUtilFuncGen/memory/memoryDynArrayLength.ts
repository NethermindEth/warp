import { MemberAccess, ArrayType, FunctionCall, ASTNode, DataLocation } from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase } from '../base';

export class MemoryDynArrayLengthGen extends CairoUtilFuncGenBase {
  getGeneratedCode(): string {
    return '';
  }

  gen(node: MemberAccess, arrayType: ArrayType): FunctionCall {
    const functionStub = createCairoFunctionStub(
      'wm_dyn_array_length',
      [['arrayLoc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Memory]],
      [['len', createUint256TypeName(this.ast)]],
      ['warp_memory'],
      this.ast,
      node,
    );

    const call = createCallToFunction(functionStub, [node.vExpression], this.ast);
    this.ast.registerImport(call, 'warplib.memory', 'wm_dyn_array_length');
    return call;
  }
}
