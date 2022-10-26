To use starknet devnet you have to export evironment variables first:

```bash
source development.env
```

It's a good idea to then launch the devnet with the following

```
starknet-devnet --timeout 10000 --seed 0
```

And populate `~/.starknet_accounts_devnet/starknet_open_zeppelin_accounts.json`:

```
cp .starknet_accounts_devnet ~/
```
