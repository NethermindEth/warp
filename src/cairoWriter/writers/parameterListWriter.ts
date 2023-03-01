import {
  ASTWriter,
  DataLocation,
  FunctionDefinition,
  InferType,
  ParameterList,
  SrcDesc,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { isExternallyVisible } from '../../utils/utils';
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
      const isReturnParamList =
        node.parent instanceof FunctionDefinition && node.parent.vReturnParameters === node;
      // TODO: In the position of the type is written the typeString of the var. Needs to be checked the transformation
      // of that typestring into de Cairo 1 syntax for that type (Eg: dynamic arrays of some variable)
      return isReturnParamList ? `${tp}` : `${value.name} : ${tp}`;
    });
    return [params.join(', ')];
  }
}
