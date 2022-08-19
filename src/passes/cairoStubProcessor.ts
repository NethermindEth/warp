import {
  ASTNode,
  ContractDefinition,
  FunctionDefinition,
  StructuredDocumentation,
} from 'solc-typed-ast';
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
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    // Only for interaction between plane cairo contract
    // To support interface call forwarder

    let documentation = getDocString(node.documentation);
    if (documentation === undefined) {
      this.commonVisit(node, ast);
      return;
    }

    if (documentation.split('\n')[0]?.trim() !== 'warp-cairo') {
      this.commonVisit(node, ast);
      return;
    }
    documentation = processDecoratorTags(documentation);

    setDocString(node, documentation);
    this.commonVisit(node, ast);
  }

  visitFunctionDefinition(node: FunctionDefinition, _ast: AST): void {
    let documentation = getDocString(node.documentation);
    if (documentation === undefined) return;

    if (documentation.split('\n')[0]?.trim() !== 'warp-cairo') return;

    documentation = processDecoratorTags(documentation);
    documentation = processStateVarTags(documentation, node);
    documentation = processInternalFunctionTag(documentation, node);
    documentation = processCurrentFunctionTag(documentation, node);
    setDocString(node, documentation);
  }
}

function processDecoratorTags(documentation: string): string {
  return processMacro(documentation, /DECORATOR\((.*?)\)/g, (s) => `@${s}`);
}

function processStateVarTags(documentation: string, node: FunctionDefinition): string {
  const contract = node.getClosestParentByType(CairoContract);
  const errorNode = node.documentation instanceof ASTNode ? node.documentation : node;
  const regex = /STATEVAR\((.*?)\)/g;
  if (contract === undefined) {
    if ([...documentation.matchAll(regex)].length > 0) {
      throw new WillNotSupportError(
        `Cairo stub macro 'STATEVAR' is only allowed in member functions`,
        errorNode,
      );
    }
    return documentation;
  }
  return processMacro(documentation, regex, (arg) => {
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
  const regex = /INTERNALFUNC\((.*?)\)/g;
  if (contract === undefined) {
    if ([...documentation.matchAll(regex)].length > 0) {
      throw new WillNotSupportError(
        `Cairo stub macro 'INTERNALFUNC' is only allowed in member function definitions`,
        errorNode,
      );
    }
    return documentation;
  }
  return processMacro(documentation, regex, (arg) => {
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

function processCurrentFunctionTag(documentation: string, node: FunctionDefinition): string {
  const contract = node.getClosestParentByType(CairoContract);
  const errorNode = node.documentation instanceof ASTNode ? node.documentation : node;
  const regex = /CURRENTFUNC\((.*?)\)/g;
  if (contract === undefined) {
    if ([...documentation.matchAll(regex)].length > 0) {
      throw new WillNotSupportError(
        `Cairo stub macro 'CURRENTFUNC' is only allowed in member function definitions`,
        errorNode,
      );
    }
    return documentation;
  }
  return processMacro(documentation, regex, (arg) => {
    if (arg !== '') {
      throw new TranspileFailedError(
        `CURRENTFUNC macro must take no arguments, "${arg}" was provided`,
      );
    }
    return node.name;
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

function setDocString(node: FunctionDefinition | ContractDefinition, docString: string): void {
  const existingDoc = node.documentation;
  if (existingDoc instanceof StructuredDocumentation) {
    existingDoc.text = docString;
  } else {
    node.documentation = docString;
  }
}
