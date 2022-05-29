# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
# Copyright (C) 2018,2020 The PixelExperience Project
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

ANIOSP_TARGET_PACKAGE := $(PRODUCT_OUT)/$(ANIOSP_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

.PHONY: bacon
bacon: $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) mv $(INTERNAL_OTA_PACKAGE_TARGET) $(ANIOSP_TARGET_PACKAGE)
	$(hide) $(MD5SUM) $(ANIOSP_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(ANIOSP_TARGET_PACKAGE).md5sum
	$(hide) ./vendor/aniosp/tools/generate_json_build_info.sh $(ANIOSP_TARGET_PACKAGE)

	@echo "${cya}Building ${bldcya}AniOSP...! ${txtrst}";
	@echo -e""
	@echo -e ${CL_YLW}"Zip  :"${CL_YLW} $(ANIOSP_VERSION).zip${CL_YLW}
	@echo -e ${CL_YLW}"MD5  :"${CL_YLW}" `cat $(ANIOSP_TARGET_PACKAGE).md5sum | awk '{print $$1}' `"${CL_YLW}
	@echo -e ${CL_YLW}"Size :"${CL_YLW}" `du -sh $(ANIOSP_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_YLW}
	@echo -e ${CL_YLW}"ID   :"${CL_YLW}" `sha256sum $(ANIOSP_TARGET_PACKAGE) | cut -d ' ' -f 1`"${CL_YLW}
	@echo -e ${CL_YLW}"Path :"${CL_YLW}" $(ANIOSP_TARGET_PACKAGE)"${CL_YLW}
	@echo -e ${CL_GRN}"***********************************************************"${CL_GRN}
