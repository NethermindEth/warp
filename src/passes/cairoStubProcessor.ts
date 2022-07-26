import { ASTNode, FunctionDefinition, StructuredDocumentation } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoContract } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import {
  TranspilationAbandonedError,
  TranspileFailedError,
  WillNotSupportError,
} from '../utils/errors';
import { isExternallyVisible } from '../utils/utils';

export class CairoStubProcessor extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, _ast: AST): void {
    let documentation = getDocString(node.documentation);
    if (documentation === undefined) return;

    if (documentation.split('\n')[0]?.trim() !== 'warp-cairo') return;

    documentation = processDecoratorTags(documentation);
    documentation = processStateVarTags(documentation, node);
    documentation = processInternalFunctionTag(documentation, node);
    documentation = processLibraryFunctionTag(documentation, node);
    setDocString(node, documentation);
  }
}

function processDecoratorTags(documentation: string): string {
  return processMacro(documentation, /DECORATOR\((.*?)\)/g, (s) => `@${s}`);
}

function processStateVarTags(documentation: string, node: FunctionDefinition): string {
  const contract = node.getClosestParentByType(CairoContract);
  const errorNode = node.documentation instanceof ASTNode ? node.documentation : node;
  if (contract === undefined) {
    throw new WillNotSupportError(
      `Cairo stub macro 'STATEVAR' is only allowed in member functions`,
      errorNode,
    );
  }
  return processMacro(documentation, /STATEVAR\((.*?)\)/g, (arg) => {
    const stateVarNames = contract.vStateVariables.map((decl) => decl.name);
    const matchingStateVars = stateVarNames.filter((name) => {
      return name.replace(/__warp_usrid[0-9]+_/, '') === arg;
    });
    if (matchingStateVars.length === 0) {
      throw new TranspilationAbandonedError(`Unable to find matching statevar ${arg}`, errorNode);
    } else if (matchingStateVars.length === 1) {
      return matchingStateVars[0];
    } else {
      throw new TranspileFailedError(
        `Unable to pick between multiple state vars matching ${arg}`,
        errorNode,
      );
    }
  });
}

function processInternalFunctionTag(documentation: string, node: FunctionDefinition): string {
  const contract = node.getClosestParentByType(CairoContract);
  const errorNode = node.documentation instanceof ASTNode ? node.documentation : node;
  if (contract === undefined) {
    throw new WillNotSupportError(
      `Cairo stub macro 'INTERNALFUNC' is only allowed in member function definitions`,
      errorNode,
    );
  }
  return processMacro(documentation, /INTERNALFUNC\((.*?)\)/g, (arg) => {
    const funcNames = contract.vFunctions.filter((f) => !isExternallyVisible(f)).map((f) => f.name);
    const matchingFuncs = funcNames.filter((name) => {
      return name.replace(/__warp_usrfn[0-9]+_/, '') === arg;
    });
    if (matchingFuncs.length === 0) {
      throw new TranspilationAbandonedError(
        `Unable to find matching internal function ${arg}`,
        errorNode,
      );
    } else if (matchingFuncs.length === 1) {
      return matchingFuncs[0];
    } else {
      throw new TranspileFailedError(
        `Unable to pick between multiple internal functions matching ${arg}`,
        errorNode,
      );
    }
  });
}

function processLibraryFunctionTag(documentation: string, node: FunctionDefinition): string {
  const contract = node.getClosestParentByType(CairoContract);
  const errorNode = node.documentation instanceof ASTNode ? node.documentation : node;
  if (contract === undefined) {
    throw new WillNotSupportError(
      `Cairo stub macro 'LIBRARYFUNC' is only allowed in member function definitions`,
      errorNode,
    );
  }
  return processMacro(documentation, /LIBRARYFUNC\((.*?)\)/g, (arg) => {
    const funcName = node.name;
    if (funcName.replace(/(s[0-9]+_)__warp_usrfn[0-9]+_/, '') !== arg) {
      throw new TranspileFailedError(
        `Library function name ${node.name} should match ${arg}`,
        errorNode,
      );
    }
    return funcName;
  });
}

function processMacro(
  documentation: string,
  regex: RegExp,
  func: (capture: string) => string,
): string {
  const macros = [...documentation.matchAll(regex)];
  return macros.reduce((docString, matchArr) => {
    const fullMacro = matchArr[0];
    const argument = matchArr[1];
    return docString.replace(fullMacro, func(argument));
  }, documentation);
}

function getDocString(doc: StructuredDocumentation | string | undefined): string | undefined {
  if (doc === undefined) return undefined;
  if (typeof doc === 'string') return doc;
  return doc.text;
}

function setDocString(node: FunctionDefinition, docString: string): void {
  const existingDoc = node.documentation;
  if (existingDoc instanceof StructuredDocumentation) {
    existingDoc.text = docString;
  } else {
    node.documentation = docString;
  }
}
