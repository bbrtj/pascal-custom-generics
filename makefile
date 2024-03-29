FPC ?= fpc
BUILD_DIR ?= build
SOURCE_DIR ?= src
FPC_FLAGS ?= -v0web -Sic -FE$(BUILD_DIR) -Fu$(SOURCE_DIR)
TEST_RUNNER ?= prove
TEST_VERBOSE ?= 0
TEST_FLAG ?= $$(if [ $(TEST_VERBOSE) == 1 ]; then echo "--verbose"; fi)

build: prepare
	$(FPC) $(FPC_FLAGS) -Fut/src -Fut/pascal-tap/src -FU$(BUILD_DIR) -ot/tests.t t/tests.t.pas

test: build
	$(TEST_RUNNER) $(TEST_FLAG)

prepare:
	mkdir -p $(BUILD_DIR)

clean:
	rm -Rf $(BUILD_DIR)

