%builtins output

func main{output_ptr : felt*}():
    %{ memory[ap] = program_input['echo_arg'] %}
    [ap] = [output_ptr]; ap++
    [ap] = output_ptr + 1; ap++
    ret
end
