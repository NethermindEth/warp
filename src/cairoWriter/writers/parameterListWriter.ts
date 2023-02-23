import {
  ASTWriter,
  ContractDefinition,
  DataLocation,
  FunctionDefinition,
  ParameterList,
  SrcDesc,
} from 'solc-typed-ast';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { isExternallyVisible } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';

export class ParameterListWriter extends CairoASTNodeWriter {
  writeInner(node: ParameterList, _writer: ASTWriter): SrcDesc {
    const defContext =
      node.parent instanceof FunctionDefinition && isExternallyVisible(node.parent)
        ? TypeConversionContext.CallDataRef
        : TypeConversionContext.Ref;

    const params = node.vParameters.map((value) => {
      const varTypeConversionContext =
        value.storageLocation === DataLocation.CallData
          ? TypeConversionContext.CallDataRef
          : defContext;

      const tp = CairoType.fromSol(
        safeGetNodeType(value, this.ast.inference),
        this.ast,
        varTypeConversionContext,
      );
      if (tp instanceof CairoDynArray && node.parent instanceof FunctionDefinition) {
        return isExternallyVisible(node.parent) ||
          node.getClosestParentByType(ContractDefinition)?.name.includes('@interface')
          ? `${value.name}_len : ${tp.vLen.toString()}, ${value.name} : ${tp.vPtr.toString()}`
          : `${value.name} : ${tp.toString()}`;
      }
      return `${value.name} : ${tp}`;
    });
    return [params.join(', ')];
  }
}
