from pathlib import Path

from setuptools import find_packages, setup

HERE = Path(__file__).parent.resolve()
WARP_PKG = HERE / "src" / "warp"
README = (HERE / "README.md").read_text(encoding="utf-8")
REQUIREMENTS = (HERE / "requirements.txt").read_text(encoding="utf-8").split()

install_requires = [x.strip() for x in REQUIREMENTS if not x.startswith("#")]


def glob_in_warp(glob: str):
    yield from (str(x.relative_to(WARP_PKG)) for x in WARP_PKG.glob(glob))


setup(
    name="sol-warp",
    description="A Solidity to Cairo Transpiler",
    version="0.2.12",
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    package_data={
        "warp": [
            *glob_in_warp("cairo-src/**/*.cairo"),
            *glob_in_warp("bin/**/kudu"),
        ]
    },
    install_requires=install_requires,
    python_requires=">=3.7",  # any python greater than 3.7
    entry_points="""
        [console_scripts]
        warp=warp.cli.cli:main
    """,
    scripts=["scripts/kudu"],
    keyword="Ethereum, Layer2, ETH, StarkNet, Nethermind, StarkWare, transpilation, warp, transpiler, cairo",
    long_description=README,
    long_description_content_type="text/markdown",
    license="Apache 2.0",
    url="https://github.com/NethermindEth/warp",
    author="Nethermind",
    author_email="hello@nethermind.io",
    classifiers=[
        "Programming Language :: Python :: 3.7",
        "License :: OSI Approved :: Apache Software License",
    ],
)
