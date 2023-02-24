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
      if (isReturnParamList(node)) {
        // In Cairo1 return parameters are not named
        if (tp instanceof CairoDynArray && node.parent instanceof FunctionDefinition) {
          return isExternallyVisible(node.parent) ||
            node.getClosestParentByType(ContractDefinition)?.name.includes('@interface')
            ? `${tp.vLen.toString()}, ${tp.vPtr.toString()}`
            : `${tp.toString()}`;
        }
        return `${tp}`;
      } else {
        if (tp instanceof CairoDynArray && node.parent instanceof FunctionDefinition) {
          return isExternallyVisible(node.parent) ||
            node.getClosestParentByType(ContractDefinition)?.name.includes('@interface')
            ? `${value.name}_len : ${tp.vLen.toString()}, ${value.name} : ${tp.vPtr.toString()}`
            : `${value.name} : ${tp.toString()}`;
        }
        return `${value.name} : ${tp}`;
      }
    });
    return [params.join(', ')];
  }
}
