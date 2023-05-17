import { expect } from 'chai';
import { describe, it } from 'mocha';
import path from 'path';
import { BASE_PATH } from '../src/export';
import { cairoTest, SafePromise, wrapPromise } from './util';

describe('Warplib files should compile and execute correctly', function () {
  this.timeout(1800000);

  it('warplib unit test', async function () {
    const compileResult: SafePromise<{ stderr: string }> = wrapPromise(
      cairoTest(path.resolve(BASE_PATH, 'warplib')),
    );

    try {
      const { success, result } = await compileResult;
      expect(result, 'cairo-test printed errors').to.include({ stderr: '' });
      expect(success).to.be.true;
    } catch (e) {
      expect(false, `${e}`).to.be.true;
    }
  });
});
