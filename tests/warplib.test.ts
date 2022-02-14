import { expect } from 'chai';
import { describe, it } from 'mocha';
import { findCairoSourceFilePaths } from '../src/io';
import { cleanupSync, SafePromise, starknetCompile, wrapPromise } from './util';

const paths = findCairoSourceFilePaths('warplib', true);
describe('Warplib files should compile', function () {
  this.timeout(1800000);

  let compileResults: SafePromise<{ stderr: string }>[];

  before(function () {
    compileResults = paths.map((file) => wrapPromise(starknetCompile(file, `${file}.json`)));
  });

  for (let i = 0; i < paths.length; ++i) {
    it(paths[i], async function () {
      try {
        const { success, result } = await compileResults[i];
        expect(result, 'starknet-compile printed errors').to.include({ stderr: '' });
        expect(success).to.be.true;
      } catch (e) {
        expect(false, `${e}`).to.be.true;
      }
    });

    after(function () {
      cleanupSync(`${paths[i]}.json`);
    });
  }
});
