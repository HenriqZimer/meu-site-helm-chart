.PHONY: help lint template install uninstall package clean

CHART_NAME := meu-site
NAMESPACE := default
RELEASE_NAME := meu-site

help: ## Display this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

lint: ## Lint the Helm chart
	@echo "Linting chart..."
	helm lint chart/

template: ## Generate Kubernetes manifests from the chart
	@echo "Templating chart..."
	helm template $(RELEASE_NAME) chart/ --debug

template-file: ## Generate Kubernetes manifests to a file
	@echo "Templating chart to output.yaml..."
	helm template $(RELEASE_NAME) chart/ > output.yaml
	@echo "Manifests saved to output.yaml"

install: ## Install the chart
	@echo "Installing chart..."
	helm install $(RELEASE_NAME) chart/ --namespace $(NAMESPACE) --create-namespace

install-dry-run: ## Dry run installation
	@echo "Dry run installation..."
	helm install $(RELEASE_NAME) chart/ --namespace $(NAMESPACE) --dry-run --debug

upgrade: ## Upgrade the release
	@echo "Upgrading release..."
	helm upgrade $(RELEASE_NAME) chart/ --namespace $(NAMESPACE)

uninstall: ## Uninstall the release
	@echo "Uninstalling release..."
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

package: ## Package the chart
	@echo "Packaging chart..."
	helm package chart/
	@echo "Chart packaged successfully"

clean: ## Clean packaged charts
	@echo "Cleaning packaged charts..."
	rm -f *.tgz
	rm -f output.yaml
	@echo "Cleanup complete"

dev-install: ## Install with development values
	@echo "Installing chart with dev values..."
	helm install $(RELEASE_NAME) chart/ --namespace $(NAMESPACE) --create-namespace -f chart/values.yaml

upgrade-dev: ## Upgrade with development values
	@echo "Upgrading with dev values..."
	helm upgrade $(RELEASE_NAME) chart/ --namespace $(NAMESPACE) -f chart/values.yaml
