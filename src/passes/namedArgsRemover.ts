import { ASTMapper } from '../ast/mapper';
import { AST } from '../ast/ast';

import {
  ErrorDefinition,
  EventDefinition,
  FunctionCall,
  FunctionDefinition,
  StructDefinition,
} from 'solc-typed-ast';

import { NotSupportedYetError, TranspileFailedError, WillNotSupportError } from '../utils/errors';

export class NamedArgsRemover extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'Tf',
      'Tnr',
      'Ru',
      'Fm',
      'Ss',
      'Ct',
      'Ae',
      'Idi',
      'L',
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    /*
      Visit every function call and remove the named arguments
    */
    if (!node.fieldNames || !node.vReferencedDeclaration) {
      return this.visitExpression(node, ast);
    }

    const fieldNames: string[] = node.fieldNames;
    let orderedFieldNames: string[];

    if (node.vReferencedDeclaration instanceof StructDefinition) {
      /*
        If the function call is a struct constructor,
        the field names are in the order of the struct fields.
      */
      orderedFieldNames = node.vReferencedDeclaration.vMembers.map((member) => member.name);
    } else if (
      node.vReferencedDeclaration instanceof FunctionDefinition ||
      node.vReferencedDeclaration instanceof EventDefinition ||
      node.vReferencedDeclaration instanceof ErrorDefinition
    ) {
      orderedFieldNames = node.vReferencedDeclaration.vParameters.vParameters.map(
        (param) => param.name,
      );
    } else {
      /*
        Solidity CAN TECHNICALLY allow to call getter functions 
        for a public state variables using named Arguments but
        there is no way for users to do that.
      */
      if (
        node.vReferencedDeclaration.stateVariable &&
        node.vReferencedDeclaration.visibility === 'public'
      ) {
        throw new WillNotSupportError(
          'NamedArgsRemover: getter function for a public state variable',
        );
      }
      throw new NotSupportedYetError(
        `Named argument not supported for: ${node.vReferencedDeclaration?.constructor.name}`,
      );
    }

    orderedFieldNames = orderedFieldNames.filter((name) => fieldNames.includes(name));

    if (
      orderedFieldNames.length !== node.vArguments.length ||
      fieldNames.length !== orderedFieldNames.length
    ) {
      throw new TranspileFailedError(
        'Number of arguments must less or euqal to number of function field names',
      );
    }

    orderedFieldNames.forEach((fieldName, index) => {
      //find the index of the field name in the fieldNames array
      const fieldNameIndex = fieldNames.findIndex((name) => name === fieldName);
      //if the index is not found, throw an error
      if (fieldNameIndex === -1) {
        throw new TranspileFailedError(
          `Field name not found: ${fieldName} in ${node.vReferencedDeclaration?.constructor.name}`,
        );
      }
      //swap the objects at the index of the field name and the index of the argument
      [node.vArguments[fieldNameIndex], node.vArguments[index]] = [
        node.vArguments[index],
        node.vArguments[fieldNameIndex],
      ];
      //swap the names at the index of the field name and the index of the field name
      [fieldNames[fieldNameIndex], fieldNames[index]] = [
        fieldNames[index],
        fieldNames[fieldNameIndex],
      ];
    });

    node.fieldNames = undefined;
    return this.visitExpression(node, ast);
  }
}
