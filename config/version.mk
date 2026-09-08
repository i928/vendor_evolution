PRODUCT_VERSION_MAJOR = 16
PRODUCT_VERSION_MINOR = 0

# Increase EVO Version with each major release.
EVO_VERSION_BASE := 11.10
EVO_BUILD_TYPE ?= Unofficial

ifeq ($(EVO_BUILD_TYPE),Official)
else ifeq ($(EVO_BUILD_TYPE),Unofficial)
else
$(error EVO_BUILD_TYPE must be Official or Unofficial. Current value: $(EVO_BUILD_TYPE))
endif

ifeq ($(WITH_GMS),true)
EVO_VERSION := $(EVO_VERSION_BASE)
else
EVO_VERSION := $(EVO_VERSION_BASE)-Vanilla
endif

# Internal version
# Timestamp is %Y%m%d-%H%M, not just %Y%m%d: two builds on the same day would
# otherwise produce the same zip name and the second would silently replace
# the first, losing the earlier artifact (and its .sha256sum/.json).
#
# Read it from BUILD_DATETIME_FILE rather than calling date directly.
# LINEAGE_VERSION is :=, so $(shell date) runs once per MAKE INVOCATION -- and a
# build has several. With date-only that was invisible; with HH:MM it produced a
# real mismatch: the 2026-09-08 build stamped ro.evolution.build.version with
# 12:13 while naming the zip 12:16. BUILD_DATETIME_FILE (out/build_date.txt) is
# fixed for the whole build, so every consumer agrees.
LINEAGE_BUILD_TIMESTAMP := $(shell cat $(BUILD_DATETIME_FILE) 2>/dev/null || date +%s)
LINEAGE_VERSION := EvolutionX-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -d @$(LINEAGE_BUILD_TIMESTAMP) +%Y%m%d-%H%M)-$(LINEAGE_BUILD)-$(EVO_VERSION)-$(EVO_BUILD_TYPE)

# Display version
LINEAGE_DISPLAY_VERSION := v$(EVO_VERSION)-$(shell date +%Y%m%d)

# Evolution X version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.evolution.build.type=$(EVO_BUILD_TYPE) \
    ro.evolution.build.version=$(LINEAGE_VERSION) \
    ro.evolution.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.evolution.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(EVO_VERSION)
