from __future__ import annotations
from collections import OrderedDict
import os, sys
import json
import subprocess
from typing import List
from semantic_version import Version
from vyper.cli.vyper_compile import compile_files
from web3 import Web3

WARP_ROOT = os.path.abspath(os.path.join(__file__, "../../../.."))
sys.path.append(os.path.join(WARP_ROOT, "src"))
from cli.compilation.utils import get_selectors, get_selector_jumpdests, is_entry_seq, is_payable_check_seq
from cli.compilation.Disasm import InstructionIterator
from cli.compilation.Contract import Contract, Language
import solcx


def get_payable_increment(lang):
    if lang is Language.SOL:
        return 10
    else:
        return 0


def optimize_payable(contract):
    increment = get_payable_increment(contract.lang)
    idx = 0
    while True:
        if idx + increment >= len(contract.opcodes):
            break
        seq = contract.opcodes[idx : idx + increment]
        is_payable_seq = is_payable_check_seq(seq, contract.lang)
        if is_payable_seq:
            contract.opcodes[idx : idx + increment] = [
                "NOOP" for i in range(increment)
            ]
            idx += increment
            continue
        idx += 1
    return contract.opcodes


class Vyper(Contract):
    def __init__(self, source_path):
        self.w3 = Web3()
        self.lang = Language.VYPER
        self.compiler_path = self.get_compiler_dir()
        self.source_path = source_path
        self.source_name = os.path.basename(source_path)
        self.source_base_dir = os.path.dirname(self.source_path)
        self.version = self.get_compiler_ver(self.compiler_path)
        self.code = self.get_code(self.source_path)
        self.bytecode = self.get_bytecode(self.source_path)
        self.abi = self.get_abi(self.source_path)
        self.selectors = get_selectors(self.abi, self.source_base_dir)
        self.opcodes = self.get_opcodes()
        self.opcodes_str = self.get_opcode_str(self.opcodes)
        self.selector_jumpdests = get_selector_jumpdests(self, self.source_base_str)
        self.web3_interface = self.w3.eth.contract(abi=self.abi, bytecode=self.bytecode)

    def get_compiler_dir(self) -> str:
        return (
            subprocess.run(["which", "vyper"], stdout=subprocess.PIPE)
            .stdout.decode()
            .strip()
        )

    def get_compiler_ver(self, vyper_path: str) -> str:
        vy_ver = (
            subprocess.run(
                [sys.executable, vyper_path, "--version"], stdout=subprocess.PIPE
            )
            .stdout.decode()
            .strip()
        )
        return vy_ver[: vy_ver.find("+")]

    def install_compiler_version(self, version: str):
        subprocess.check_call(
            [sys.executable, "-m", "pip", "install", f"vyper=={version}"]
        )
        self.version = version

    def get_code(self, source_path: str) -> List[str]:
        with open(source_path) as f:
            code = f.read()
            f.seek(0)
            code_split = "\n".join(
                [line.strip() for line in f.read().split("\n") if line.strip()]
            ).split("\n")
        return code_split

    def compile_contract(self, source_path: str) -> OrderedDict:
        self.verify_source_version(self.code)
        pwd = os.getcwd()
        base_source_dir = os.path.abspath(os.path.join(source_path, "../"))
        os.chdir(base_source_dir)
        compiled = compile_files([source_path], ["bytecode_runtime"])
        os.chdir(pwd)
        return compiled

    def get_bytecode(self, source_path: str) -> str:
        base_source_dir = os.path.abspath(os.path.join(source_path, "../"))
        if not os.path.isdir(self.artifacts_dir):
            os.makedirs(self.artifacts_dir)
        try:
            compiled = self.compile_contract(source_path)
            return compiled[self.source_name]["bytecode_runtime"][2:]
        except:
            compiler_dir = self.get_compiler_dir()
            res = (
                subprocess.run(
                    [
                        sys.executable,
                        f"{compiler_dir}",
                        "-f",
                        "bytecode_runtime",
                        source_path,
                    ],
                    stdout=subprocess.PIPE,
                )
                .stdout.decode()
                .strip()
            )
            return res[2:]

    def verify_source_version(self, code_split: List[str]):
        source_ver = ""
        for line in code_split:
            if "@version" in line:
                source_ver = line
        if source_ver == "":
            raise Exception("No source version specified in contract")
        source_ver = source_ver[source_ver.find("0") :].strip()
        if source_ver != self.version:
            self.install_compiler_version(source_ver)
            ver = self.get_compiler_ver(self.get_compiler_dir())
        return

    def get_abi(self, source_path):
        self.verify_source_version(self.code)
        pwd = os.getcwd()
        base_source_dir = os.path.abspath(os.path.join(source_path, "../"))
        os.chdir(base_source_dir)
        try:
            compiled = compile_files([source_path], ["abi"])
            return compiled
        except:
            compiler_dir = self.get_compiler_dir()
            res = (
                subprocess.run(
                    [sys.executable, f"{compiler_dir}", "-f", "abi", source_path],
                    stdout=subprocess.PIPE,
                )
                .stdout.decode()
                .strip()
            )
            return json.loads(res)
        os.chdir(pwd)
        return self.compiled[self.source_name]["abi"][2:]

    def get_opcodes(self):
        it = InstructionIterator(self.bytecode)
        return " ".join(x for x in it.disassemble().values()).split(" ")

    def get_opcode_str(self, opcodes):
        return " ".join(x for x in opcodes)


