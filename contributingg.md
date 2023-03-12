
### First steps :feet:

If you like to contribute, the first step is to install Warp from source for devs [steps here](#warp-installation-method-2-from-sourcefor-devs)

To look what features we are currently working on or tasks that are pending to do, please checkout the project on github [here](https://github.com/orgs/NethermindEth/projects/30/views/3)

Also, please take a look through our [Contribution Guidelines](CONTRIBUTING.md)

### Developing tips :honey_pot:

While developing your code, remembering to compile the project every time some minor changes are applied could be annoying. You could start a process that watch for changes and automatically recompile it.

In a separate terminal execute:

```bash
yarn dev
```

Developers could run warp instructions using docker. This is an example using `transpile` command:

```bash
docker-compose exec warp npx ts-node src transpile example_contracts/ERC20.sol
```
