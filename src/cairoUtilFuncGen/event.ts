import {
  DataLocation,
  EmitStatement,
  EventDefinition,
  FunctionCall,
  generalizeType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';

import {
  AbiEncode,
  AST,
  createCairoFunctionStub,
  createCallToFunction,
  isValueType,
  safeGetNodeType,
  typeNameFromTypeNode,
} from '../export';
import { StringIndexedFuncGen } from './base';

/**
 * Generates a cairo function that emits an event through a cairo syscall.
 * Then replace the emit statement with a call to the generated function.
 */
export class EventFunction extends StringIndexedFuncGen {
  private abiEncode: AbiEncode;

  constructor(abiEncode: AbiEncode, ast: AST, sourceUint: SourceUnit) {
    super(ast, sourceUint);
    this.abiEncode = abiEncode;
  }

  public gen(node: EmitStatement, refEventDef: EventDefinition): FunctionCall {
    const argsTypes: TypeNode[] = node.vEventCall.vArguments.map(
      (arg) => generalizeType(safeGetNodeType(arg, this.ast.compilerVersion))[0],
    );

    const funcName = this.getOrCreate(refEventDef, argsTypes);

    const functionStub = createCairoFunctionStub(
      funcName,
      argsTypes.map((argT, index) =>
        isValueType(argT)
          ? [`param${index}`, typeNameFromTypeNode(argT, this.ast)]
          : [`param${index}`, typeNameFromTypeNode(argT, this.ast), DataLocation.Memory],
      ),
      [],
      ['bitwise_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      this.sourceUnit,
    );

    return createCallToFunction(functionStub, node.vEventCall.vArguments, this.ast);
  }

  private getOrCreate(node: EventDefinition, _argsTypes: TypeNode[]): string {
    const key = node.name;

    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }
    // TODO: Implement
    // const code =[

    // ]
    return '';
  }
}
