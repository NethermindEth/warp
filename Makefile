.DEFAULT_GOAL := install
.PHONY: test test_compilation test_execution

install:
	yarn
	python -m pip install -r requirements.txt

compile:
	yarn tsc

test_compilation:
	yarn test:compilation

test_execution:
	yarn test

test: test_compilation test_execution
