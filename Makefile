GOLDEN_DIR := ./scripts/golden-testing
BATS_DIR := ./build/bats
TEMPLATES := $(wildcard $(GOLDEN_DIR)/*.template)
BATS_FILES := $(patsubst $(GOLDEN_DIR)/%.template,$(BATS_DIR)/test-%.bats,$(TEMPLATES))
TEST_FILES := $(shell find ./tests -type f ! -name '*.temp*') # exclude temporary files
SRC_FILES := $(shell find ./warp/ -type f)
PY_REQUIREMENTS := requirements.txt

warp: .warp-activation-token
.PHONY: warp

.warp-activation-token: $(SRC_FILES) setup.py
	pip install -r $(PY_REQUIREMENTS)
	python setup.py install
	pre-commit install
	touch .warp-activation-token

test: test_bats
.PHONY: test

test_bats: warp $(BATS_FILES)
	bats -j 8 $^ $(BATS_ARGS)
.PHONY: test_bats

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
