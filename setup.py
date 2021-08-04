from setuptools import setup, find_packages
from io import open
from os import path
import pathlib

# The directory containing this file
HERE = pathlib.Path(__file__).parent
# The text of the README file
with open(path.join(HERE, "README.md")) as f:
    README = f.read()

# automatically captured required modules for install_requires in requirements.txt and as well as configure dependency links
with open(path.join(HERE, 'requirements.txt'), encoding='utf-8') as f:
    all_reqs = f.read().split('\n')
install_requires = [x.strip() for x in all_reqs if ('git+' not in x) and (
    not x.startswith('#')) and (not x.startswith('-'))]
dependency_links = [x.strip().replace('git+', '') for x in all_reqs \
                    if 'git+' not in x]

setup (
 name = 'warp',
 description='Transpile EVM-Compatible Languages To Cairo',
 version='0.1.0',
 package_dir={"": "warp"},
 packages=["cairo-src", "cairo-src.evm", "cli","cli.compilation", "transpiler", "transpiler.Operations"], # list of all packages
 include_package_data=True,
 package_data={'': ['*.json', '*.cairo']},
 install_requires=install_requires,
 python_requires='>=3.7', # any python greater than 3.7
 entry_points='''
        [console_scripts]
        warp=cli.warp_cli:main
    ''',
 author="Nethermind",
 keyword="Ethereum, Layer2, ETH, StarkNet, Nethermind, StarkWare, transpilation, warp, transpiler, cairo",
 long_description=README,
 long_description_content_type="text/markdown",
 license='Apache 2.0',
 url='https://github.com/NethermindEth/warp',
 download_url='',
  dependency_links=dependency_links,
  author_email='hello@nethermind.io',
  classifiers=[
        "License :: OSI Approved :: Apache 2.0 License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
    ]
)