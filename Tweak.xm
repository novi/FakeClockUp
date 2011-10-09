#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SpringBoard/SpringBoard.h>

static float durMulti = 1.0;
static BOOL FCEditing = NO;

%hook CAAnimation

- (void)setDuration:(NSTimeInterval)duration
{
	if (!FCEditing)
		duration *= durMulti;
	%orig;
}

%end

%hook SBIconController

- (void)setIsEditing:(BOOL)editing
{
	FCEditing = editing;
	%orig;
}

%end

%hook SBAppSwitcherController

- (void)_beginEditing
{
	FCEditing = YES;
	%orig;
}

- (void)_stopEditing
{
	FCEditing = NO;
	%orig;
}

%end

static void LoadSettings()
{
	NSDictionary *udDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/jp.novi.FakeClockUp.plist"];
	if (udDict) {
    id durationExsist = [udDict objectForKey:@"duration"];
		float durm = durationExsist ? [durationExsist floatValue] : 1.0;
		if (durm != 0.0 && durm >= 0.001 && durm <= 20)
			durMulti = durm;
	}
}

static void ChangeNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
  LoadSettings();
}

%ctor
{ 
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, LoadSettings, CFSTR("jp.novi.FakeClockUp.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
	
	[pool release];
}