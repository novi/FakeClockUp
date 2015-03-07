include theos/makefiles/common.mk

TWEAK_NAME = FakeClockUp
FakeClockUp_FILES = Tweak.xm
FakeClockUp_FRAMEWORKS = UIKit
ADDITIONAL_OBJCFLAGS = -fobjc-arc
SUBPROJECTS += fakeclockupprefs

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
