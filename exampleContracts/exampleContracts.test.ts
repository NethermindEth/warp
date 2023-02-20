import { describe } from 'mocha';
import { runTests } from '../tests/testing';

const TIME_LIMIT = 2 * 60 * 60 * 1000;

// Transpiling the solidity files using the `bin/warp transpile` CLI command.
describe('Example contracts transpilation', function () {
  this.timeout(TIME_LIMIT);

  it('should output in expected transpilation results', async function () {
    await runTests(false, false);
  });
});
