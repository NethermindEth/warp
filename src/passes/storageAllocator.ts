import {
  Assignment,
  Block,
  ContractDefinition,
  ExpressionStatement,
  getNodeType,
  Identifier,
  Literal,
  LiteralKind,
  Mapping,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoContract } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { cloneExpression } from '../utils/cloning';
import { implicitImports } from '../utils/implicits';
import { getFeltWidth } from '../utils/serialisation';
import { toHexString } from '../utils/utils';

export class StorageAllocator extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    let usedMemory = 0;
    let mappingCount = 0;
    const allocations: Map<VariableDeclaration, number> = new Map();
    const initialisationBlock = new Block(ast.reserveId(), node.src, 'Block', []);
    node.vStateVariables.forEach((v) => {
      if (v.vType instanceof Mapping) {
        v.vValue = new Literal(
          ast.reserveId(),
          '',
          'Literal',
          v.typeString,
          LiteralKind.Number,
          toHexString(`${mappingCount}`),
          `${mappingCount}`,
        );
        v.vValue.parent = v;
        ++mappingCount;
      } else {
        const width = getFeltWidth(getNodeType(v, ast.compilerVersion));
        allocations.set(v, usedMemory);
        usedMemory += width;
        extractInitialisation(v, initialisationBlock, ast);
      }
    });
    ast.replaceNode(
      node,
      new CairoContract(
        node.id,
        node.src,
        'CairoContract',
        node.name,
        node.scope,
        node.kind,
        node.abstract,
        node.fullyImplemented,
        node.linearizedBaseContracts,
        node.usedErrors,
        allocations,
        initialisationBlock,
        node.documentation,
        node.children,
        node.nameLocation,
        node.raw,
      ),
    );
  }
}

function extractInitialisation(node: VariableDeclaration, initialisationBlock: Block, ast: AST) {
  if (node.vValue === undefined) return;

  initialisationBlock.appendChild(
    new ExpressionStatement(
      ast.reserveId(),
      node.src,
      'ExpressionStatement',
      new Assignment(
        ast.reserveId(),
        node.src,
        'Assignment',
        node.typeString,
        '=',
        new Identifier(
          ast.reserveId(),
          node.src,
          'Identifier',
          node.typeString,
          node.name,
          node.id,
        ),
        // TODO potentially move this rather than cloning it
        // Requires care wrt other passes that expect defined variables
        cloneExpression(node.vValue, ast),
      ),
    ),
  );

  // TODO move these into the implicits of the CairoFunctionDefinition for the constructor
  ast.addImports(implicitImports['syscall_ptr']);
  ast.addImports(implicitImports['pedersen_ptr']);
  ast.addImports(implicitImports['range_check_ptr']);
}
