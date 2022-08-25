# Telephony

IS_PHONE := true

# World APN list
PRODUCT_PACKAGES += \
    apns-conf.xml

<<<<<<< HEAD
# Telephony packages
PRODUCT_PACKAGES += \
    Stk
=======
# Include Lineage LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/lineage/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/lineage/overlay/dictionaries
>>>>>>> 33fe58bd (config: Exclude LatinIME dictionaries from RRO overlays)

# Tethering - allow without requiring a provisioning app
# (for devices that check this)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    net.tethering.noprovisioning=true

# Inherit full common AniOSP stuff
$(call inherit-product, vendor/aniosp/config/common_full.mk)
