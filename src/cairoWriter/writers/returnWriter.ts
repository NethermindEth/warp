import {
  ASTWriter,
  FunctionCall,
  FunctionCallKind,
  Return,
  SrcDesc,
  TupleExpression,
} from 'solc-typed-ast';
import { CairoFunctionDefinition } from '../../ast/cairoNodes/cairoFunctionDefinition';
import { Implicits } from '../../utils/implicits';
import { isExternallyVisible } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

const KECCAK = 'keccak_ptr';
const WARP_MEMORY = 'warp_memory';

export class ReturnWriter extends CairoASTNodeWriter {
  writeInner(node: Return, writer: ASTWriter): SrcDesc {
    let returns = '()';
    const documentation = getDocumentation(node.documentation, writer);
    if (node.vExpression) {
      const expWriten = writer.write(node.vExpression);
      returns =
        node.vExpression instanceof TupleExpression ||
        (node.vExpression instanceof FunctionCall &&
          node.vExpression.kind !== FunctionCallKind.StructConstructorCall)
          ? expWriten
          : `(${expWriten},)`;
    }

    const finalizeWarpMemory = this.usesImplicit(WARP_MEMORY, node)
      ? 'default_dict_finalize(warp_memory_start, warp_memory, 0);\n'
      : '';

    const finalizeKeccakPtr = this.usesImplicit(KECCAK, node)
      ? 'finalize_keccak(keccak_ptr_start, keccak_ptr);\n'
      : '';

    return [
      [documentation, finalizeWarpMemory, finalizeKeccakPtr, `return ${returns};`].join('\n'),
    ];
  }

  private usesImplicit(implicit: Implicits, node: Return): boolean {
    const parentFunc = node.getClosestParentByType(CairoFunctionDefinition);
    return (
      parentFunc instanceof CairoFunctionDefinition &&
      parentFunc.implicits.has(implicit) &&
      isExternallyVisible(parentFunc)
    );
  }
}
