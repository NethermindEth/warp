Here are some useful env variables to have set if you are targeting a local StarkNet devnet

> **_NOTE:_** `GATEWAY_URL` and `FEEDER_GATEWAY_URL` don't work (Cairo 0.10.0, 0.10.1) and therefore have to be passed via command line arguments.

```
export STARKNET_NETWORK=alpha-goerli
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount

export GATEWAY_URL=http://localhost:5050
export FEEDER_GATEWAY_URL=http://localhost:5050
export STARKNET_ACCOUNT_DIR=~/.starknet_accounts_devnet
```

It's a good idea to then launch the devnet with the following

```
starknet-devnet --timeout 10000 --seed 0
```

And populate `~/.starknet_accounts_devnet/starknet_open_zeppelin_accounts.json` with

```
{
    "alpha-goerli": {
        "__default__": {
            "private_key": "0xe3e70682c2094cac629f6fbed82c07cd",
            "public_key": "0x7e52885445756b313ea16849145363ccb73fb4ab0440dbac333cf9d13de82b9",
            "address": "0x7e00d496e324876bbc8531f2d9a82bf154d1a04a50218ee74cdd372f75a551a"
        }
    }
}
```
