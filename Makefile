.DEFAULT_GOAL := install
.PHONY: test test_compilation test_execution

install:
	yarn
	python -m pip install -r requirements.txt
	sudo add-apt-repository ppa:ethereum/ethereum; sudo apt update; sudo apt install solc
	curl -o solc-v0.7.6 https://binaries.soliditylang.org/linux-amd64/solc-linux-amd64-v0.7.6+commit.7338295f; sudo chmod +x solc-v0.7.6

compile:
	yarn tsc

test_compilation:
	bin/warp test --exact -f

test_execution:
	yarn test

test: test_compilation test_execution
