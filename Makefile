# Agent-friendly Godot workflow. Timeouts keep commands from hanging.
GODOT ?= godot
PROJECT ?= .
TIMEOUT_IMPORT ?= 120
TIMEOUT_CHECK ?= 60
TIMEOUT_RUN ?= 30
LOG_DIR := logs

.PHONY: help import check-gdscript headless-boot preview export-android-debug versions clean-logs

help:
	@echo "Targets: import | check-gdscript | headless-boot | preview | export-android-debug | versions"
	@echo "GODOT=$(GODOT)  PROJECT=$(PROJECT)"

versions:
	@command -v $(GODOT)
	@$(GODOT) --version
	@echo "project=$(PROJECT)"

import: versions
	@mkdir -p $(LOG_DIR)
	timeout $(TIMEOUT_IMPORT) $(GODOT) --headless --path $(PROJECT) --import > $(LOG_DIR)/import.log 2>&1; \
	  ec=$$?; echo "import exit=$$ec"; tail -n 40 $(LOG_DIR)/import.log; exit $$ec

# Parse/load selected scripts via headless boot (not a full test suite).
check-gdscript: versions
	@mkdir -p $(LOG_DIR)
	@echo "Checking GDScript files exist..."
	@test -f scripts/main.gd && test -f scripts/save_store.gd
	@test -f services/purchase_service.gd && test -f services/ads_service.gd
	timeout $(TIMEOUT_CHECK) $(GODOT) --headless --path $(PROJECT) --quit-after 2 > $(LOG_DIR)/check-gdscript.log 2>&1; \
	  ec=$$?; echo "check-gdscript exit=$$ec (parse/load via editor boot, not a unit suite)"; \
	  if rg -n "ERROR|SCRIPT ERROR|Parse Error" $(LOG_DIR)/check-gdscript.log; then \
	    echo "parse/load FAILED"; exit 1; \
	  fi; \
	  tail -n 30 $(LOG_DIR)/check-gdscript.log; exit $$ec

# Bounded headless startup of main scene. Not a full test suite.
headless-boot: versions
	@mkdir -p $(LOG_DIR)
	timeout $(TIMEOUT_RUN) $(GODOT) --headless --path $(PROJECT) --quit-after 3 > $(LOG_DIR)/headless-boot.log 2>&1; \
	  ec=$$?; echo "headless-boot exit=$$ec (runtime smoke, not full tests)"; \
	  if rg -n "SCRIPT ERROR|Parse Error" $(LOG_DIR)/headless-boot.log; then \
	    echo "runtime smoke FAILED"; exit 1; \
	  fi; \
	  tail -n 40 $(LOG_DIR)/headless-boot.log; exit $$ec

# Interactive preview where a display is available.
preview: versions
	@mkdir -p $(LOG_DIR)
	@if [ -z "$$DISPLAY" ]; then echo "No DISPLAY; use headless-boot or xvfb-run make preview"; exit 1; fi
	timeout 120 $(GODOT) --path $(PROJECT) > $(LOG_DIR)/preview.log 2>&1 || true
	@echo "preview ended; see $(LOG_DIR)/preview.log"

export-android-debug: versions
	@mkdir -p $(LOG_DIR) export
	@if [ ! -f export_presets.cfg ]; then echo "missing export_presets.cfg"; exit 1; fi
	timeout 300 $(GODOT) --headless --path $(PROJECT) --export-debug "Android" export/infra-demo-debug.apk > $(LOG_DIR)/export-android-debug.log 2>&1; \
	  ec=$$?; echo "export-android-debug exit=$$ec"; tail -n 60 $(LOG_DIR)/export-android-debug.log; \
	  if [ -f export/infra-demo-debug.apk ]; then ls -lh export/infra-demo-debug.apk; else echo "no apk produced"; fi; exit $$ec

clean-logs:
	rm -rf $(LOG_DIR)
