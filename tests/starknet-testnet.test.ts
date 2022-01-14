import axios from 'axios';
import { expect } from 'chai';
import { describe, it } from 'mocha';

describe('Starknet testnet', function () {
  it('Should be contactable', async function () {
    const response = await axios.post('http://127.0.0.1:5000/pingpost');
    expect(response.status).equals(200);
  });
});
