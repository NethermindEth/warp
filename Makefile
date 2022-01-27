GOLDEN_DIR := ./scripts/golden-testing
BATS_DIR := ./build/bats
TEMPLATES := $(wildcard $(GOLDEN_DIR)/*.template)
BATS_FILES := $(patsubst $(GOLDEN_DIR)/%.template,$(BATS_DIR)/test-%.bats,$(TEMPLATES))
TEST_FILES := $(shell find ./tests -type f ! -name '*.temp*') # exclude temporary files
SRC_FILES := $(shell find ./src/warp/ -type f)
NETHERSOLC_FILES := $(shell find ./src/warp/bin -name nethersolc)
NPROCS := $(shell getconf _NPROCESSORS_ONLN)

warp: $(SRC_FILES) $(NETHERSOLC_FILES) pyproject.toml
	poetry install

test: test_bats test_yul benchmark
.PHONY: test

test_bats: warp $(BATS_FILES) tests/cli/*.bats
	bats -j $(NPROCS) $(wordlist 2,$(words $^),$^) $(ARGS)
.PHONY: test_bats

test_yul: warp
	mkdir -p benchmark/stats
	mkdir -p benchmark/tmp
	python -m pytest tests/ast/ -v --tb=short -n auto $(ARGS)
	python -m pytest scripts/yul/transpile_test.py -v --tb=short -n auto $(ARGS)
	python -m pytest scripts/yul/compilation_test.py -v --tb=short -n auto $(ARGS)
	python -m pytest tests/behaviour/ -v --tb=short -n auto $(ARGS)
.PHONY: test_yul

test_semantics: warp
	tests/semantic/init_test.sh
	python -m pytest tests/semantic/test_semantics.py -v --tb=short -n auto $(ARGS)
.PHONY: test_semantics

benchmark: warp
	mkdir -p benchmark/stats
	mkdir -p benchmark/tmp
	python -m pytest tests/benchmark -v --tb=short -n auto $(ARGS)
	PYTHONPATH=".:$(PYTHONPATH)" python ./tests/logging/generateMarkdown.py
.PHONY: benchmark

$(BATS_DIR)/test-%.bats: \
		$(GOLDEN_DIR)/%.template \
		$(GOLDEN_DIR)/generate-bats.sh \
		$(TEST_FILES) \
		| $(BATS_DIR)
	bash $(GOLDEN_DIR)/generate-bats.sh $< > $@

$(BATS_DIR):
	mkdir -p $(BATS_DIR)

clean:
	rm -rf $(BATS_DIR)
.PHONY: clean
