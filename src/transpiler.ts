import {
  CompileResult,
  ASTReader,
  compileSol,
  ASTWriter,
  PrettyFormatter,
  SourceUnit,
  CompileFailedError,
} from 'solc-typed-ast';
import { AST } from './ast/mapper';
import { CairoASTMapping } from './cairoWriter';
import {
  UnloadingAssignment,
  VariableDeclarationInitialiser,
  BuiltinHandler,
  ForLoopSimplifier,
  ReturnInserter,
  VariableDeclarationExpressionSplitter,
  StorageVariableAccessRewriter,
  ExpressionSplitter,
  LiteralExpressionEvaluator,
} from './passes';
import { ImplicitConversionToExplicit } from './passes/implicitConversionToExplicit';

export function transpile(file: string): string[] | null {
  let result: CompileResult;

  try {
    result = compileSol(file, 'auto', []);
    const reader = new ASTReader();
    const sourceUnits = reader.read(result.data);
    return sourceUnits.map((s) => transpileSourceUnit(s, result.compilerVersion));
  } catch (e) {
    if (e instanceof CompileFailedError) {
      console.log('---Compile Failed---');
      e.failures.forEach((failure) => {
        console.log(`Compiler version ${failure.compilerVersion} reported errors:`);
        failure.errors.forEach((error, index) => {
          console.log(`    --${index + 1}--`);
          const errorLines = error.split('\n');
          errorLines.forEach((line) => console.log(`    ${line}`));
        });
      });
    } else {
      console.log('Unexpected error during transpilation');
      console.log(e);
    }
    return null;
  }
}

export function transpileSourceUnit(contract: SourceUnit, compilerVersion: string): string {
  let ast = applyPasses({ ast: contract, imports: null, compilerVersion });
  const formatter = new PrettyFormatter(4, 0);
  const writer = new ASTWriter(CairoASTMapping(ast.imports), formatter, compilerVersion);
  return writer.write(ast.ast);
}

export function applyPasses(ast: AST): AST {
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
  // TODO: replace type(X).min and type(X).max with the corresponing constant value
  ast = new LiteralExpressionEvaluator().map(ast);
  ast = new UnloadingAssignment().map(ast);
  ast = new VariableDeclarationInitialiser().map(ast);
  ast = new ImplicitConversionToExplicit().map(ast);
  ast = new BuiltinHandler().map(ast);
  ast = new ForLoopSimplifier().map(ast);
  ast = new ReturnInserter().map(ast);
  ast = new VariableDeclarationExpressionSplitter().map(ast);
  ast = new StorageVariableAccessRewriter().map(ast);
  ast = new ExpressionSplitter().map(ast);
  return ast;
}
