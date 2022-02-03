import { expect } from 'chai';
import { describe, it } from 'mocha';
import { findCairoSourceFilePaths } from '../src/io';
import { cleanupSync, starknetCompile } from './util';

const paths = findCairoSourceFilePaths('warplib', true);
describe('Warplib files should compile', function () {
  this.timeout(180000);
  for (const file of paths) {
    it(file, async function () {
      try {
        const { stderr } = await starknetCompile(file, `${file}.json`);
        expect(stderr, 'Starket-compile printed an error').to.equal('');
      } catch (e) {
        expect(false, `${e}`).to.be.true;
      }
    });

    after(function () {
      cleanupSync(`${file}.json`);
    });
  }
});
