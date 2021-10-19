from __future__ import annotations

import abc
from dataclasses import dataclass
from enum import Enum

from eth_hash.auto import keccak


class Language(Enum):
    SOL = 0
    VYPER = 1


class Contract(abc.ABC):
    @abc.abstractmethod
    def get_compiler_dir(self):
        pass

    @abc.abstractmethod
    def get_code(self, file_path):
        pass

    @abc.abstractmethod
    def verify_source_version(self, code):
        pass

    @abc.abstractmethod
    def compile_contract(self, source_path):
        pass

    @abc.abstractmethod
    def get_bytecode(self, compile_obj):
        pass

    @abc.abstractmethod
    def get_abi(self, path):
        pass
