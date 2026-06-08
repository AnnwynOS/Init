TARGET := x86_64-annwyn-user
TARGET_JSON := ./x86_64-annwyn-user.json
BUILD_DIR:= target/$(TARGET)/release
ABO_BUILDER := ../ABO-builder/target/release/ABO-builder
ELF_OUT := $(BUILD_DIR)/init
ABO_OUT := $(BUILD_DIR)/init.abo
MANIFEST := init.manifest

CARGO_FLAGS := \
	--target $(TARGET_JSON) \
	-Z build-std=core \
	-Z build-std-features=compiler-builtins-mem \
	-Z json-target-spec

.PHONY: all build abo check clean install-deps help

all: abo

build:
	@echo "==> Compiling init..."
	cargo build --release $(CARGO_FLAGS)
	@echo "==> ELF: $$(wc -c < $(ELF_OUT)) bytes"

abo: build
	@echo "==> Converting ELF to ABO..."
	@$(ABO_BUILDER) \
		$(ELF_OUT) \
		$(ABO_OUT) \
		--manifest $(MANIFEST)
	@echo "==> ABO ready: $(ABO_OUT) ($$(wc -c < $(ABO_OUT)) bytes)"

check: abo
	@echo "==> Checking ABO..."
	@$(ABO_BUILDER) --check $(ABO_OUT)
	@$(ABO_BUILDER) --dump $(ABO_OUT)

install: abo
	@KERNEL_DIR=$${ANNWYN_KERNEL_DIR:-../muKernel}; \
	DEST=$$KERNEL_DIR/assets; \
	mkdir -p $$DEST; \
	cp $(ABO_OUT) $$DEST/init.abo; \
	echo "==> Installed to $$DEST/init.abo"

build-tools:
	@echo "==> Building abo-builder..."
	cargo build --release \
		--manifest-path ../ABO-builder/Cargo.toml
	@echo "==> abo-builder OK"

install-deps:
	rustup component add rust-src llvm-tools-preview rustfmt

clean:
	cargo clean

help:
	@echo "aster-init build system"
	@echo ""
	@echo "Targets:"
	@echo "  all          Build ELF + ABO (default)"
	@echo "  build        Build ELF only"
	@echo "  abo          Build ELF + convert to ABO"
	@echo "  check        Build + validate ABO structure"
	@echo "  install      Copy init.abo to kernel assets/"
	@echo "  build-tools  Compile abo-builder"
	@echo "  clean        Remove build artifacts"
	@echo ""
	@echo "Environment:"
	@echo "  ANNWYN_KERNEL_DIR   Path to annwyn-kernel repo (default: ../muKernel)"