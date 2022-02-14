import { ASTWriter, CompileFailedError, PrettyFormatter } from 'solc-typed-ast';
import {
  AddressHandler,
  AnnotateImplicits,
  BuiltinHandler,
  ExpressionSplitter,
  ExternImporter,
  IdentifierMangler,
  ImplicitConversionToExplicit,
  IntBoundCalculator,
  LiteralExpressionEvaluator,
  LoopFunctionaliser,
  MemoryHandler,
  ReturnInserter,
  StorageAllocator,
  StorageVariableAccessRewriter,
  TupleAssignmentSplitter,
  Uint256Importer,
  UnloadingAssignment,
  UnreachableStatementPruner,
  UsingForResolver,
  VariableDeclarationExpressionSplitter,
  VariableDeclarationInitialiser,
} from './passes';
import { TranspilationAbandonedError, TranspileFailedError } from './utils/errors';
import { printCompileErrors, runSanityCheck } from './utils/utils';

import { AST } from './ast/ast';
import { ASTMapper } from './ast/mapper';
import { CairoASTMapping } from './cairoWriter';
import { CairoToSolASTWriterMapping } from './solWriter';
import { DefaultASTPrinter } from './utils/astPrinter';
import { RejectUnsupportedFeatures } from './passes/rejectUnsupportedFeatures';
import { TranspilationOptions } from '.';
import { parsePassOrder } from './utils/cliOptionParsing';

export function transpile(ast: AST, options: TranspilationOptions): string {
  const cairoAST = applyPasses(ast, options);
  const writer = new ASTWriter(
    CairoASTMapping(cairoAST, options.strict ?? false),
    new PrettyFormatter(4, 0),
    ast.compilerVersion,
  );
  return writer.write(ast.root);
}

export function transform(ast: AST, options: TranspilationOptions): string {
  const cairoAST = applyPasses(ast, options);
  const writer = new ASTWriter(
    CairoToSolASTWriterMapping,
    new PrettyFormatter(4, 0),
    ast.compilerVersion,
  );
  return writer.write(cairoAST.root);
}

// Options used: order, printTrees, checkTrees, strict
function applyPasses(ast: AST, options: TranspilationOptions): AST {
  // TODO: Indentifier mangler
  // TODO: StorageVarPass:
  // TODO: Semantic pass to check that mapping access are fully applied
  // TODO: mapper creates an enum for each storage var mapping type
  // TODO: mapper replaces all 'non storage' declarations with instance of enum (will always be defined because of solidity restriction, they must be initialised)
  // TODO: mapper replace index accesses with the function calling the right storage var

  // TODO: assignment needs to switch on the type rhs expression to decide between let(felt) vs assert(felt* array)
  // TODO: Replace all arrays with array type plus length pointer.
  // TODO: Replace reference writes with object copies. (use array length as an optimization) Update array lengths
  // TODO: Implement Custom Node for Builtins
  // TODO: add expected prerequisites to each pass
  const passes: Map<string, ASTMapper> = new Map([
    ['Ru', new RejectUnsupportedFeatures()],
    ['Ufr', new UsingForResolver()],
    ['Ib', new IntBoundCalculator()],
    ['M', new IdentifierMangler()],
    ['Sa', new StorageAllocator()],
    ['Ei', new ExternImporter()],
    ['L', new LiteralExpressionEvaluator()],
    ['Lf', new LoopFunctionaliser()],
    ['T', new TupleAssignmentSplitter()],
    ['Ah', new AddressHandler()],
    ['U', new UnloadingAssignment()],
    ['V', new VariableDeclarationInitialiser()],
    ['Vs', new VariableDeclarationExpressionSplitter()],
    ['Me', new MemoryHandler()],
    ['S', new StorageVariableAccessRewriter()],
    ['I', new ImplicitConversionToExplicit()],
    ['B', new BuiltinHandler()],
    ['Us', new UnreachableStatementPruner()],
    ['R', new ReturnInserter()],
    ['E', new ExpressionSplitter()],
    ['An', new AnnotateImplicits()],
    ['Ui', new Uint256Importer()],
  ]);

  const passesInOrder: ASTMapper[] = parsePassOrder(options.order, options.until, passes);
  if (options.highlight) {
    DefaultASTPrinter.highlightId(parseInt(options.highlight));
  }
  if (options.printTrees) {
    console.log('---Input---');
    console.log(DefaultASTPrinter.print(ast.root));
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
      console.log(DefaultASTPrinter.print(ast.root));
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
    console.log('Cannot start transpilation');
  } else if (e instanceof TranspilationAbandonedError) {
    console.log(`Transpilation abandoned ${e.message}`);
  } else {
    console.log('Unexpected error during transpilation');
    console.log(e);
    console.log('Transpilation failed');
  }
}
