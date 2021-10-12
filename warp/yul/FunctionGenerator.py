from typing import Iterable


class FunctionGenerator:
    def __init__(self):
        self.definitions: dict[str, str] = {}

    def create_function(self, name: str, definition: str) -> None:
        self.definitions.setdefault(name, definition)


class CairoFunctions:
    def __init__(self, generator: FunctionGenerator):
        self.generator = generator

    def get_definitions(self) -> Iterable[str]:
        return self.generator.definitions.values()

    def constant_function(self, constant: int) -> str:
        high, low = divmod(constant, 2 ** 128)
        name = f"__warp_constant_{constant}"
        self.generator.create_function(
            name,
            "\n".join(
                [
                    f"func {name}() -> (res: Uint256):",
                    f"return (Uint256(low={low}, high={high}))",
                    f"end",
                ]
            ),
        )
        return name
