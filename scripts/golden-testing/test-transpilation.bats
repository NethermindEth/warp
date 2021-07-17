tests_dir="./tests/transpilation"
cairo_src_dir="./cairo-src"

test_case() {
    test_file="$tests_dir/$1.opcode"
    printf "checking $test_file\n"
    gold_file="${test_file}.gold.cairo"
    temp_file="${test_file}.temp.cairo"
    temp_compiled_test="${test_file}.temp.json"

    python src/EvmToCairo.py "$test_file" --dump-all > "$temp_file"
    diff "$temp_file" "$gold_file" \
         --ignore-trailing-space \
         --ignore-blank-lines \
         --new-file # treat absent files as empty

    rm "$temp_file"

    temp_run_result="${test_file}.temp.result"
    gold_run_result="${test_file}.gold.result"

    cairo-compile \
        --cairo_path $cairo_src_dir \
        "$gold_file" > "$temp_compiled_test"
    cairo-run --program="$temp_compiled_test" \
        --layout=small --print_output > "$temp_run_result"
    diff "$temp_run_result" "$gold_run_result" \
         --ignore-trailing-space \
         --ignore-blank-lines \
         --new-file # treat absent files as empty

    rm "$temp_compiled_test"
    rm "$temp_run_result"
}

setup_file() {
    echo "# Testing transpilation: ${tests_dir}">&3
}

@test "smod" {
    test_case "smod"
}

@test "mulmod" {
    test_case "mulmod"
}

@test "mod" {
    test_case "mod"
}

@test "addmod" {
    test_case "addmod"
}

@test "exp" {
    test_case "exp"
}

@test "byte" {
    test_case "byte"
}

@test "slt" {
    test_case "slt"
}

@test "sgt" {
    test_case "sgt"
}

@test "signextend" {
    test_case "signextend"
}

@test "msize-mload" {
    test_case "msize-mload"
}

@test "msize-mstore8" {
    test_case "msize-mstore8"
}

@test "msize-some-memory-access" {
    test_case "msize-some-memory-access"
}

@test "msize-no-memory-access" {
    test_case "msize-no-memory-access"
}

@test "mstore_mload" {
    test_case "mstore_mload"
}

@test "fib" {
    test_case "fib"
}

@test "stack-ops1" {
    test_case "stack-ops1"
}

@test "stack-ops2" {
    test_case "stack-ops2"
}

@test "too-big-for-uint128" {
    test_case "too-big-for-uint128"
}

@test "many-dups" {
    test_case "many-dups"
}

@test "add" {
    test_case "add"
}

@test "mul" {
    test_case "mul"
}

@test "sub" {
    test_case "sub"
}

@test "div" {
    test_case "div"
}

@test "sdiv" {
    test_case "sdiv"
}

@test "lt_false" {
    test_case "lt_false"
}

@test "lt_true" {
    test_case "lt_true"
}

@test "gt_true" {
    test_case "gt_true"
}

@test "gt_false" {
    test_case "gt_false"
}
@test "iszero" {
    test_case "iszero"
}

@test "eq_true" {
    test_case "eq_true"
}

@test "eq_false" {
    test_case "eq_false"
}

@test "and" {
    test_case "and"
}

@test "or" {
    test_case "or"
}

@test "not" {
    test_case "not"
}

@test "xor" {
    test_case "xor"
}

@test "shl" {
    test_case "shl"
}

@test "shr" {
    test_case "shr"
}

@test "sar" {
    test_case "sar"
}

@test "pc" {
    test_case "pc"
}

@test "codesize" {
    test_case "codesize"
}
