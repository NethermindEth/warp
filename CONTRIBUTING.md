# Contributing

You can contribute to Warp by raising issues and PRs. Simply filing issues for problems you encounter is a great way to contribute. Contributing implementations is greatly appreciated.

## DOs and DON'Ts

Please do:

* **DO** give priority to the current style of the project or file you're changing even if it diverges from the general guidelines.
* **DO** include tests for both, new features and bug fixes
* **DO** keep the discussions focused on the initial topic

Please do not:

* **DON'T** raise PRs with style changes
* **DON'T** surprise us with big pull requests. It's better to first raise it as an issue and have it discussed
* **DON'T** commit code that you didn't author. This may breach IP
* **DON'T** submit PRs that alter licensing, contributing guide lines or code of conduct

## PR - CI Process

The project uses GitHub Actions to build its artifacts and run tests. We do our best to keep the suite fast and stable. For incoming PRs, builds and test runs must be clean.

## Implementing opcodes

The implementation of each opcode goes into the [Operations](https://github.com/NethermindEth/warp/tree/main/warp/transpiler/Operations) folder.

You need to create a class that implements the opcode behavior.

Let's take a look at the implementation of the `JUMPI` opcode, which you can find [here](warp/transpiler/Operations/Jumping.py):

```python
class JumpI(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        b = state.stack.pop()
        return_instructions = state.make_return_instructions(a)
        return [
            f"let (immediate) = uint256_eq{{range_check_ptr=range_check_ptr}}({b}, Uint256(0, 0))",
            "if immediate == 0:",
            *return_instructions,
            "end",
        ]

    def required_imports(self):
        return {UINT256_MODULE: {"uint256_eq"}}
```

Notice that the `JumpI` class inherits from `Operation` (you can find it [here](warp/transpiler/Operation.py)), the most important class that you should know about, since it contains the general implementation of the opcodes; and among its members, the `proceed` method. This method should return the set of cairo instructions that implement the behavior of the opcode.

If in such instructions you use an element that must be imported into the cairo code (the `uint256_eq` function in this case), you must also overwrite the `required_imports` method.

Many times you have opcodes that perform operations with values ​​stored on the stack and it is convenient, as a form of optimization, in cases where these values ​​are known, to perform the operation directly in the python code instead of writing the corresponding instructions in cairo. For this reason, there is also the `EnforcedStack` class (see [EnforcedStack](warp/transpiler/Operations/EnforcedStack.py)), through which it would only be necessary to implement the following functions:

* `evaluate_eagerly`, in case you can perform the operation as mentioned above
* `generate_cairo_code`, in case the values ​​are not known

Likewise, some specializations of this class were implemented such as: [Unary](warp/transpiler/Operations/Unary.py), [Binary](warp/transpiler/Operations/Binary.py), [Ternary](warp/transpiler/Operations/Ternary.py) (see also [SimpleBinary](warp/transpiler/Operations/Binary.py)), in terms of the amount of elements that are popped from the stack and the fact that they are also responsible for pushing the result to it. As an example of the usage of these classes let's take the `DIV` opcode implementation:

```python
class Div(Binary):
    def evaluate_eagerly(self, a, b):
        return a // b if b != 0 else 0

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256, _) = uint256_unsigned_div_rem({op1}, {op2})"
        ]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_unsigned_div_rem"}}
```

After all this, once you have your class implemented, you will need to add the test cases that you consider relevant (at least one).
