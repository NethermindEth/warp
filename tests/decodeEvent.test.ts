import { expect } from 'chai';
import { describe, it } from 'mocha';
import { EventFragment, Indexed, Result } from 'ethers/lib/utils';
import { EventItem, WarpInterface } from '../src/export';
import { BigNumber } from 'ethers';

type decodeWarpEventTest = [string, EventFragment, EventItem, Result];

const tests: decodeWarpEventTest[] = [
  [
    'simple uint',
    EventFragment.fromObject({
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: 'uint256',
          name: '',
          type: 'uint256',
        },
      ],
      name: 'uintEvent',
      type: 'event',
    }),
    {
      data: ['0', '121912447469708518741247527551261377592096388884417708110390827889190764544'],
      keys: [
        '349140629512105025986819944934326851699370611775502968970270757025139158510',
        '416975907287698701781658210175328769735286199662646074116699063505058267136',
      ],
      order: 0,
    },
    [BigNumber.from('0x45')],
  ],
  [
    'array of uints',
    EventFragment.fromObject({
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: 'uint256[]',
          name: '',
          type: 'uint256[]',
        },
      ],
      name: 'arrayEvent',
      type: 'event',
    }),
    {
      data: [
        '0',
        '56539106072908298546665520023773392506479484700019806659891398441363832832',
        '20705239040371691362304267586831076357353326916511159665487572671397888',
        '53919893334301279589334030174039261347274288845081144962207220498432',
        '315936875005671560093754083051011296956685286201647333762932932608',
        '2056880696651507552693711478196688131228419832041974829185761280',
      ],
      keys: [
        '103604775454545769148776836029701391229091200049006496871756022599175798898',
        '139580918117492362037080502558690562750371227853173897691606889902116962304',
      ],
      order: 0,
    },
    [[BigNumber.from('0x02'), BigNumber.from('0x03'), BigNumber.from('0x05')]],
  ],
  [
    'indexed string and a string',
    EventFragment.fromObject({
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: 'string',
          name: '',
          type: 'string',
        },
        {
          indexed: false,
          internalType: 'string',
          name: '',
          type: 'string',
        },
      ],
      name: 'allStringMiscEvent',
      type: 'event',
    }),
    {
      data: [
        '0',
        '56539106072908298546665520023773392506479484700019806659891398441363832832',
        '15589905097154863132826295228152152448327635447620287684531925559541760',
        '0',
      ],
      keys: [
        '364017346052355538280200350945456388069202871296023176886449255587784672487',
        '286463740173396614665798174497148444051790859918634298639229292341387384351',
        '105548406881468092001239721401802550244334809511401721588100482954562633728',
      ],
      order: 0,
    },
    [
      new Indexed({
        _isIndexed: true,
        hash: '0x21faab852d29e39c56dc14d20d71ba15c1ea83a26f45b658b5e8d0f8d61f3bbd',
      }),
      'BC',
    ],
  ],
  [
    'anonymous event',
    EventFragment.fromObject({
      anonymous: true,
      inputs: [
        {
          indexed: false,
          internalType: 'uint256',
          name: '',
          type: 'uint256',
        },
        {
          indexed: true,
          internalType: 'uint256',
          name: '',
          type: 'uint256',
        },
      ],
      name: 'allUintMiscEventAnonymous',
      type: 'event',
    }),
    {
      data: ['0', '1766847064778384329583297500742918515827483896875618958121606201292619776'],
      keys: ['0', '3533694129556768659166595001485837031654967793751237916243212402585239552'],
      order: 4,
    },
    [BigNumber.from('0x01'), BigNumber.from('0x02')],
  ],
];

describe('Warp Event decode tests', function () {
  tests.map(([desc, eventFragment, input, output]) =>
    it(`${desc}`, () => {
      const result = new WarpInterface([eventFragment]).decodeWarpEvent(eventFragment, input);
      expect(result).to.deep.equal(output);
    }),
  );
});
