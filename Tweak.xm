static float durMulti = 1.0;

%hook CAAnimation
- (void)setDuration:(NSTimeInterval)duration
{
  duration *= durMulti;
  %orig;
}
%end

static void LoadSettings()
{
  NSDictionary *udDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/jp.novi.FakeClockUp.plist"];
  if (udDict) {
    id durationExsist = [udDict objectForKey:@"duration"];
    float durm = durationExsist ? [durationExsist floatValue] : 0.4;
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
  
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, ChangeNotification, CFSTR("jp.novi.FakeClockUp.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  LoadSettings();
  
  [pool release];
}