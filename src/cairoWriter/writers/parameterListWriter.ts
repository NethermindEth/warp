import {
  ASTWriter,
  DataLocation,
  FunctionDefinition,
  ParameterList,
  SrcDesc,
} from 'solc-typed-ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { isExternallyVisible, isReturnParamList } from '../../utils/utils';
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
      // TODO: In the position of the type is written the typeString of the var. Needs to be checked the transformation
      // of that typestring into de Cairo 1 syntax for that type (Eg: dynamic arrays of some variable)
      return isReturnParamList(node) ? `${tp}` : `${value.name} : ${tp}`;
    });
    return [params.join(', ')];
  }
}
