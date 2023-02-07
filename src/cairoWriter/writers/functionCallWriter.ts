import assert from 'assert';
import {
  ASTWriter,
  ContractDefinition,
  FunctionCall,
  FunctionCallKind,
  InferType,
  Literal,
  MemberAccess,
  SrcDesc,
  StructDefinition,
  UserDefinedType,
} from 'solc-typed-ast';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes';
import {
  CairoFunctionDefinition,
  isDynamicArray,
  mangleStructName,
  safeGetNodeType,
  TranspileFailedError,
} from '../../export';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation, getInterfaceNameForContract } from '../utils';
import { interfaceNameMappings } from './sourceUnitWriter';

export class FunctionCallWriter extends CairoASTNodeWriter {
  writeInner(node: FunctionCall, writer: ASTWriter): SrcDesc {
    const args = node.vArguments.map((v) => writer.write(v)).join(', ');
    const func = writer.write(node.vExpression);
    switch (node.kind) {
      case FunctionCallKind.FunctionCall: {
        if (node.vExpression instanceof MemberAccess) {
          // check if we're calling a member of a contract
          const nodeType = safeGetNodeType(
            node.vExpression.vExpression,
            new InferType(writer.targetCompilerVersion),
          );
          if (
            nodeType instanceof UserDefinedType &&
            nodeType.definition instanceof ContractDefinition
          ) {
            let isDelegateCall = false;
            const memberName = node.vExpression.memberName;
            let firstArg = writer.write(node.vExpression.vExpression); // could be address or class_hash
            const docLets = getDocumentation(nodeType.definition.documentation, writer)
              .split('\n')
              .map((ele) => ele.slice(2).trim());
            if (docLets[0] === 'WARP-GENERATED') {
              // extract class hash from doclets[1] which is in the format "class_hash: 0x..."
              const classHashTextLets = docLets[1].split(':').map((ele) => ele.trim());
              if (classHashTextLets[0] !== 'class_hash') {
                throw new TranspileFailedError('Class Hash not found in interface documentation');
              }
              isDelegateCall = true;
              firstArg = classHashTextLets[1];
            }
            return [
              `${getInterfaceNameForContract(
                nodeType.definition.name,
                node,
                interfaceNameMappings,
              )}.${(isDelegateCall ? 'library_call_' : '') + memberName}(${firstArg}${
                args ? ', ' : ''
              }${args})`,
            ];
          }
        } else if (
          node.vReferencedDeclaration instanceof CairoGeneratedFunctionDefinition &&
          node.vReferencedDeclaration.rawStringDefinition.includes('@storage_var')
        ) {
          return node.vArguments.length ===
            node.vReferencedDeclaration.vParameters.vParameters.length
            ? [`${func}.read(${args})`]
            : [`${func}.write(${args})`];
        } else if (
          node.vReferencedDeclaration instanceof CairoFunctionDefinition &&
          (node.vReferencedDeclaration.acceptsRawDarray ||
            node.vReferencedDeclaration.acceptsUnpackedStructArray)
        ) {
          const [len_suffix, name_suffix] = node.vReferencedDeclaration.acceptsRawDarray
            ? ['_len', '']
            : ['.len', '.ptr'];
          const argTypes = node.vArguments.map((v) => ({
            name: writer.write(v),
            type: safeGetNodeType(v, this.ast.inference),
          }));
          const args = argTypes
            .map(({ name, type }) =>
              isDynamicArray(type) ? `${name}${len_suffix}, ${name}${name_suffix}` : name,
            )
            .join(',');
          return [`${func}(${args})`];
        }
        return [`${func}(${args})`];
      }
      case FunctionCallKind.StructConstructorCall:
        return [
          `${
            node.vReferencedDeclaration && node.vReferencedDeclaration instanceof StructDefinition
              ? node.vReferencedDeclaration
                ? mangleStructName(node.vReferencedDeclaration)
                : func
              : func
          }(${args})`,
        ];

      case FunctionCallKind.TypeConversion: {
        const arg = node.vArguments[0];
        if (node.vFunctionName === 'address' && arg instanceof Literal) {
          const val = BigInt(arg.value);
          // Make sure literal < 2**251
          assert(val < BigInt('0x800000000000000000000000000000000000000000000000000000000000000'));
          return [`${args[0]}`];
        }
        const nodeType = safeGetNodeType(
          node.vExpression,
          new InferType(writer.targetCompilerVersion),
        );
        if (
          nodeType instanceof UserDefinedType &&
          nodeType.definition instanceof ContractDefinition
        ) {
          return [`${args}`];
        }
        return [`${func}(${args})`];
      }
    }
  }
}
