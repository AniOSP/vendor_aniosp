# Build fingerprint
ifeq ($(BUILD_FINGERPRINT),)
BUILD_NUMBER_ANIOSP := $(shell date -u +%H%M)
ANIOSP_DEVICE ?= $(TARGET_DEVICE)
ifneq ($(filter OFFICIAL,$(ANIOSP_BUILD_TYPE)),)
BUILD_SIGNATURE_KEYS := release-keys
else
BUILD_SIGNATURE_KEYS := test-keys
endif
BUILD_FINGERPRINT := $(PRODUCT_BRAND)/$(ANIOSP_DEVICE)/$(ANIOSP_DEVICE):$(PLATFORM_VERSION)/$(BUILD_ID)/$(BUILD_NUMBER_ANIOSP):$(TARGET_BUILD_VARIANT)/$(BUILD_SIGNATURE_KEYS)
endif
ADDITIONAL_SYSTEM_PROPERTIES  += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)

# AOSP recovery flashing
ifeq ($(TARGET_USES_AOSP_RECOVERY),true)
ADDITIONAL_SYSTEM_PROPERTIES  += \
    persist.sys.recovery_update=true
endif

# Versioning props
ADDITIONAL_SYSTEM_PROPERTIES  += \
    org.aniosp.version=$(ANIOSP_VERSION_PROP) \
    org.aniosp.version.display=$(ANIOSP_VERSION) \
    org.aniosp.build_date=$(ANIOSP_BUILD_DATE) \
    org.aniosp.build_date_utc=$(ANIOSP_BUILD_DATE_UTC) \
    org.aniosp.build_type=$(ANIOSP_BUILD_TYPE)
