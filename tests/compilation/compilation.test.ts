import { describe } from 'mocha';
import { runTests } from '../testing';

const TIME_LIMIT = 2 * 60 * 60 * 1000;

// Compiling the solidity files using the `bin/warp transpile` CLI command.
describe('Compiling tests contracts:', function () {
  this.timeout(TIME_LIMIT);
  runTests(false, false);
});
