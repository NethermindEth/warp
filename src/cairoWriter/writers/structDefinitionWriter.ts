import { ASTWriter, SrcDesc, StructDefinition } from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { mangleStructName } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';
import { INDENT } from '../utils';

export class StructDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: StructDefinition, _writer: ASTWriter): SrcDesc {
    return [
      [
        `struct ${mangleStructName(node)}{`,
        ...node.vMembers
          .map(
            (value) =>
              `${value.name} : ${CairoType.fromSol(
                safeGetNodeType(value, this.ast.inference),
                this.ast,
                TypeConversionContext.StorageAllocation,
              )},`,
          )
          .map((v) => INDENT + v),
        `}`,
      ].join('\n'),
    ];
  }
}