class Solidity(Contract):
    def __init__(self, source_path):
        w3 = Web3()
        self.lang = Language.SOL
        self.compiler_path = self.get_compiler_dir()
        self.source_path = source_path
        self.source_name = os.path.basename(source_path)
        self.source_base_dir = os.path.dirname(self.source_path)
        self.artifacts_dir = os.path.join(os.path.expanduser("~"), ".warp", "artifacts")
        self.code = self.get_code(source_path)
        self.compiled, self.version = self.compile_contract(self.code)
        self.bytecode = self.get_bytecode(self.compiled, self.version)
        self.abi = self.get_abi(self.code)
        self.opcodes = self.get_opcodes()
        self.selectors = get_selectors(self.abi, self.source_base_dir)
        self.selector_jumpdests = get_selector_jumpdests(self, self.source_base_dir)
        self.web3_interface = w3.eth.contract(abi=self.abi, bytecode=self.bytecode)
        optimize_payable(self)
        self.opcodes_str = self.get_opcode_str(self.opcodes)

    def get_opcode_str(self, opcodes):
        return " ".join(x for x in opcodes)

    def get_compiler_dir(self):
        return (
            subprocess.run(["which", "solc"], stdout=subprocess.PIPE)
            .stdout.decode()
            .strip()
        )

    def get_source_version(self, code):
        code_split = code.split("\n")
        for line in code_split:
            if "pragma" in line:
                return line[line.index("0.") :].replace(";", "")
        raise Exception("No Solidity version specified in contract")

    def get_code(self, file_path):
        with open(file_path) as f:
            code = f.read()
        return code

    def compile_contract(self, code):
        self.verify_source_version(code)
        pwd = os.getcwd()
        base_source_dir = os.path.abspath(os.path.join(self.source_path, "../"))
        if not os.path.isdir(self.artifacts_dir):
            os.makedirs(self.artifacts_dir)
        os.chdir(base_source_dir)
        source_version = solcx.set_solc_version_pragma(code)
        if source_version.minor >= 6:
            compiled = solcx.compile_source(
                code,
                metadata_hash="none",
                output_values=["bin-runtime"],
                solc_version=source_version,
            )
        else:
            compiled = solcx.compile_source(
                code,
                output_values=["bin-runtime"],
                solc_version=source_version,
            )
        os.chdir(pwd)
        return compiled, source_version

    def get_abi(self, code):
        self.verify_source_version(code)
        pwd = os.getcwd()
        base_source_dir = os.path.abspath(os.path.join(self.source_path, "../"))
        os.chdir(base_source_dir)
        abi = solcx.compile_source(code, output_values=["abi"])
        abi_succinct = []
        count = 0
        for k, v in abi.items():
            new_k = k.split(":")[1]
            if new_k.startswith("I"):
                continue
            elif v["abi"] != "":
                abi_succinct = v["abi"]
                count += 1
            if count > 1:
                raise Exception("There were more than one non-interface abis")
        os.chdir(pwd)
        return abi_succinct

    def verify_source_version(self, code):
        source_version = Version(self.get_source_version(code))
        installed_vers = solcx.get_installed_solc_versions()
        if source_version not in installed_vers:
            solcx.install_solc_pragma(code)
            solcx.set_solc_version_pragma(code)
        return source_version

    # only one of the keys should have their bin-runtime value
    # non-empty.
    def get_bytecode(self, compile_obj, ver):
        bytecode = ""
        for k, v in compile_obj.items():
            if v["bin-runtime"] == "":
                continue
            else:
                bytecode += v["bin-runtime"]
        # remove the insane metadata hash
        if ver.minor <= 6:
            try:
                idx = bytecode.index("a165")
                metadata = bytecode[idx:]
                if "5820" in metadata and metadata.endswith("0029"):
                    bytecode = bytecode[:idx]
            except:
                idx = bytecode.index("a265")
                metadata = bytecode[idx:]
                if "5820" in metadata and metadata.endswith("0032"):
                    bytecode = bytecode[:idx]

        return bytecode

    def get_opcodes(self):
        it = InstructionIterator(self.bytecode)
        return " ".join(x for x in it.disassemble().values()).split(" ")
