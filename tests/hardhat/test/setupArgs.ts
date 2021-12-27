
const gnosisSetupFnArgsFromExample = {
  name: 'setup',
  params: [
    { name: '_owners', value: ["0x58F8DF58d0161800D441814a415193391F9128d6"], type: 'address[]' },
    { name: '_threshold', value: '1', type: 'uint256' },
    {
      name: 'to',
      value: '0x0000000000000000000000000000000000000000',
      type: 'address'
    },
    { name: 'data', value: null, type: 'bytes' },
    {
      name: 'fallbackHandler',
      value: '0xf48f2b2d2a534e402487b3ee7c18c33aec0fe5e4',
      type: 'address'
    },
    {
      name: 'paymentToken',
      value: '0x0000000000000000000000000000000000000000',
      type: 'address'
    },
    { name: 'payment', value: '0', type: 'uint256' },
    {
      name: 'paymentReceiver',
      value: '0x0000000000000000000000000000000000000000',
      type: 'address'
    }
  ]
}
