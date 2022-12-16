import { ASTWriter, SrcDesc, StructDefinition } from 'solc-typed-ast';
import { CairoType, safeGetNodeType, TypeConversionContext } from '../../export';
import { mangleStructName } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';
import { INDENT } from '../utils';

export class StructDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: StructDefinition, writer: ASTWriter): SrcDesc {
    return [
      [
        `struct ${mangleStructName(node)}{`,
        ...node.vMembers
          .map(
            (value) =>
              `${value.name} : ${CairoType.fromSol(
                safeGetNodeType(value, writer.targetCompilerVersion),
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
