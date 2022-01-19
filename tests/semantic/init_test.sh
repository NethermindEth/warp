#!/usr/bin/env bash
shopt -s globstar

function prepend_solidity_version() {
  for solFile in $(find . -name "*.sol" -type f);
  do
      echo "$solFile"
      printf '%s\n%s\n' "pragma solidity ^0.8.6;" "$(cat "$solFile")" > "$solFile"
  done;
}

if [ -d "tests/semantic/solidity/test/libsolidity/semanticTests" ]
then
  echo "Semantic Tests already initialized"
else
  git clone git@github.com:ethereum/solidity.git tests/semantic/solidity
  pushd tests/semantic/solidity/test/libsolidity/semanticTests || exit
  git checkout e5eed63a3e83d698d8657309fd371248945a1cda
  prepend_solidity_version
  popd || exit

  scripts/isoltest --print-test-expectations\
    --testpath tests/semantic/solidity/test/libsolidity/semanticTests/ \
    > tests/semantic/test_calldata.json
fi
