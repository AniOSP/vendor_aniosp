#
# Copyright (C) 2018-2019 The Pixel3ROM Project
# Copyright (C) 2020 Raphielscape LLC. and Haruka LLC.
# Copyright (C) 2021 Haruka Aita
# Copyright (C) 2021 The Evolution X Project
# Copyright (C) 2022 AniOSP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

OTA_PACKAGE_TARGET := $(PRODUCT_OUT)/$(ANIOSP_VERSION)-unsigned.zip

$(OTA_PACKAGE_TARGET): $(BRO)

$(OTA_PACKAGE_TARGET): $(BUILT_TARGET_FILES_PACKAGE) \
		build/tools/releasetools/ota_from_target_files
	@echo "aniosp: $@"
	    $(OTA_FROM_TARGET_FILES) --verbose \
	    --block \
	    -p $(OUT_DIR)/host/linux-x86 \
	    $(BUILT_TARGET_FILES_PACKAGE) $@

	$(hide) $(MD5SUM) $(OTA_PACKAGE_TARGET) | sed "s|$(PRODUCT_OUT)/||" > $(OTA_PACKAGE_TARGET).md5sum
	$(hide) ./vendor/aniosp/tools/generate_json_build_info.sh $(OTA_PACKAGE_TARGET)

.PHONY: aniosp
aniosp: brillo_update_payload checkvintf $(OTA_PACKAGE_TARGET)

ifeq ($(ANIOSP_BUILD_TYPE), OFFICIAL)

SIGNED_TARGET_FILES_PACKAGE := $(PRODUCT_OUT)/$(TARGET_DEVICE)-target_files-$(BUILD_ID_LC).zip
SIGN_FROM_TARGET_FILES := $(HOST_OUT_EXECUTABLES)/sign_target_files_apks$(HOST_EXECUTABLE_SUFFIX)

$(SIGNED_TARGET_FILES_PACKAGE): $(BUILT_TARGET_FILES_PACKAGE) \
		build/tools/releasetools/sign_target_files_apks
	@echo "Package signed target files: $@"
	    $(SIGN_FROM_TARGET_FILES) --verbose \
	    -o \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -d $(PROD_CERTS) \
	    $(BUILT_TARGET_FILES_PACKAGE) $@

.PHONY: signed-target-files-package
signed-target-files-package: $(SIGNED_TARGET_FILES_PACKAGE)

PROD_OTA_PACKAGE_TARGET := $(PRODUCT_OUT)/$(ANIOSP_VERSION).zip

$(PROD_OTA_PACKAGE_TARGET): KEY_CERT_PAIR := $(PROD_CERTS)/releasekey

$(PROD_OTA_PACKAGE_TARGET): $(BRO)

$(PROD_OTA_PACKAGE_TARGET): $(SIGNED_TARGET_FILES_PACKAGE) \
		build/tools/releasetools/ota_from_target_files
	@echo "aniosp production: $@"
	    $(OTA_FROM_TARGET_FILES) --verbose \
	    --block \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -k $(KEY_CERT_PAIR) \
	    $(SIGNED_TARGET_FILES_PACKAGE) $@

	$(hide) $(MD5SUM) $(PROD_OTA_PACKAGE_TARGET) | sed "s|$(PRODUCT_OUT)/||" > $(PROD_OTA_PACKAGE_TARGET).md5sum
	$(hide) ./vendor/aniosp/tools/generate_json_build_info.sh $(PROD_OTA_PACKAGE_TARGET)

.PHONY: aniosp-prod
aniosp-prod: brillo_update_payload checkvintf $(PROD_OTA_PACKAGE_TARGET)

ifneq ($(PREVIOUS_TARGET_FILES_PACKAGE),)

INCREMENTAL_OTA_PACKAGE_TARGET := $(PRODUCT_OUT)/incremental-$(ANIOSP_VERSION).zip

$(INCREMENTAL_OTA_PACKAGE_TARGET): KEY_CERT_PAIR := $(PROD_CERTS)/releasekey

$(INCREMENTAL_OTA_PACKAGE_TARGET): $(BRO)

$(INCREMENTAL_OTA_PACKAGE_TARGET): $(SIGNED_TARGET_FILES_PACKAGE) \
		build/tools/releasetools/ota_from_target_files
	@echo "aniosp incremental production: $@"
	    $(OTA_FROM_TARGET_FILES) --verbose \
	    --block \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -k $(KEY_CERT_PAIR) \
	    -i $(PREVIOUS_TARGET_FILES_PACKAGE) \
	    $(SIGNED_TARGET_FILES_PACKAGE) $@

	$(hide) $(MD5SUM) $(INCREMENTAL_OTA_PACKAGE_TARGET) | sed "s|$(PRODUCT_OUT)/||" > $(INCREMENTAL_OTA_PACKAGE_TARGET).md5sum
	$(hide) ./vendor/aniosp/tools/generate_json_build_info.sh $(INCREMENTAL_OTA_PACKAGE_TARGET)

.PHONY: incremental-ota
incremental-ota: brillo_update_payload checkvintf $(INCREMENTAL_OTA_PACKAGE_TARGET)

endif

endif
