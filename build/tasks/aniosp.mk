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

$(OTA_PACKAGE_TARGET): $(BUILT_TARGET_FILES_PACKAGE) build/tools/releasetools/ota_from_target_files
	@echo "AniOSP: $@"
	    $(OTA_FROM_TARGET_FILES) --verbose \
	    --block \
	    --backup=true \
	    -p $(OUT_DIR)/host/linux-x86 \
	    $(BUILT_TARGET_FILES_PACKAGE) $@

	$(hide) $(SHA1SUM) $(OTA_PACKAGE_TARGET) | sed "s|$(PRODUCT_OUT)/||" > $(OTA_PACKAGE_TARGET).sha1sum
	$(hide) ./vendor/aniosp/tools/generate_json_build_info.sh $(OTA_PACKAGE_TARGET)
	@echo "Generating changelog for unsigned"
	$(hide) ./vendor/aniosp/tools/changelog.sh
	$(hide) mv Changelog.txt $(OTA_PACKAGE_TARGET).txt

.PHONY: aniosp
aniosp: otatools brillo_update_payload checkvintf $(OTA_PACKAGE_TARGET)

ifeq ($(ANIOSP_BUILD_TYPE), OFFICIAL)

SIGNED_TARGET_FILES_PACKAGE := $(PRODUCT_OUT)/$(TARGET_DEVICE)-target_files-$(BUILD_ID).zip
SIGN_FROM_TARGET_FILES := $(HOST_OUT_EXECUTABLES)/sign_target_files_apks$(HOST_EXECUTABLE_SUFFIX)

$(SIGNED_TARGET_FILES_PACKAGE): $(BUILT_TARGET_FILES_PACKAGE) build/tools/releasetools/sign_target_files_apks
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

$(PROD_OTA_PACKAGE_TARGET): $(SIGNED_TARGET_FILES_PACKAGE) build/tools/releasetools/ota_from_target_files
	@echo "AniOSP Production: $@"
	    $(OTA_FROM_TARGET_FILES) --verbose \
	    --block \
	    --backup=true \
	    -p $(OUT_DIR)/host/linux-x86 \
	    -k $(KEY_CERT_PAIR) \
	    $(SIGNED_TARGET_FILES_PACKAGE) $@

	$(hide) $(SHA1SUM) $(PROD_OTA_PACKAGE_TARGET) | sed "s|$(PRODUCT_OUT)/||" > $(PROD_OTA_PACKAGE_TARGET).sha1sum
	$(hide) ./vendor/aniosp/tools/generate_json_build_info.sh $(PROD_OTA_PACKAGE_TARGET)
	@echo "Generating changelog for production"
	$(hide) ./vendor/aniosp/tools/changelog.sh
	$(hide) mv Changelog.txt $(PROD_OTA_PACKAGE_TARGET).txt

.PHONY: aniosp-prod
aniosp-prod: otatools brillo_update_payload checkvintf $(PROD_OTA_PACKAGE_TARGET)

GEN_CHANGELOG := $(PROD_OTA_PACKAGE_TARGET).txt

$(GEN_CHANGELOG): $(BRO)

$(GEN_CHANGELOG):
	@echo "Generating changelog for production"
	$(hide) ./vendor/aniosp/tools/changelog.sh
	$(hide) mv Changelog.txt $(PROD_OTA_PACKAGE_TARGET).txt

.PHONY: gen-changelog
gen-changelog: $(GEN_CHANGELOG)

endif
