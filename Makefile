BASE_BRANCH ?= devel
export BASE_BRANCH
export HELM_REPO_LOCATION=.

ifneq (,$(DAPPER_HOST_ARCH))

# Running in Dapper

include $(SHIPYARD_DIR)/Makefile.inc

ifneq (,$(filter ovn,$(_using)))
export SETTINGS = $(DAPPER_SOURCE)/.shipyard.e2e.ovn.yml
else
export SETTINGS = $(DAPPER_SOURCE)/.shipyard.e2e.yml
endif

export DEPLOYTOOL = helm
GH_URL=https://submariner-io.github.io/submariner-charts/charts
CHARTS_DIR=charts
CHARTS_VERSION=0.13.0-rc2
HELM_DOCS_VERSION=0.15.0
REPO_URL=$(shell git config remote.origin.url)

# TODO: Remove once a 0.14.0/0.13.1 helm chart is released
# This is needed because the operator was erroneously using image names for overrides, and it has been fixed on devel
# Also we need the fix https://github.com/submariner-io/lighthouse/pull/833
ifeq ($(LIGHTHOUSE),true)
ifeq ($(GLOBALNET),true)
PRELOAD_IMAGES := lighthouse-agent lighthouse-coredns submariner-operator
endif
endif

# Targets to make

e2e: E2E_ARGS=cluster1 cluster2

%.tgz:
	helm dep update $(subst -$(CHARTS_VERSION),,$(basename $(@F)))
	helm package --version $(CHARTS_VERSION) $(subst -$(CHARTS_VERSION),,$(basename $(@F)))

helm-docs:
	# Avoid polluting repo with helm-docs' README/LICENSE or other files in the release archive
	cd /tmp && \
	curl -sL https://github.com/norwoodj/helm-docs/releases/download/v$(HELM_DOCS_VERSION)/helm-docs_$(HELM_DOCS_VERSION)_Linux_x86_64.tar.gz | tar zx && \
	cd -
	/tmp/helm-docs
	if [ ! -z $(git status --porcelain) ]; then \
		echo "Helm docs not up-to-date:"; \
		git status --porcelain; \
		git diff; \
		echo "Run make helm-docs locally to generate updated docs, commit the updates."; \
		exit 1; \
	fi

release: submariner-k8s-broker-$(CHARTS_VERSION).tgz submariner-operator-$(CHARTS_VERSION).tgz
	git checkout gh-pages
	mv *.tgz $(CHARTS_DIR)
	if [ -f $(CHARTS_DIR)/index.yaml ]; then \
	  helm repo index $(CHARTS_DIR) --url $(GH_URL) --merge $(CHARTS_DIR)/index.yaml; \
	else \
	  helm repo index $(CHARTS_DIR) --url $(GH_URL); \
	fi

.PHONY: release helm-docs

else

# Not running in Dapper

Makefile.dapper:
	@echo Downloading $@
	@curl -sfLO https://raw.githubusercontent.com/submariner-io/shipyard/$(BASE_BRANCH)/$@

include Makefile.dapper

endif

# Disable rebuilding Makefile
Makefile Makefile.inc: ;
