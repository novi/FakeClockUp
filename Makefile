 # Makefile for iPhone Application for Xcode gcc compiler (SDK Headers)

IP=10.0.1.12
#IP=169.254.148.240

TargetName=FakeClockUp
Objects=$(TargetName).o
Target=$(TargetName).dylib
Plist=$(TargetName).plist


SDKVER=4.2
SDK=/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$(SDKVER).sdk

CC=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin10-gcc-4.2.1
CPP=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin10-g++-4.2.1
LD=$(CC)

LDFLAGS += -lsubstrate
LDFLAGS += -Werror
LDFLAGS += -Wall
LDFLAGS += -init _$(TargetName)Initialize
LDFLAGS += -lobjc
LDFLAGS += -lsqlite3
LDFLAGS += -ObjC++
LDFLAGS += -fobjc-exceptions
LDFLAGS += -fobjc-call-cxx-cdtors
//LDFLAGS += -march=armv6
//LDFLAGS += -mcpu=arm1176jzf-s
LDFLAGS += -dynamiclib
LDFLAGS += -bind_at_load
LDFLAGS += -multiply_defined suppress
LDFLAGS += -framework CoreFoundation 
LDFLAGS += -framework Foundation 
LDFLAGS += -framework UIKit 
LDFLAGS += -framework CoreGraphics
//LDFLAGS += -framework AddressBookUI
//LDFLAGS += -framework AddressBook
//LDFLAGS += -framework MobileMusicPlayer
//LDFLAGS += -framework QuartzCore
//LDFLAGS += -framework GraphicsServices
//LDFLAGS += -framework CoreSurface
//LDFLAGS += -framework CoreAudio
LDFLAGS += -framework CoreLocation
//LDFLAGS += -framework Celestial
//LDFLAGS += -framework AudioToolbox
//LDFLAGS += -framework WebCore
//LDFLAGS += -framework WebKit
//LDFLAGS += -framework SystemConfiguration
//LDFLAGS += -framework CFNetwork
//LDFLAGS += -framework MediaPlayer
//LDFLAGS += -framework OpenGLES
//LDFLAGS += -framework OpenAL
LDFLAGS += -L./
LDFLAGS += -L"$(SDK)/usr/lib"
LDFLAGS += -F"$(SDK)/System/Library/Frameworks"
LDFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"

CFLAGS += -dynamiclib
CFLAGS += -I"/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/gcc/arm-apple-darwin9/4.2.1/include/"
CFLAGS += -I"$(SDK)/usr/include"
CFLAGS += -I./
CFLAGS += -I"/Developer/Platforms/iPhoneOS.platform/Developer/usr/include/"
CFLAGS += -I/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator$(SDKVER).sdk/usr/include
CFLAGS += -DDEBUG -std=c99
CFLAGS += -Diphoneos_version_min=4.0
CFLAGS += -O2
CFLAGS += -F"$(SDK)/System/Library/Frameworks"
CFLAGS += -F"$(SDK)/System/Library/PrivateFrameworks"

CPPFLAGS=$CFLAGS



all: $(Target)

install:
		chmod 755 $(Target)
		#scp $(Plist) root@$(IP):/Library/MobileSubstrate/DynamicLibraries
		scp $(Target) root@"$(IP)":/Library/MobileSubstrate/DynamicLibraries
		#ssh root@$(IP) chmod 755 $(Target) 
		#ssh root@$(IP) mv $(Target) /Library/MobileSubstrate/DynamicLibraries
		#ssh root@$(IP) killall SpringBoard

$(Target): $(Objects)
		$(CPP) $(LDFLAGS) -o $@ $^
		ldid -S $(Target)

%.o:	%.mm
		$(CPP) -c $(CFLAGS) $< -o $@

clean:
		rm -f *.o $(Target)
