include theos/makefiles/common.mk

BUNDLE_NAME = FakeClockUp
FakeClockUp_FILES = FakeClockUp.mm
FakeClockUp_INSTALL_PATH = /Library/PreferenceBundles
FakeClockUp_FRAMEWORKS = UIKit
FakeClockUp_PRIVATE_FRAMEWORKS = Preferences
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FakeClockUp.plist$(ECHO_END)
