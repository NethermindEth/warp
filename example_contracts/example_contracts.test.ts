import { describe } from 'mocha';
import { runTests } from '../src/testing';

const TIME_LIMIT = 2 * 60 * 60 * 1000;

// Transpiling the solidity files using the `bin/warp transpile` CLI command.
describe('Transpiling example contracts:', function () {
  this.timeout(TIME_LIMIT);
  runTests(false, false);
});
