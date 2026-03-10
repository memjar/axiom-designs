.PHONY: preview build list

preview: ## Open showcase in default browser
	open showcase/index.html

build: ## Validate all HTML files exist
	@echo "Checking components..."
	@ls components/*.html > /dev/null
	@echo "Checking layouts..."
	@ls layouts/*.html > /dev/null
	@echo "Checking animations..."
	@ls animations/*.html > /dev/null
	@echo "Checking showcase..."
	@ls showcase/*.html > /dev/null
	@echo "All files present."

list: ## List all design pages
	@echo "=== Components ===" && ls components/
	@echo "=== Layouts ===" && ls layouts/
	@echo "=== Animations ===" && ls animations/
	@echo "=== Showcase ===" && ls showcase/
