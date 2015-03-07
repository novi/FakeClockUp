#import <UIKit/UIKit.h>
//#import <QuartzCore/CASpringAnimation.h>

static float durMulti = 1.0;

// default value
static float g_durationMultiSpring = 1.0;
static float g_velocityMultiSpring = 1.0;
static float g_stiffnessMultiSpring = 1.8;
static float g_massMultiSpring = 0.5;
static float g_dampingMultiSpring = 1.0;

static BOOL FCEditing = NO;
static BOOL disableOnEdit = YES;
static BOOL appExempted = NO;

static Class CASpringAnimationClass = Nil;

%hook CASpringAnimation

/*- (double)durationForEpsilon:(double)arg1
{
	NSLog(@"durationForEpsilon DUR %@, %f %f, %f-%f-%f-%f", self, arg1, [self duration], [self stiffness], [self velocity], [self mass], [self damping]);
	return %orig(arg1);
}
*/

- (void)setDamping:(CGFloat)arg1
{
  //%log;
  if (appExempted) {
    %orig;
  } else {
    %orig(arg1 * g_dampingMultiSpring);	
  }
}
- (void)setMass:(CGFloat)arg1
{
  //%log;
  if (appExempted) {
    %orig;
  } else {
    %orig(arg1 * g_massMultiSpring);
  }
}
- (void)setStiffness:(CGFloat)arg1
{
  //%log;
  if (appExempted) {
    %orig;
  } else {
    %orig(arg1 * g_stiffnessMultiSpring );
  }
}
- (void)setVelocity:(CGFloat)arg1
{
  //%log;
  if (appExempted) {
    %orig;
  } else {
    %orig(arg1 * g_velocityMultiSpring);
  }
}

- (void)setDuration:(NSTimeInterval)duration
{
  //%log;
  if (appExempted) {
    %orig;
  } else {
    %orig(duration * g_durationMultiSpring);
  }
}
%end

%hook CAAnimation
- (void)setDuration:(NSTimeInterval)duration
{
  if ([self isKindOfClass:[CASpringAnimationClass class]]) {
    //%log;
    %orig(duration);
    return;
  }
  if (FCEditing && disableOnEdit) {
    %orig(duration);
  } else {
    if (appExempted) {
      %orig;
    } else {
      %orig(duration * durMulti);
    }
  }
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

  NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
  NSString *settingsKeyPrefix = @"Exempt-";

  if ([[udDict allKeys] containsObject:[NSString stringWithFormat:@"%@%@", settingsKeyPrefix, bundleID]]) {
    if ([[udDict objectForKey:[NSString stringWithFormat:@"%@%@", settingsKeyPrefix, bundleID]] boolValue]) {
      appExempted =  YES;
    } else {
      appExempted =  NO;
    }
  }

  id durationExist = [udDict objectForKey:@"duration"];
  float durm = durationExist ? [durationExist floatValue] : 0.4;
  if (durm != 0.0 && durm >= 0.001 && durm <= 20)
    durMulti = durm;
  
  if ([udDict objectForKey:@"disableOnEdit"]) {
    disableOnEdit = [[udDict objectForKey:@"disableOnEdit"] boolValue];
  }
  
  NSArray* springAnimSettings = @[
	  @"durationMultiSpring", // setting key
	  @"velocityMultiSpring",
	  @"stiffnessMultiSpring",
	  @"massMultiSpring",  
	  @"dampingMultiSpring"
  ];
  
  float* springAnimDst[] = { &g_durationMultiSpring, // current setting value pointer
  	                       &g_velocityMultiSpring,
	                       &g_stiffnessMultiSpring,
	                       &g_massMultiSpring,
	                       &g_dampingMultiSpring
						   };
  for(NSUInteger i = 0; i < springAnimSettings.count; i++) {
	  NSString* key = [springAnimSettings objectAtIndex:i];
	  float* dst = springAnimDst[i];
	  if ([udDict objectForKey:key]) {
		  *dst = [[udDict objectForKey:key] floatValue];
	  }
  }
}

static void ChangeNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
  LoadSettings();
}

%ctor
{ 
  //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  CASpringAnimationClass = NSClassFromString(@"CASpringAnimation");
  
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, ChangeNotification, CFSTR("jp.novi.FakeClockUp.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  LoadSettings();
  
  //[pool release];
}
