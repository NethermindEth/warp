tests_dir="./tests/cairo"
cairo_src_dir="./cairo-src"

make_input_option() {
    input_file="$1.input.json"
    if [ -e "$input_file" ]; then # exists
        option_name='--program_input'
        printf '%s=%s' "$option_name" "$input_file"
    fi
}

test_cairo() {
    test_file="$tests_dir/$1.cairo"
    printf "checking $test_file\n"
    gold_file="${test_file}.gold"
    temp_file="${test_file}.temp"
    compile_file="${test_file}.compile.json"

    input_option=$(make_input_option "$test_file")

    cairo-compile \
        --cairo_path "$cairo_src_dir" \
        "$test_file" --output "$compile_file"
    cairo-run \
        --program="$compile_file" \
        --print_output \
        --layout=small \
        $input_option \
        > "$temp_file"
    diff "$temp_file" "$gold_file" \
         --ignore-trailing-space \
         --ignore-blank-lines \
         --new-file # treat absent files as empty

    rm "$temp_file"
    rm "$compile_file"
}

setup_file() {
    echo "# Testing cairo code: ${tests_dir}">&3
}

@test "mstore-mload" {
    test_cairo "mstore-mload"
}

@test "mstore8-mload" {
    test_cairo "mstore8-mload"
}

@test "mstore8-mload8-many" {
    test_cairo "mstore8-mload8-many"
}

@test "mstore8-mload8" {
    test_cairo "mstore8-mload8"
}

@test "exp_byte" {
    test_cairo "exp_byte"
}

@test "simple-arithmetic" {
    test_cairo "simple-arithmetic"
}

@test "echo" {
    test_cairo "echo"
}

@test "bitwise-operations" {
    test_cairo "bitwise-operations"
}
