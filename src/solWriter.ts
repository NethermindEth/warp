import {
  ASTNode,
  ASTNodeConstructor,
  ASTNodeWriter,
  ASTWriter,
  ContractDefinition,
  DefaultASTWriterMapping,
  FunctionDefinition,
  SrcDesc,
} from 'solc-typed-ast';
import {
  CairoAssert,
  CairoContract,
  CairoFunctionDefinition,
  FunctionStubKind,
} from './ast/cairoNodes';

class CairoContractSolWriter extends ASTNodeWriter {
  writeInner(node: CairoContract, writer: ASTWriter): SrcDesc {
    const result: SrcDesc = [];

    if (node.storageAllocations.size > 0) {
      result.push('<cairo information - multiline start> storage allocations\n');
      node.storageAllocations.forEach((idx, varDecl) => {
        result.push(`${idx}: ${writer.write(varDecl)}\n`);
      });
      result.push('<cairo information - multiline end>\n\n');
    }

    const solContract = new ContractDefinition(
      node.id,
      node.src,
      node.name,
      node.scope,
      node.kind,
      node.abstract,
      node.fullyImplemented,
      node.linearizedBaseContracts,
      node.usedErrors,
      node.documentation,
      node.children,
      node.nameLocation,
      node.raw,
    );
    result.push(writer.write(solContract));
    return result;
  }
}

class CairoFunctionDefinitionSolWriter extends ASTNodeWriter {
  constructor(private printStubs: boolean) {
    super();
  }

  writeInner(node: CairoFunctionDefinition, writer: ASTWriter): SrcDesc {
    if (node.functionStubKind !== FunctionStubKind.None && !this.printStubs) return [];

    const result: SrcDesc = [];

    if (node.implicits.size > 0) {
      const formatter = writer.formatter;
      result.push(
        ...[
          `<cairo information> implicits: ${writer.desc(new Array(...node.implicits).join(', '))}`,
          formatter.renderIndent(),
        ].join('\n'),
      );
    }

    const solFunctionDefinition = new FunctionDefinition(
      node.id,
      node.src,
      node.scope,
      node.kind,
      node.name,
      node.virtual,
      node.visibility,
      node.stateMutability,
      node.isConstructor,
      node.vParameters,
      node.vReturnParameters,
      node.vModifiers,
      node.vOverrideSpecifier,
      node.vBody,
      node.documentation,
      node.nameLocation,
      node.raw,
    );
    result.push(writer.write(solFunctionDefinition));
    return result;
  }
}

class CairoAssertSolWriter extends ASTNodeWriter {
  writeInner(node: CairoAssert, writer: ASTWriter): SrcDesc {
    const result: SrcDesc = [];
    result.push(`<cairo information> assert ${writer.write(node.vExpression)} = 1`);
    return result;
  }
}

const CairoExtendedASTWriterMapping = (printStubs: boolean) =>
  new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([
    [CairoContract, new CairoContractSolWriter()],
    [CairoFunctionDefinition, new CairoFunctionDefinitionSolWriter(printStubs)],
    [CairoAssert, new CairoAssertSolWriter()],
  ]);

export const CairoToSolASTWriterMapping = (printStubs: boolean) =>
  new Map<ASTNodeConstructor<ASTNode>, ASTNodeWriter>([
    ...DefaultASTWriterMapping,
    ...CairoExtendedASTWriterMapping(printStubs),
  ]);
