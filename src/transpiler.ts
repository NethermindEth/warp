import { ASTWriter, CompileFailedError, PrettyFormatter } from 'solc-typed-ast';
import {
  AddressHandler,
  AnnotateImplicits,
  BuiltinHandler,
  ConstantHandler,
  DeleteHandler,
  EnumConverter,
  ExpressionSplitter,
  ExternalInputChecker,
  ExternImporter,
  IdentifierMangler,
  IfFunctionaliser,
  ImplicitConversionToExplicit,
  InheritanceInliner,
  IntBoundCalculator,
  LiteralExpressionEvaluator,
  LoopFunctionaliser,
  ModifierHandler,
  NamedArgsRemover,
  PublicFunctionSplitter,
  PublicStateVarsGetterGenerator,
  ReferencedLibraries,
  RejectUnsupportedFeatures,
  ReturnInserter,
  ReturnVariableInitializer,
  SourceUnitSplitter,
  StorageAllocator,
  References,
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
import { TranspilationOptions } from '.';
import { createPassMap, parsePassOrder } from './utils/cliOptionParsing';

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

function applyPasses(ast: AST, options: TranspilationOptions): AST {
  const passes: Map<string, typeof ASTMapper> = createPassMap([
    ['Ss', SourceUnitSplitter],
    ['Ru', RejectUnsupportedFeatures],
    ['L', LiteralExpressionEvaluator],
    ['Ufr', UsingForResolver],
    ['Na', NamedArgsRemover],
    ['Gp', PublicStateVarsGetterGenerator],
    ['Ib', IntBoundCalculator],
    ['Ch', ConstantHandler],
    ['M', IdentifierMangler],
    ['Rl', ReferencedLibraries],
    ['Ii', InheritanceInliner],
    ['Mh', ModifierHandler],
    ['Sa', StorageAllocator],
    ['Pfs', PublicFunctionSplitter],
    ['Eic', ExternalInputChecker],
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
    ['Rf', References],
    ['Dh', DeleteHandler],
    ['I', ImplicitConversionToExplicit],
    ['B', BuiltinHandler],
    ['Us', UnreachableStatementPruner],
    ['E', ExpressionSplitter],
    ['An', AnnotateImplicits],
    ['Ui', Uint256Importer],
  ]);

  const passesInOrder: typeof ASTMapper[] = parsePassOrder(options.order, options.until, passes);
  DefaultASTPrinter.applyOptions(options);

  printPassName('Input', options);
  printAST(ast, options);
  checkAST(ast, options, 'None run');

  const finalAst = passesInOrder.reduce((ast, mapper) => {
    printPassName(mapper.getPassName(), options);
    const newAst = mapper.map(ast);
    printAST(ast, options);
    checkAST(ast, options, mapper.getPassName());
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

// Transpilation printing
function printPassName(name: string, options: TranspilationOptions) {
  if (options.printTrees) console.log(`---${name}---`);
}

function printAST(ast: AST, options: TranspilationOptions) {
  if (options.printTrees) {
    ast.roots.map((root) => {
      console.log(DefaultASTPrinter.print(root));
      console.log();
    });
  }
}

function checkAST(ast: AST, options: TranspilationOptions, mostRecentPassName: string) {
  if (options.checkTrees || options.strict) {
    const success = runSanityCheck(ast, options.checkTrees ?? false);
    if (!success && options.strict) {
      throw new TranspileFailedError(
        `AST failed internal consistency check. Most recently run pass: ${mostRecentPassName}`,
      );
    }
  }
}
