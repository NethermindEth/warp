import {
  ASTWriter,
  ContractDefinition,
  DataLocation,
  FunctionDefinition,
  InferType,
  ParameterList,
  SrcDesc,
} from 'solc-typed-ast';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { isExternallyVisible, isReturnParamList } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';

export class ParameterListWriter extends CairoASTNodeWriter {
  writeInner(node: ParameterList, writer: ASTWriter): SrcDesc {
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
        safeGetNodeType(value, new InferType(writer.targetCompilerVersion)),
        this.ast,
        varTypeConversionContext,
      );
      if (tp instanceof CairoDynArray && node.parent instanceof FunctionDefinition) {
        if (
          isExternallyVisible(node.parent) ||
          node.getClosestParentByType(ContractDefinition)?.name.includes('@interface')
        ) {
          const vLenStr = tp.vLen.toString();
          const vPtrStr = tp.vPtr.toString();
          return isReturnParamList(node)
            ? `${vLenStr}, ${vPtrStr}`
            : `${value.name}_len : ${vLenStr}, ${value.name} : ${vPtrStr}`;
        } else {
          return isReturnParamList(node) ? `${tp.toString()}` : `${value.name} : ${tp.toString()}`;
        }
      }
      return isReturnParamList(node) ? `${tp}` : `${value.name} : ${tp}`;
    });
    return [params.join(', ')];
  }
}
