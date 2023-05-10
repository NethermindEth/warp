import { expect } from 'chai';
import { describe, it } from 'mocha';
import path from 'path';
import { cairoTest, SafePromise, wrapPromise } from './util';

describe('Warplib files should compile and execute correctly', function () {
  this.timeout(1800000);

  let compileResult: SafePromise<{ stderr: string }>;
  before(function () {
    compileResult = wrapPromise(cairoTest(path.resolve(__dirname, '..', 'warplib')));
  });

  it('warplib unit test', async function () {
    try {
      const { success, result } = await compileResult;
      expect(result, 'cairo-test printed errors').to.include({ stderr: '' });
      expect(success).to.be.true;
    } catch (e) {
      expect(false, `${e}`).to.be.true;
    }
  });
});
