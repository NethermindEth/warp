from __future__ import annotations
import abc
from enum import Enum
import os, sys
import subprocess
from vyper.cli.vyper_compile import compile_files


class ContractLang(Enum):
    SOL = 0
    VYPER = 1


class Compile:
    def __init__(self, file_path):
        if file_path.endswith("vy"):
            self.lang = ContractLang.VYPER
        elif file_path.endswith("sol"):
            self.lang = ContractLang.SOL
        else:
            raise Exception("This contract language not supported... YET")


class Vyper(Compile):
    def __init__(self):
        self.lang = ContractLang.VYPER
        self.path = self.get_compiler_dir()
        self.version = self.get_compiler_ver(self.path)
        # self.bytecode = compile_files([file_path], ["bytecode_runtime"])

    def get_compiler_dir(self):
        return (
            subprocess.run(["which", "vyper"], stdout=subprocess.PIPE)
            .stdout.decode("utf-8")
            .strip()
        )

    def get_compiler_ver(self, vyper_path):
        vy_ver = (
            subprocess.run(
                [sys.executable, vyper_path, "--version"], stdout=subprocess.PIPE
            )
            .stdout.decode("utf-8")
            .strip()
        )
        return vy_ver[: vy_ver.find("+")]

    def install_compiler_version(self, version):
        subprocess.check_call(
            [sys.executable, "-m", "pip", "install", f"vyper=={version}"]
        )
        self.version = version

    def compile_contract(self, file_path):
        with open(file_path) as f:
            code = f.read()
            f.seek(0)
            code_split = "\n".join(
                [line.strip() for line in f.read().split("\n") if line.strip()]
            ).split("\n")
        source_ver = code_split[0]
        source_ver = source_ver[source_ver.find("0") :].strip()
        if source_ver != self.version:
            self.install_compiler_version(source_ver)
        self.compiled = compile_files([file_path], ["bytecode_runtime"])
        self.bytecode = self.compiled[file_path]["bytecode_runtime"][2:]

class Solidity(Compile):
    def __init__(self):
        self.name = "SOLIDITEEE"


WARP_ROOT = os.path.abspath(os.path.join(__file__, "../../.."))
pth = os.path.join(WARP_ROOT, "tests", "utils", "yearn.vy")
a = Vyper()
a.compile_contract(pth)
