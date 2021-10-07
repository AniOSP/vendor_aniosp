ANIOSP_BUILD_TYPE ?= UNOFFICIAL

ANIOSP_DATE_YEAR := $(shell date -u +%Y)
ANIOSP_DATE_MONTH := $(shell date -u +%m)
ANIOSP_DATE_DAY := $(shell date -u +%d)
ANIOSP_DATE_HOUR := $(shell date -u +%H)
ANIOSP_DATE_MINUTE := $(shell date -u +%M)
ANIOSP_BUILD_DATE_UTC := $(shell date -d '$(ANIOSP_DATE_YEAR)-$(ANIOSP_DATE_MONTH)-$(ANIOSP_DATE_DAY) $(ANIOSP_DATE_HOUR):$(ANIOSP_DATE_MINUTE) UTC' +%s)
ANIOSP_BUILD_DATE := $(ANIOSP_DATE_YEAR)$(ANIOSP_DATE_MONTH)$(ANIOSP_DATE_DAY)-$(ANIOSP_DATE_HOUR)$(ANIOSP_DATE_MINUTE)

ANIOSP_PLATFORM_VERSION := 12.1

ANIOSP_VERSION := AniOSP_$(ANIOSP_BUILD)-$(ANIOSP_PLATFORM_VERSION)-$(ANIOSP_BUILD_DATE)-$(ANIOSP_BUILD_TYPE)
ANIOSP_VERSION_PROP := shizuku

BUILD_ID_LC ?= $(shell echo $(BUILD_ID) | tr '[:upper:]' '[:lower:]')

PRODUCT_GENERIC_PROPERTIES += \
    org.aniosp.version=$(ANIOSP_VERSION_PROP) \
    org.aniosp.version.display=$(ANIOSP_VERSION) \
    org.aniosp.build_date=$(ANIOSP_BUILD_DATE) \
    org.aniosp.build_date_utc=$(ANIOSP_BUILD_DATE_UTC) \
    org.aniosp.build_type=$(ANIOSP_BUILD_TYPE)

$(call inherit-product-if-exists, vendor/aniosp/build/target/product/security/evolution_security.mk)

PRODUCT_HOST_PACKAGES += \
    sign_target_files_apks \
    ota_from_target_files
