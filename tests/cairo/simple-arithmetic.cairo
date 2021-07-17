%builtins output

func main{output_ptr : felt*}():
    [ap] = 1000; ap++
    [ap] = 2000; ap++
    [ap] = [ap - 2] + [ap - 1]
    [ap] = [output_ptr]; ap++
    [ap] = output_ptr + 1; ap++
    ret
end
