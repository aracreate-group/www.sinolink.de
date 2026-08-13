# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026, SinoLink Deutschland
# Author: Aravinth Panch <ara@aracreate.group>
# Description: Unified build and environment tasks

SHELL    := /bin/bash
SRC_DIR  := ./src
MOTD     := ./scripts/motd
PORT     ?= 8080

################################################################################
# Help
################################################################################
.DEFAULT_GOAL := help

help:
	@cat $(MOTD)
	@echo "========================================================================"
	@echo "make install        --> Install dependencies"
	@echo "make setup          --> Set up environment"
	@echo "make dev            --> Serve the site locally (PORT=$(PORT))"
	@echo "make dev-de         --> Serve sinolink.de as its own document root"
	@echo "make dev-pt         --> Serve sinolink.pt as its own document root"
	@echo "make build          --> Build / compile"
	@echo "make test           --> Check every asset reference resolves"
	@echo "make release        --> Cut a semantic release"
	@echo "make clean          --> Remove build artefacts"
	@echo "========================================================================"
	@echo ""

################################################################################
# Targets
################################################################################
.PHONY: help install setup dev dev-de dev-pt build test release clean

install:
	@printf "\n==> Installing dependencies\n\n"
	@printf "No dependencies — plain static HTML, CSS and JS.\n"

setup:
	@printf "\n==> Setting up environment\n\n"
	@command -v python3 >/dev/null || { printf "python3 is required for 'make dev'\n"; exit 1; }
	@printf "python3 found — ready.\n"

# Serves the repo as deployed: /de and /pt side by side, sharing ../assets.
dev:
	@printf "\n==> Serving $(SRC_DIR) on http://localhost:$(PORT)\n"
	@printf "    sinolink.de  -> http://localhost:$(PORT)/de/\n"
	@printf "    sinolink.pt  -> http://localhost:$(PORT)/pt/\n\n"
	@cd $(SRC_DIR) && python3 -m http.server $(PORT)

# Mirrors production, where the document root is src/de. Sibling ../assets is
# outside the root here, so images and CSS will 404 — use for link checks only.
dev-de:
	@printf "\n==> Serving $(SRC_DIR)/de on http://localhost:$(PORT)\n\n"
	@cd $(SRC_DIR)/de && python3 -m http.server $(PORT)

dev-pt:
	@printf "\n==> Serving $(SRC_DIR)/pt on http://localhost:$(PORT)\n\n"
	@cd $(SRC_DIR)/pt && python3 -m http.server $(PORT)

build:
	@printf "\n==> Building\n\n"
	@printf "No build step — $(SRC_DIR) is served as-is.\n"

test:
	@printf "\n==> Checking asset references\n\n"
	@./scripts/check-assets.sh

release:
	@printf "\n==> Cutting release\n\n"
	@npx semantic-release

clean:
	@printf "\n==> Cleaning build artefacts\n\n"
	@find . -name '.DS_Store' -delete
