#!/usr/bin/env sh
for f in tests/golden/*.sol
do
  warp transpile $f WARP --cairo-output &
done
wait
