import {
  ContractDefinition,
  CompileResult,
  ASTReader,
  compileSol,
  ASTWriter,
  PrettyFormatter,
  LatestCompilerVersion,
  SourceUnit,
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

export function transpile(file: string): string[] | null {
  let result: CompileResult;

  try {
    result = compileSol(file, 'auto', []);
    const reader = new ASTReader();
    const sourceUnits = reader.read(result.data);
    return sourceUnits.map((s) => transpileSourceUnit(s, result.compilerVersion));
  } catch (e) {
    console.log(e);
    return null;
  }
}

export function transpileSourceUnit(contract: SourceUnit, version: string): string {
  let ast = applyPasses({ ast: contract, imports: null });
  const formatter = new PrettyFormatter(4, 0);
  const writer = new ASTWriter(CairoASTMapping(ast.imports), formatter, version);
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
  ast = new BuiltinHandler().map(ast);
  ast = new ForLoopSimplifier().map(ast);
  ast = new ReturnInserter().map(ast);
  ast = new VariableDeclarationExpressionSplitter().map(ast);
  ast = new StorageVariableAccessRewriter().map(ast);
  ast = new ExpressionSplitter().map(ast);
  return ast;
}
