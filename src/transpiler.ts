import { ASTWriter, CompileFailedError, PrettyFormatter } from 'solc-typed-ast';
import { PrintOptions, TranspilationOptions } from '.';
import { AST } from './ast/ast';
import { ASTMapper } from './ast/mapper';
import { CairoASTMapping } from './cairoWriter';
import {
  ABIExtractor,
  AnnotateImplicits,
  ArgBoundChecker,
  BuiltinHandler,
  BytesConverter,
  CairoUtilImporter,
  ConstantHandler,
  DeleteHandler,
  DropUnusedSourceUnits,
  EnumConverter,
  ExpressionSplitter,
  ExternalArgModifier,
  ExternalContractHandler,
  FreeFunctionInliner,
  FunctionPruner,
  FunctionTypeStringMatcher,
  IdentifierMangler,
  IdentityFunctionRemover,
  IfFunctionaliser,
  ImplicitConversionToExplicit,
  ImportDirectiveIdentifier,
  InheritanceInliner,
  TypeInformationCalculator,
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
  StaticArrayIndexer,
  StorageAllocator,
  TupleAssignmentSplitter,
  TupleFixes,
  TypeNameRemover,
  TypeStringsChecker,
  UnloadingAssignment,
  UnreachableStatementPruner,
  UserDefinedTypesConverter,
  UsingForResolver,
  VariableDeclarationExpressionSplitter,
  VariableDeclarationInitialiser,
  dumpABI,
} from './passes';
import { FilePathMangler } from './passes/filePathMangler';
import { Require } from './passes/builtinHandler/require';
import { OrderNestedStructs } from './passes/orderNestedStructs';
import { CairoToSolASTWriterMapping } from './solWriter';
import { DefaultASTPrinter } from './utils/astPrinter';
import { createPassMap, parsePassOrder } from './utils/cliOptionParsing';
import { TranspilationAbandonedError, TranspileFailedError } from './utils/errors';
import { error, removeExcessNewlines } from './utils/formatting';
import { printCompileErrors, runSanityCheck } from './utils/utils';

type CairoSource = [file: string, source: string, solABI: string];

export function transpile(ast: AST, options: TranspilationOptions & PrintOptions): CairoSource[] {
  const cairoAST = applyPasses(ast, options);
  const writer = new ASTWriter(
    CairoASTMapping(cairoAST, options.strict ?? false),
    new PrettyFormatter(4, 0),
    ast.compilerVersion,
  );
  return cairoAST.roots.map((sourceUnit) => [
    sourceUnit.absolutePath,
    writer.write(sourceUnit),
    dumpABI(sourceUnit, cairoAST),
  ]);
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
    dumpABI(sourceUnit, cairoAST),
  ]);
}

function applyPasses(ast: AST, options: TranspilationOptions & PrintOptions): AST {
  const passes: Map<string, typeof ASTMapper> = createPassMap([
    ['Tf', TupleFixes],
    ['Tnr', TypeNameRemover],
    ['Ru', RejectUnsupportedFeatures],
    ['Fm', FilePathMangler],
    ['Ss', SourceUnitSplitter],
    ['Ct', TypeStringsChecker],
    ['Ae', ABIExtractor],
    ['Idi', ImportDirectiveIdentifier],
    ['L', LiteralExpressionEvaluator],
    ['Na', NamedArgsRemover],
    ['Ufr', UsingForResolver],
    ['Fd', FunctionTypeStringMatcher],
    ['Gp', PublicStateVarsGetterGenerator],
    ['Tic', TypeInformationCalculator],
    ['Ch', ConstantHandler],
    ['M', IdentifierMangler],
    ['Sai', StaticArrayIndexer],
    ['Udt', UserDefinedTypesConverter],
    ['Req', Require],
    ['Ffi', FreeFunctionInliner],
    ['Rl', ReferencedLibraries],
    ['Ons', OrderNestedStructs],
    ['Ech', ExternalContractHandler],
    ['Sa', StorageAllocator],
    ['Ii', InheritanceInliner],
    ['Mh', ModifierHandler],
    ['Pfs', PublicFunctionSplitter],
    ['Eam', ExternalArgModifier],
    ['Lf', LoopFunctionaliser],
    ['R', ReturnInserter],
    ['Rv', ReturnVariableInitializer],
    ['If', IfFunctionaliser],
    ['Ifr', IdentityFunctionRemover],
    ['T', TupleAssignmentSplitter],
    ['U', UnloadingAssignment],
    ['V', VariableDeclarationInitialiser],
    ['Vs', VariableDeclarationExpressionSplitter],
    ['I', ImplicitConversionToExplicit],
    ['Dh', DeleteHandler],
    ['Rf', References],
    ['Abc', ArgBoundChecker],
    ['Ec', EnumConverter],
    ['B', BuiltinHandler],
    ['Bc', BytesConverter],
    ['Us', UnreachableStatementPruner],
    ['Fp', FunctionPruner],
    ['E', ExpressionSplitter],
    ['An', AnnotateImplicits],
    ['Ci', CairoUtilImporter],
    ['Dus', DropUnusedSourceUnits],
  ]);

  const passesInOrder: typeof ASTMapper[] = parsePassOrder(options.order, options.until, passes);
  DefaultASTPrinter.applyOptions(options);

  printPassName('Input', options);
  printAST(ast, options);

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
      const success = runSanityCheck(ast, options.checkTrees ?? false, mostRecentPassName);
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
