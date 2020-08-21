ifneq (,$(DAPPER_HOST_ARCH))

# Running in Dapper

include $(SHIPYARD_DIR)/Makefile.inc

CLUSTER_SETTINGS_FLAG = --cluster_settings $(DAPPER_SOURCE)/cluster_settings
override CLUSTERS_ARGS += $(CLUSTER_SETTINGS_FLAG)
override DEPLOY_ARGS += $(CLUSTER_SETTINGS_FLAG) --deploytool helm
export DEPLOY_ARGS

# Targets to make

deploy: clusters preload-images

preload-images:
	source $(SCRIPTS_DIR)/lib/debug_functions; \
	source $(SCRIPTS_DIR)/lib/deploy_funcs; \
	source $(SCRIPTS_DIR)/lib/version; \
	set -e; \
	for image in submariner submariner-route-agent submariner-operator lighthouse-agent submariner-globalnet lighthouse-coredns; do \
		import_image quay.io/submariner/$${image}; \
	done

.PHONY: preload-images

else

# Not running in Dapper

include Makefile.dapper

endif

# Disable rebuilding Makefile
Makefile Makefile.dapper Makefile.inc: ;
