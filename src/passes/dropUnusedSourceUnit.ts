import { ContractKind } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class DropUnusedSourceUnits extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: string[] = [
      'Tf',
      'Tnr',
      'Ru',
      'Fm',
      'Ss',
      'Ct',
      'Ae',
      'Idi',
      'L',
      'Na',
      'Ufr',
      'Fd',
      'Tic',
      'Ch',
      'M',
      'Sai',
      'Udt',
      'Req',
      'Ffi',
      'Rl',
      'Ons',
      'Ech',
      'Sa',
      'Ii',
      'Mh',
      'Pfs',
      'Eam',
      'Lf',
      'R',
      'Rv',
      'If',
      'T',
      'U',
      'V',
      'Vs',
      'I',
      'Dh',
      'Rf',
      'Abc',
      'Ec',
      'B',
      'Bc',
      'Us',
      'Fp',
      'E',
      'An',
      'Ci',
    ];
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    // Drop all source units which don't contain a deployable contract.
    ast.roots = ast.roots.filter(
      (su) =>
        su.vContracts.length > 0 &&
        su.vContracts.some((cd) => cd.kind == ContractKind.Contract && !cd.abstract),
    );
    return ast;
  }
}
