.DEFAULT_GOAL := install
.PHONY: test test_compilation test_execution

install:
	yarn
	python -m pip install -r requirements.txt
	sudo add-apt-repository ppa:ethereum/ethereum; sudo apt update; sudo apt install solc

compile:
	yarn tsc

test_compilation:
	bin/warp test --exact -f

test_execution:
	yarn test

test: test_compilation test_execution
