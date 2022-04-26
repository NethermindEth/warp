import { AST } from '../ast/ast';
import {
  Identifier,
  FunctionCallKind,
  FunctionCall,
  FunctionDefinition,
  Expression,
  VariableDeclaration,
  Return,
  TupleExpression,
} from 'solc-typed-ast';
import { getFunctionTypeString, getReturnTypeString } from './getTypeString';
import { createIdentifier } from './nodeTemplates';

export function generateFunctionCall(
  functionDef: FunctionDefinition,
  argList: Expression[],
  ast: AST,
): FunctionCall {
  return new FunctionCall(
    ast.reserveId(),
    '',
    getReturnTypeString(functionDef),
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      getFunctionTypeString(functionDef, ast.compilerVersion),
      functionDef.name,
      functionDef.id,
    ),
    argList,
  );
}

export function createReturn(
  declarations: VariableDeclaration[],
  retParamListId: number,
  ast: AST,
): Return {
  const returnIdentifiers = declarations.map((d) => createIdentifier(d, ast));
  const retValue = toSingleExpression(returnIdentifiers, ast);
  return new Return(ast.reserveId(), '', retParamListId, retValue);
}

export function toSingleExpression(expressions: Expression[], ast: AST): Expression {
  if (expressions.length === 1) return expressions[0];

  return new TupleExpression(
    ast.reserveId(),
    '',
    `tuple(${expressions.map((e) => e.typeString).join(',')})`,
    false,
    expressions,
  );
}
