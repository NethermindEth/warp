import json
import sys
from typing import Dict, List
from dataclasses import dataclass
from TypeMap import TYPE_MAP_VY, decorator_map

# TODO delete comments before building ast

refs = "{storage_ptr: Storage*, pedersen_ptr: HashBuiltin*, range_check_ptr}"


@dataclass
class FunctionState:
    variables: Dict[str, Dict[str, str]]
    arguments: Dict[str, Dict[str, str]]
    return_type: str

    def __init__(self):
        self.variables = {}
        self.arguments = {}
        self.return_type = ""


# Represents the state of the generated
# Cairo code during transpilation
@dataclass
class TranspilationState:
    storage_vars: Dict[str, Dict[str, str]]
    functions: Dict[str, FunctionState]

    def __init__(self):
        self.storage_vars = {}
        self.functions = {}


class Vyper:
    def __init__(self):
        self.c_state = TranspilationState()
        self.ast = self.get_ast()
        self.vy_code = self.get_code()
        self.vy_storage_vars = self.get_storage_vars(self.ast)
        self.c_svars = self.generate_storage_vars(self.vy_storage_vars)
        self.vy_functions = self.get_functions(self.ast)
        self.c_functions = self.generate_functions(self.vy_functions)

    def get_ast(self):
        with open("ast.json", "r") as f:
            return json.load(f)["ast"]["body"]

    def get_code(self):
        with open("bid.vy", "r") as f:
            return f.readlines()

    def get_storage_vars(self, ast):
        storage_vars = []
        for node in ast:
            if node["ast_type"] != "FunctionDef" and node["col_offset"] == 0:
                start = node["lineno"]
                end = node["end_lineno"]
                code = (
                    self.vy_code[start - 1 : end].strip().replace(" ", "")
                    if start != end
                    else self.vy_code[start - 1].strip().replace(" ", "")
                )
                storage_vars.append(code)
        return storage_vars

    def get_func_sig(self, body, args_line_len):
        if args_line_len > 0:
            return "\n".join(body[: args_line_len + 1])
        else:
            return body[0][: body[0].rfind("-")]

    def get_func_body(self, body_ast):
        body_list = []
        for item in body_ast:
            start = item["lineno"]
            end = item["end_lineno"]
            if start == end:
                body_list.append(
                    self.vy_code[start - 1].strip().replace("\\", "").replace("\n", "")
                )
            else:
                body_list.append(
                    " ".join(self.vy_code[start - 1 : end])
                    .strip()
                    .replace("\\", "")
                    .replace("\n", "")
                )
        return body_list

    def get_functions(self, ast):
        funcs = []
        for node in ast:
            if node["ast_type"] == "FunctionDef":
                start = node["lineno"] - 1
                end = node["end_lineno"]
                name = node["name"]
                try:
                    returns = node["returns"]["id"]
                except TypeError:
                    returns = None
                source = [x.strip() for x in self.vy_code[start:end]]
                visibility = self.get_func_visibility(node)
                if node["args"]["args"] == []:
                    args_line_len = 0
                    funcs.append(
                        {
                            "name": name,
                            "returns": returns,
                            "source": source,
                            "visibility": visibility,
                            "body_str": self.get_func_body(node["body"]),
                            "body_ast": node["body"],
                            "args_len": args_line_len,
                            "args": [],
                        }
                    )
                    continue
                args_endno = node["args"]["end_lineno"]
                args_line_len = args_endno - (start + 1)
                sig = self.get_func_sig(source, args_line_len)
                sig_list = (
                    sig[sig.find("(") + 1 : sig.rfind(")")].replace(" ", "").split(",")
                )
                args = []
                for i in sig_list:
                    args.append(
                        {
                            "name": i[: i.find(":")].strip(),
                            "type": i[i.find(":") + 1 :].strip(),
                        }
                    )
                funcs.append(
                    {
                        "name": name,
                        "returns": returns,
                        "source": source[args_line_len + 1 :],
                        "visibility": visibility,
                        "body_str": self.get_func_body(node["body"]),
                        "body_ast": node["body"],
                        "args_len": args_line_len,
                        "args": args,
                    }
                )
        return funcs

    def get_func_visibility(self, node):
        for item in node["decorator_list"]:
            if item["id"] in "external view internal":
                return item["id"]

    def s_read_no_key(self, name):
        return f"{name}.read()"

    def s_write_no_key(self, name, value):
        return f"{name}.write({value})"

    def s_read_big_key(self, name, arg1_low, arg1_high):
        return f"{name}.read({arg1_low}, {arg1_high})"

    def s_read_small_key(self, name, arg):
        return f"{name}.read({arg})"

    def s_write_big_key(self, name, arg1_low, arg1_high, val):
        return f"{name}.write({arg1_low}, {arg1_high}, {val})"

    def s_write_small_key(self, name, arg, val):
        return f"{name}.write({arg}, {val})"

    def generate_storage_vars(self, storage_vars):
        decls = []
        for declaration in storage_vars:
            name_end = declaration.rfind(":")
            name = declaration[:name_end]
            if "HashMap" in declaration:
                decls.append(self.handle_hashmap(name, declaration, False))
            else:
                decls.append(self.simple_storage_var(name, declaration))
        return "".join(decls)

    def simple_storage_var(self, var_name, declaration):
        var_type = declaration[declaration.find("(") + 1 : declaration.rfind(")")]
        c_type = TYPE_MAP_VY[var_type]
        if c_type["big"]:
            c_declr = f"""
@storage_var
func {var_name}() -> (res : (felt,felt)):
end
"""
            self.c_state.storage_vars[var_name] = {
                "gen_read": self.s_read_no_key,
                "read_return": "tuple",
                "gen_write": self.s_write_no_key,
            }
            return c_declr
        else:
            c_declr = f"""
@storage_var
func {var_name}() -> (res : felt):
end
"""
            self.c_state.storage_vars[var_name] = {
                "gen_read": self.s_read_no_key,
                "read_return": "felt",
                "gen_write": self.s_write_no_key,
            }
            return c_declr

    def handle_hashmap(self, var_name, declaration, nested):
        if not nested:
            types = declaration[
                declaration.find("[") + 1 : declaration.find("]")
            ].split(",")
            c_type_key = TYPE_MAP_VY[types[0]]
            c_type_val = TYPE_MAP_VY[types[1]]
            if c_type_key["big"] and c_type_val["big"]:
                c_declr = f"""
@storage_var
func {var_name}(arg1_low, arg1_high) -> (res : (felt,felt)):
end
"""
                self.c_state.storage_vars[var_name] = {
                    "gen_read": self.s_read_big_key,
                    "read_return": "tuple",
                    "gen_write": self.s_write_big_key,
                }
                return c_declr
            elif c_type_key["big"] and not c_type_val["big"]:
                c_declr = f"""
@storage_var
func {var_name}(arg1_low, arg1_low) -> (res : felt):
end
"""
                self.c_state.storage_vars[var_name] = {
                    "gen_read": self.s_read_big_key,
                    "read_return": "felt",
                    "gen_write": self.s_write_big_key,
                }
                return c_declr
            elif not c_type_key["big"] and c_type_val["big"]:
                c_declr = f"""
@storage_var
func {var_name}(arg) -> (res : (felt, felt)):
end
"""
                self.c_state.storage_vars[var_name] = {
                    "gen_read": self.s_read_small_key,
                    "read_return": "tuple",
                    "gen_write": self.s_write_small_key,
                }
                return c_declr
            else:
                c_declr = f"""
@storage_var
func {var_name}(arg) -> (res :  felt):
end
"""
                if "public" in declaration:
                    c_declr += f"""
@view
func get_{var_name}(arg) -> (res : felt):
    let (res) = {var_name}.read(arg)
    return (res=res)
"""
                    self.c_state.storage_vars[var_name] = {
                        "gen_read": self.s_read_small_key,
                        "read_return": "felt",
                        "gen_write": self.s_write_small_key,
                    }

                return c_declr

    def generate_func_sig(self, func):
        func_state = FunctionState()
        returns = func["returns"]
        name = func["name"]
        visibility = func["visibility"]
        sig = f"{decorator_map[visibility]}\nfunc {name+refs}("
        if visibility == "external" or visibility == "view":
            if func["args"] == []:
                if returns != None:
                    if TYPE_MAP_VY[returns]["big"]:
                        sys.exit(
                            f"external and view functions can only return a \
                                single felt(128bit int), but {name} returns {returns} \
                                which can't be mapped to a felt.\n"
                        )
                    sig += f") -> (res : felt):"
                    print(sig)
                    return sig
                else:
                    sig += f"):"
                    print(sig)
                    return sig
            for idx, arg in enumerate(func["args"]):
                if idx == len(func["args"]) - 1:
                    if TYPE_MAP_VY[arg["type"]]["big"]:
                        sig += f"{arg['name']}_low: felt, {arg['name']}_high: felt):"
                        break
                    else:
                        sig += f'{arg["name"]}: {arg["type"]}, '
                        break
                if TYPE_MAP_VY[arg["type"]]["big"]:
                    sig += f"{arg['name']}_low: felt, {arg['name']}_high: felt, "
                else:
                    sig += f'{arg["name"]}: {arg["type"]}, '
            print(sig)
            return sig
        else:
            if func["args"] == []:
                if returns != None:
                    sig += f') -> (res : {TYPE_MAP_VY[returns]["type"]}):'
                    print(sig)
                    return sig
                else:
                    sig += f"):"
                    print(sig)
                    return sig
            for idx, arg in enumerate(func["args"]):
                if idx == len(func["args"]) - 1:
                    if returns != None:
                        sig += f"{arg['name']}: {TYPE_MAP_VY[arg['type']]}) -> (res : {TYPE_MAP_VY[returns]['type']}):"
                        break
                sig += f'{arg["name"]}: {arg["type"]}, '
            print(sig)
            return sig

    def generate_func_body(self, vy_body):
        print(vy_body)

    def generate_functions(self, vyper_functions):
        for f in vyper_functions:
            print(f["returns"])
            sig = self.generate_func_sig(f)
            self.generate_func_body(f["body_str"])
            # print(vyper_functions)
            pass


def generate_cairo_code(self):
    code = """
%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.storage import Storage    
"""


a = Vyper()
print(a.c_svars)
# b = a.vy_functions["__init__"]["body"][0].replace("def", "func").split(",")
# c = a.vy_functions["__init__"]["body"][0]
# sg = c[c.find("(") + 1 : c.rfind(")")].replace(" ", "").split(",")
# args = []
# for i in sg:
#     args.append({"name": i[: i.find(":")], "type": i[i.find(":") + 1 :]})
# sig = (
#     " ".join(
#         [
#             x.replace(
#                 x[x.find(":") + 1 :].strip(),
#                 TYPE_MAP_VY[
#                     x[x.find(":") + 1 :].strip().replace(":", "").replace(")", "")
#                 ]["type"],
#             )
#             for x in b
#         ]
#     )
#     + "):"
# )
# sig = sig[: sig.find("(")] + refs + sig[sig.find("(") :]
