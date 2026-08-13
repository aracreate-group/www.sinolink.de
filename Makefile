# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026, SinoLink Deutschland
# Author: Aravinth Panch <ara@aracreate.group>
# Description: Unified build and environment tasks

SHELL    := /bin/bash
SRC_DIR  := ./src
DIST_DIR := ./dist
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
	@echo "make build          --> Build both domains into $(DIST_DIR)"
	@echo "make build-de       --> Build sinolink.de into $(DIST_DIR)/de"
	@echo "make build-pt       --> Build sinolink.pt into $(DIST_DIR)/pt"
	@echo "make test           --> Check every asset reference resolves"
	@echo "make release        --> Cut a semantic release"
	@echo "make clean          --> Remove build artefacts"
	@echo "========================================================================"
	@echo ""

################################################################################
# Targets
################################################################################
.PHONY: help install setup dev dev-de dev-pt build build-de build-pt dist-common test release clean

install:
	@printf "\n==> Installing dependencies\n\n"
	@printf "No dependencies — plain static HTML, CSS and JS.\n"

setup:
	@printf "\n==> Setting up environment\n\n"
	@command -v python3 >/dev/null || { printf "python3 is required for 'make dev'\n"; exit 1; }
	@printf "python3 found — ready.\n"

# Serves the sources directly. There is no index.html in src/, so open a
# language explicitly, e.g. /en.html.
dev:
	@printf "\n==> Serving $(SRC_DIR) on http://localhost:$(PORT)\n"
	@printf "    open http://localhost:$(PORT)/en.html\n\n"
	@cd $(SRC_DIR) && python3 -m http.server $(PORT)

# These serve the built output, so they are exactly what each domain serves in
# production, index.html and all.
dev-de: build-de
	@printf "\n==> Serving $(DIST_DIR)/de on http://localhost:$(PORT)\n\n"
	@cd $(DIST_DIR)/de && python3 -m http.server $(PORT)

dev-pt: build-pt
	@printf "\n==> Serving $(DIST_DIR)/pt on http://localhost:$(PORT)\n\n"
	@cd $(DIST_DIR)/pt && python3 -m http.server $(PORT)

# Both domains ship the same flat set of pages, so the language menu works
# without leaving the domain. They differ only in which language is copied to
# index.html and becomes the document root.
build: build-de build-pt

build-de: test
	@printf "\n==> Building sinolink.de into $(DIST_DIR)/de\n\n"
	@$(MAKE) --no-print-directory dist-common DOMAIN=de
	@cp $(SRC_DIR)/en.html $(DIST_DIR)/de/index.html
	@printf "Document root is English (en.html).\n"

build-pt: test
	@printf "\n==> Building sinolink.pt into $(DIST_DIR)/pt\n\n"
	@$(MAKE) --no-print-directory dist-common DOMAIN=pt
	@cp $(SRC_DIR)/pt.html $(DIST_DIR)/pt/index.html
	@printf "Document root is Portuguese (pt.html).\n"

# Everything both domains share, plus the crawler files for this domain, which
# are per-domain because each has to advertise its own sitemap URL.
# readme.md is deliberately not copied.
dist-common:
	@rm -rf $(DIST_DIR)/$(DOMAIN)
	@mkdir -p $(DIST_DIR)/$(DOMAIN)
	@cp $(SRC_DIR)/*.html $(DIST_DIR)/$(DOMAIN)/
	@cp $(SRC_DIR)/robots-$(DOMAIN).txt $(DIST_DIR)/$(DOMAIN)/robots.txt
	@cp $(SRC_DIR)/sitemap-$(DOMAIN).xml $(DIST_DIR)/$(DOMAIN)/sitemap.xml
	@cp -R $(SRC_DIR)/assets $(DIST_DIR)/$(DOMAIN)/assets

test:
	@printf "\n==> Checking asset references\n\n"
	@./scripts/check-assets.sh

release:
	@printf "\n==> Cutting release\n\n"
	@npx semantic-release

clean:
	@printf "\n==> Cleaning build artefacts\n\n"
	@rm -rf $(DIST_DIR)
	@find . -name '.DS_Store' -delete
