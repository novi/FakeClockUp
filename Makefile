include theos/makefiles/common.mk

TWEAK_NAME = FakeClockUp
FakeClockUp_FILES = Tweak.xm

#export THEOS_PLATFORM_SDK_ROOT_armv6 = /Applications/Xcode_4.4.1.app/Contents/Developer
#export SDKVERSION_armv6 = 5.1
export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.3.0
export TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64 = 7.0 
export ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk
