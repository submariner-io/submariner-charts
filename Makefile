BASE_BRANCH ?= devel
export BASE_BRANCH

ifneq (,$(DAPPER_HOST_ARCH))

# Running in Dapper

PRELOAD_IMAGES := submariner-gateway submariner-operator submariner-route-agent lighthouse-agent lighthouse-coredns

include $(SHIPYARD_DIR)/Makefile.inc

CLUSTER_SETTINGS_FLAG = --cluster_settings $(DAPPER_SOURCE)/cluster_settings
ifneq (,$(filter ovn,$(_using)))
CLUSTER_SETTINGS_FLAG = --cluster_settings $(DAPPER_SOURCE)/cluster_settings.ovn
else
CLUSTER_SETTINGS_FLAG = --cluster_settings $(DAPPER_SOURCE)/cluster_settings
endif

override CLUSTERS_ARGS += $(CLUSTER_SETTINGS_FLAG)
override DEPLOY_ARGS += $(CLUSTER_SETTINGS_FLAG) --deploytool helm
export DEPLOY_ARGS
GH_URL=https://submariner-io.github.io/submariner-charts/charts
CHARTS_DIR=charts
CHARTS_VERSION=0.7.0
HELM_DOCS_VERSION=0.15.0
REPO_URL=$(shell git config remote.origin.url)

# Process extra flags from the `using=a,b,c` optional flag

ifneq (,$(filter lighthouse,$(_using)))
override DEPLOY_ARGS += --service_discovery
endif

ifneq (,$(filter globalnet,$(_using)))
override DEPLOY_ARGS += --globalnet
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
