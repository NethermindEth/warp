# Get around unsupported features.

There is no algorithm to get around unsupported features, in most scenarios it is necessary to understand what the piece of code is doing. There are some unsupported features that are impossible to rewrite right now, understanding what it is expected to do when translated to Cairo may indicate that the logic can just be removed.

## Unsupported features that can not be resolved.

- Function gasleft(): No way to go around it, but in most cases won't be needed.
- Try/Catch: Rewrite the logic using solidity
- Nested tuple expressions: Should be rewritten using solidity to flat it
- TypeName expressions: No equivalent in Cairo
- msg.value, msg.sig, msg.data: No equivalent in Cairo so far
- tx.gasprice, tx.origin: No equivalent in Cairo so far
- Member access of block(block.gaslimit, block.chainid): No equivalent in Cairo. Most of the time won't be needed.
- User defined Errors: No equivalent in Cairo for now.
- Receive function: StarkNet doesn't have a native currency for the protocol so should be rewritten using other approach
- Function call options e.g x.f{gas: 10000}(arg1): Most of the options passed are not compatible with Cairo so in most cases can be just removed

## Unsupported features that developer can get around.

- Indexed parameters in events: In this case the index keyword can just be removed
- Fallback functions with arguments: Must be removed or transformed into a fallback function that receives no parameters
- Yul blocks: If efficiency is needed then a way to go is Cairo Stubs otherwise may be rewritten with solidity. Sometimes yul blocks are all about arithmetic, these cases are to avoid overflow and underflow errors. Writing that code with solidity enclosed in an unchecked block should be enough.
- Delegate Call / Low Level Call: Cairo Stubs are a way to think about or just replace them with high-level cross-contract calls using interfaces.
- Dynamic Arrays inside structs: These can be converted to static arrays or perhaps don't use the struct at all. Dynamic Arrays work fine if they are not contained in a struct so perhaps removing the struct is the best approach.
- Member access of address (address.balance): To get balance you may have to use the Wrapped ETH token that works as currency for Cairo
