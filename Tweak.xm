#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

%hook CAAnimation

static float durMulti = 1.0;

- (void)setDuration:(NSTimeInterval)duration
{
  duration *= durMulti;
  %orig;
}

%end

static void LoadSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{	
	NSDictionary *udDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/jp.novi.FakeClockUp.plist"];
	if (udDict) {
		float durm = [[udDict objectForKey:@"duration"] floatValue];
		if (durm != 0.0 && durm >= 0.001 && durm <= 20) {
			durMulti = durm;
		}
	}	
}

__attribute__((constructor)) 
static void FakeClockUp_initializer() 
{ 
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, LoadSettings, CFSTR("jp.novi.FakeClockUp.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings(nil,nil,nil,nil,nil);
	
	[pool release];
}