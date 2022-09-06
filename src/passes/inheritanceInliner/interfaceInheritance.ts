import {
  ContractDefinition,
  ContractKind,
  FunctionCall,
  FunctionCallKind,
  MemberAccess,
  SourceUnit,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { cloneASTNode } from '../../utils/cloning';
import { TranspileFailedError } from '../../utils/errors';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { getBaseContracts } from './utils';

export function addInterfaceDefinitions(
  node: CairoContract,
  idRemapping: Map<number, ContractDefinition>,
  ast: AST,
): void {
  getBaseContracts(node).forEach((base) =>
    base.walkChildren((node) => {
      if (
        node instanceof FunctionCall &&
        node.kind === FunctionCallKind.FunctionCall &&
        node.vExpression instanceof MemberAccess
      ) {
        // check if we're calling a member of a contract
        const nodeType = safeGetNodeType(node.vExpression.vExpression, ast.compilerVersion);
        const source = node.getClosestParentByType(SourceUnit);
        if (source === undefined) {
          throw new TranspileFailedError(`Couldn't find SourceUnit of ${node.vMemberName}`);
        }
        if (
          nodeType instanceof UserDefinedType &&
          nodeType.definition instanceof ContractDefinition &&
          !source.vContracts.includes(nodeType.definition) &&
          // Interface has already been included
          ![...idRemapping.keys()].includes(nodeType.definition.id)
        ) {
          const newInterfaceDefinition = cloneASTNode(nodeType.definition, ast);
          source.insertAtBeginning(newInterfaceDefinition);
          idRemapping.set(nodeType.definition.id, newInterfaceDefinition);
        }
      }
    }),
  );
}
