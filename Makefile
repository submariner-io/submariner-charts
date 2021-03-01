ifneq (,$(DAPPER_HOST_ARCH))

# Running in Dapper

include $(SHIPYARD_DIR)/Makefile.inc

CLUSTER_SETTINGS_FLAG = --cluster_settings $(DAPPER_SOURCE)/cluster_settings
override CLUSTERS_ARGS += $(CLUSTER_SETTINGS_FLAG)
override DEPLOY_ARGS += $(CLUSTER_SETTINGS_FLAG) --deploytool helm --deploytool_broker_args '--set submariner.serviceDiscovery=true'
export DEPLOY_ARGS
GH_URL=https://submariner-io.github.io/submariner-charts/charts
CHARTS_DIR=charts
CHARTS_VERSION=0.7.0
REPO_URL=$(shell git config remote.origin.url)

# Targets to make

deploy: clusters preload-images

e2e: E2E_ARGS=cluster1 cluster2

preload-images:
	source $(SCRIPTS_DIR)/lib/debug_functions; \
	source $(SCRIPTS_DIR)/lib/deploy_funcs; \
	set -e; \
	for image in submariner submariner-route-agent submariner-operator lighthouse-agent submariner-globalnet lighthouse-coredns; do \
		import_image quay.io/submariner/$${image}; \
	done

%.tgz:
	helm dep update $(subst -$(CHARTS_VERSION),,$(basename $(@F)))
	helm package --version $(CHARTS_VERSION) $(subst -$(CHARTS_VERSION),,$(basename $(@F)))

release: submariner-$(CHARTS_VERSION).tgz submariner-k8s-broker-$(CHARTS_VERSION).tgz submariner-operator-$(CHARTS_VERSION).tgz
	git checkout gh-pages
	mv *.tgz $(CHARTS_DIR)
	if [ -f $(CHARTS_DIR)/index.yaml ]; then \
	  helm repo index $(CHARTS_DIR) --url $(GH_URL) --merge $(CHARTS_DIR)/index.yaml; \
	else \
	  helm repo index $(CHARTS_DIR) --url $(GH_URL); \
	fi

.PHONY: preload-images release

else

# Not running in Dapper

include Makefile.dapper

endif

# Disable rebuilding Makefile
Makefile Makefile.dapper Makefile.inc: ;
