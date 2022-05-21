ifneq ($(filter OFFICIAL CI,$(ANIOSP_BUILD_TYPE)),)
PRODUCT_PACKAGES += \
    Updates
endif
