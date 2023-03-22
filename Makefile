.DEFAULT_GOAL := install
.PHONY: test test_compilation test_execution

install:
	yarn
	python -m pip install -r requirements.txt

compile:
	yarn tsc

test_compilation:
	yarn test:compilation --only-results --force

test_exmaples_compilation:
	yarn test:examples --only-results --force

test_execution:
	yarn test

test: test_compilation test_execution
