from transpiler.Operation import Operation 

class NoOp(Operation):
    def bind_to_res(self):
        pass
    def required_imports(self):
        return {}

    def proceed(self, state):
        return ''