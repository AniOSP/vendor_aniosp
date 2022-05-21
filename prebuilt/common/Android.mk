LOCAL_PATH := $(call my-dir)

################################
# Copies the APN list file into system/etc for the product as apns-conf.xml.
# In the case where $(ANIOSP_APNS_FILE) is defined, the content of $(ANIOSP_APNS_FILE)
# is added or replaced to the $(DEFAULT_APNS_FILE).
include $(CLEAR_VARS)

LOCAL_MODULE := apns-conf.xml
LOCAL_MODULE_CLASS := ETC

DEFAULT_APNS_FILE := vendor/aniosp/prebuilt/common/etc/apns-conf.xml

ifdef ANIOSP_APNS_FILE
ANIOSP_APNS_SCRIPT := vendor/aniosp/tools/custom_apns.py
FINAL_APNS_FILE := $(local-generated-sources-dir)/apns-conf.xml

$(FINAL_APNS_FILE): PRIVATE_SCRIPT := $(ANIOSP_APNS_SCRIPT)
$(FINAL_APNS_FILE): PRIVATE_ANIOSP_APNS_FILE := $(ANIOSP_APNS_FILE)
$(FINAL_APNS_FILE): $(ANIOSP_APNS_SCRIPT) $(DEFAULT_APNS_FILE)
	rm -f $@
	python $(PRIVATE_SCRIPT) $@ $(PRIVATE_ANIOSP_APNS_FILE)
else
FINAL_APNS_FILE := $(DEFAULT_APNS_FILE)
endif

LOCAL_PREBUILT_MODULE_FILE := $(FINAL_APNS_FILE)

include $(BUILD_PREBUILT)
