from vyper.ast.utils import parse_to_ast


with open("bid.vy", 'r') as f:
    code = f.read()

a = parse_to_ast(code)
for i in a:
    try:
        for b in i.get("body"):
            print(b.get("target").__slots__)
            # print(b.get("arg"))
            # print(b.get("annotation").get("id"))
    except:
        continue
