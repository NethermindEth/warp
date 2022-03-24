import { ASTWriter, CompileFailedError, PrettyFormatter } from 'solc-typed-ast';
import {
  AddressHandler,
  AnnotateImplicits,
  BuiltinHandler,
  DeleteHandler,
  EnumConverter,
  ExpressionSplitter,
  ExternImporter,
  PublicStateVarsGetterGenerator,
  IdentifierMangler,
  ImplicitConversionToExplicit,
  InheritanceInliner,
  IntBoundCalculator,
  LiteralExpressionEvaluator,
  LoopFunctionaliser,
  MemoryHandler,
  NamedArgsRemover,
  RejectUnsupportedFeatures,
  ReturnInserter,
  ReturnVariableInitializer,
  SourceUnitSplitter,
  StorageAllocator,
  StorageVariableAccessRewriter,
  TupleAssignmentSplitter,
  Uint256Importer,
  UnloadingAssignment,
  UnreachableStatementPruner,
  UsingForResolver,
  VariableDeclarationExpressionSplitter,
  VariableDeclarationInitialiser,
  IfFunctionaliser,
} from './passes';
import { TranspilationAbandonedError, TranspileFailedError } from './utils/errors';
import { printCompileErrors, runSanityCheck } from './utils/utils';

import { AST } from './ast/ast';
import { ASTMapper } from './ast/mapper';
import { CairoASTMapping } from './cairoWriter';
import { CairoToSolASTWriterMapping } from './solWriter';
import { DefaultASTPrinter } from './utils/astPrinter';
import { TranspilationOptions } from '.';
import { parsePassOrder } from './utils/cliOptionParsing';

type CairoSource = [file: string, source: string];

export function transpile(ast: AST, options: TranspilationOptions): CairoSource[] {
  const cairoAST = applyPasses(ast, options);
  const writer = new ASTWriter(
    CairoASTMapping(cairoAST, options.strict ?? false),
    new PrettyFormatter(4, 0),
    ast.compilerVersion,
  );
  return cairoAST.roots.map((sourceUnit) => [sourceUnit.absolutePath, writer.write(sourceUnit)]);
}

export function transform(ast: AST, options: TranspilationOptions): CairoSource[] {
  const cairoAST = applyPasses(ast, options);
  const writer = new ASTWriter(
    CairoToSolASTWriterMapping,
    new PrettyFormatter(4, 0),
    ast.compilerVersion,
  );
  return cairoAST.roots.map((sourceUnit) => [sourceUnit.absolutePath, writer.write(sourceUnit)]);
}

// Options used: order, printTrees, checkTrees, strict
function applyPasses(ast: AST, options: TranspilationOptions): AST {
  const passes: Map<string, typeof ASTMapper> = new Map([
    ['Ss', SourceUnitSplitter],
    ['Ru', RejectUnsupportedFeatures],
    ['L', LiteralExpressionEvaluator],
    ['Ufr', UsingForResolver],
    ['Na', NamedArgsRemover],
    ['Gp', PublicStateVarsGetterGenerator],
    ['Ib', IntBoundCalculator],
    ['M', IdentifierMangler],
    ['Ii', InheritanceInliner],
    ['Sa', StorageAllocator],
    ['Ec', EnumConverter],
    ['Ei', ExternImporter],
    ['Lf', LoopFunctionaliser],
    ['R', ReturnInserter],
    ['Rv', ReturnVariableInitializer],
    ['If', IfFunctionaliser],
    ['T', TupleAssignmentSplitter],
    ['Ah', AddressHandler],
    ['U', UnloadingAssignment],
    ['V', VariableDeclarationInitialiser],
    ['Vs', VariableDeclarationExpressionSplitter],
    ['Dh', DeleteHandler],
    ['Me', MemoryHandler],
    ['I', ImplicitConversionToExplicit],
    ['S', StorageVariableAccessRewriter],
    ['B', BuiltinHandler],
    ['Us', UnreachableStatementPruner],
    ['E', ExpressionSplitter],
    ['An', AnnotateImplicits],
    ['Ui', Uint256Importer],
  ]);

  const passesInOrder: typeof ASTMapper[] = parsePassOrder(options.order, options.until, passes);
  if (options.highlight) {
    DefaultASTPrinter.highlightId(parseInt(options.highlight));
  }
  if (options.printTrees) {
    console.log('---Input---');
    ast.roots.map((root) => console.log(DefaultASTPrinter.print(root)));
  }

  if (options.checkTrees || options.strict) {
    const success = runSanityCheck(ast, options.checkTrees ?? false);
    if (!success && options.strict) {
      throw new TranspileFailedError('AST failed internal consistency check before transpilation');
    }
  }

  const finalAst = passesInOrder.reduce((ast, mapper) => {
    const newAst = mapper.map(ast);
    if (options.printTrees) {
      console.log(`\n---After running ${mapper.getPassName()}---`);
      ast.roots.map((root) => console.log(DefaultASTPrinter.print(root)));
    }
    if (options.checkTrees || options.strict) {
      const success = runSanityCheck(ast, options.checkTrees ?? false);
      if (!success && options.strict) {
        throw new TranspileFailedError(
          'AST failed internal consistency check during transpilation',
        );
      }
    }
    return newAst;
  }, ast);

  return finalAst;
}

export function handleTranspilationError(e: unknown) {
  if (e instanceof CompileFailedError) {
    printCompileErrors(e);
    console.error('Cannot start transpilation');
  } else if (e instanceof TranspilationAbandonedError) {
    console.error(`Transpilation abandoned ${e.message}`);
  } else {
    console.error('Unexpected error during transpilation');
    console.error(e);
    console.error('Transpilation failed');
  }
}
