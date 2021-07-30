from transpiler.Operation import Operation


class Invalid(Operation):
    def proceed(self, state):
        pass

    def bind_to_res(self,state):
        pass