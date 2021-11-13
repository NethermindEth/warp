#!/usr/bin/env sh
for f in tests/yul/*.sol do
  warp transpile $f WARP --cairo-output &
done
wait
