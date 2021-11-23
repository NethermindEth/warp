import os
import pathlib
import shutil
from io import open
from os import environ, path

import pkg_resources
from setuptools import find_packages, setup

# The directory containing this file
HERE = pathlib.Path(__file__).parent
# The text of the README file
with open(path.join(HERE, "README.md")) as f:
    README = f.read()

# automatically captured required modules for install_requires in requirements.txt and as well as configure dependency links
with open(path.join(HERE, "requirements.txt"), encoding="utf-8") as f:
    all_reqs = f.read().split("\n")
install_requires = [
    x.strip()
    for x in all_reqs
    if ("git+" not in x) and (not x.startswith("#")) and (not x.startswith("-"))
]
dependency_links = [x.strip().replace("git+", "") for x in all_reqs if "git+" not in x]

setup(
    name="sol-warp",
    description="A Solidity to Cairo Transpiler",
    version="0.2.16",
    package_dir={"": "warp"},
    packages=[
        "cairo-src",
        "cairo-src.evm",
        "cli",
        "yul",
        "bin.linux",
        "bin.macos.10",
        "bin.macos.10.14",
        "bin.macos.11",
    ],  # list of all packages
    include_package_data=True,
    package_data={"": ["*.json", "*.cairo", "kudu"]},
    install_requires=install_requires,
    python_requires=">=3.7",  # any python greater than 3.7
    entry_points="""
        [console_scripts]
        warp=cli.warp_cli:main
    """,
    scripts=["scripts/kudu"],
    author="Nethermind",
    keyword="Ethereum, Layer2, ETH, StarkNet, Nethermind, StarkWare, transpilation, warp, transpiler, cairo",
    long_description=README,
    long_description_content_type="text/markdown",
    license="Apache 2.0",
    url="https://github.com/NethermindEth/warp",
    download_url="",
    dependency_links=dependency_links,
    author_email="hello@nethermind.io",
    classifiers=[
        "Programming Language :: Python :: 3.7",
        "License :: OSI Approved :: Apache Software License",
    ],
)
