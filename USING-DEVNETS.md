To use starknet devnet you have to export evironment variables first:

```bash
set -o allexport; source development.env; set +o allexport
```

It's a good idea to then launch the devnet with the following

```
starknet-devnet --timeout 10000 --seed 0
```
