GOLDEN_DIR := ./scripts/golden-testing
BATS_DIR := ./build/bats
TEMPLATES := $(wildcard $(GOLDEN_DIR)/*.template)
BATS_FILES := $(patsubst $(GOLDEN_DIR)/%.template,$(BATS_DIR)/test-%.bats,$(TEMPLATES))

test: $(BATS_FILES)
	bats $^ -j 8 $(BATS_ARGS)
.PHONY: test

$(BATS_DIR)/test-%.bats: $(GOLDEN_DIR)/%.template $(GOLDEN_DIR)/generate-bats.sh | $(BATS_DIR)
	bash $(GOLDEN_DIR)/generate-bats.sh $< > $@

$(BATS_DIR):
	mkdir -p $(BATS_DIR)

clean:
	rm -rf $(BATS_DIR)
.PHONY: clean
