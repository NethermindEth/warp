.DEFAULT_GOAL := install
.PHONY: test test_compilation test_execution

install:
	yarn
	python -m pip install -r requirements.txt

compile:
	yarn tsc

test_compilation: install compile
	bin/warp test --unsafe -f

test_execution: install compile
	yarn test

test: test_compilation test_execution
