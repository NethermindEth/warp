import { ASTWriter, CompileFailedError, PrettyFormatter } from 'solc-typed-ast';
import { PrintOptions, TranspilationOptions } from '.';
import { AST } from './ast/ast';
import { ASTMapper } from './ast/mapper';
import { CairoASTMapping } from './cairoWriter';
import {
  AnnotateImplicits,
  BuiltinHandler,
  BytesConverter,
  CairoUtilImporter,
  ConditionalFunctionaliser,
  ConstantHandler,
  DeleteHandler,
  EnumConverter,
  ExpressionSplitter,
  ExternalArgumentModifier,
  ExternalContractHandler,
  ExternalInputChecker,
  ExternImporter,
  FreeLibraryCallInliner,
  IdentifierMangler,
  IfFunctionaliser,
  ImplicitConversionToExplicit,
  ImportDirectiveIdentifier,
  InheritanceInliner,
  IntBoundCalculator,
  LiteralExpressionEvaluator,
  LoopFunctionaliser,
  ModifierHandler,
  NamedArgsRemover,
  PublicFunctionSplitter,
  PublicStateVarsGetterGenerator,
  ReferencedLibraries,
  References,
  RejectUnsupportedFeatures,
  ReturnInserter,
  ReturnVariableInitializer,
  SourceUnitSplitter,
  StorageAllocator,
  TupleAssignmentSplitter,
  UnloadingAssignment,
  UnreachableStatementPruner,
  UserDefinedTypesConverter,
  UsingForResolver,
  VariableDeclarationExpressionSplitter,
  VariableDeclarationInitialiser,
} from './passes';
import { CairoToSolASTWriterMapping } from './solWriter';
import { DefaultASTPrinter } from './utils/astPrinter';
import { createPassMap, parsePassOrder } from './utils/cliOptionParsing';
import { TranspilationAbandonedError, TranspileFailedError } from './utils/errors';
import { error, removeExcessNewlines } from './utils/formatting';
import { printCompileErrors, runSanityCheck } from './utils/utils';

type CairoSource = [file: string, source: string];

export function transpile(ast: AST, options: TranspilationOptions & PrintOptions): CairoSource[] {
  const cairoAST = applyPasses(ast, options);
  const writer = new ASTWriter(
    CairoASTMapping(cairoAST, options.strict ?? false),
    new PrettyFormatter(4, 0),
    ast.compilerVersion,
  );
  return cairoAST.roots.map((sourceUnit) => [sourceUnit.absolutePath, writer.write(sourceUnit)]);
}

export function transform(ast: AST, options: TranspilationOptions & PrintOptions): CairoSource[] {
  const cairoAST = applyPasses(ast, options);
  const writer = new ASTWriter(
    CairoToSolASTWriterMapping(!!options.stubs),
    new PrettyFormatter(4, 0),
    ast.compilerVersion,
  );
  return cairoAST.roots.map((sourceUnit) => [
    sourceUnit.absolutePath,
    removeExcessNewlines(writer.write(sourceUnit), 2),
  ]);
}

function applyPasses(ast: AST, options: TranspilationOptions & PrintOptions): AST {
  const passes: Map<string, typeof ASTMapper> = createPassMap([
    ['Ss', SourceUnitSplitter],
    ['Idi', ImportDirectiveIdentifier],
    ['Ru', RejectUnsupportedFeatures],
    ['L', LiteralExpressionEvaluator],
    ['Ufr', UsingForResolver],
    ['Na', NamedArgsRemover],
    ['Udt', UserDefinedTypesConverter],
    ['Gp', PublicStateVarsGetterGenerator],
    ['Ib', IntBoundCalculator],
    ['Ch', ConstantHandler],
    ['M', IdentifierMangler],
    ['Fi', FreeLibraryCallInliner],
    ['Rl', ReferencedLibraries],
    ['Ii', InheritanceInliner],
    ['Ech', ExternalContractHandler],
    ['Mh', ModifierHandler],
    ['Sa', StorageAllocator],
    ['Pfs', PublicFunctionSplitter],
    ['Eam', ExternalArgumentModifier],
    ['Ei', ExternImporter],
    ['Lf', LoopFunctionaliser],
    ['R', ReturnInserter],
    ['Rv', ReturnVariableInitializer],
    ['If', IfFunctionaliser],
    ['C', ConditionalFunctionaliser],
    ['T', TupleAssignmentSplitter],
    ['U', UnloadingAssignment],
    ['V', VariableDeclarationInitialiser],
    ['Vs', VariableDeclarationExpressionSplitter],
    ['Rf', References],
    ['Bc', BytesConverter],
    ['Eic', ExternalInputChecker],
    ['Ec', EnumConverter],
    ['Dh', DeleteHandler],
    ['I', ImplicitConversionToExplicit],
    ['B', BuiltinHandler],
    ['Us', UnreachableStatementPruner],
    ['E', ExpressionSplitter],
    ['An', AnnotateImplicits],
    ['Ci', CairoUtilImporter],
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
    try {
      const success = runSanityCheck(ast, options.checkTrees ?? false);
      if (!success && options.strict) {
        throw new TranspileFailedError(
          `AST failed internal consistency check. Most recently run pass: ${mostRecentPassName}`,
        );
      }
    } catch (e) {
      console.error(
        error(
          `AST failed internal consistency check. Most recently run pass: ${mostRecentPassName}`,
        ),
      );
      throw e;
    }
  }
}
