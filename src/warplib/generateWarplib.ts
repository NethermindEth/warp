import { generateFile, WarplibFunctionInfo } from './utils';
import { warplibFunctions } from './getWarplibImports';

warplibFunctions.forEach((warpFunc: WarplibFunctionInfo) => generateFile(warpFunc));
