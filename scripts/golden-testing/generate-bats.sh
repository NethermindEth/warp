#!/usr/bin/env bash

usage() { printf "Usage: $0 TEMPLATE-FILE"; exit 1; }

template="$1"

if [ -z "$template" ]; then
    usage
fi

source "$template"

test_group=$(basename "$template" .template)

cat "$template"
printf "\n\n### GENERATED TESTS ###\n\n"

for test_file in "$WARP_TEST_DIR"/*$WARP_TEST_SUFFIX; do
    base=$(basename "$test_file" $WARP_TEST_SUFFIX)
    cat <<EOF
@test "$WARP_TEST_GROUP_PREFIX/$base" {
    test_case "$base"
}

EOF
done
