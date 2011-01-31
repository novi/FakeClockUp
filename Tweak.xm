#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

%hook CAAnimation

- (void)setDuration:(NSTimeInterval)duration
{
  NSDictionary* udDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/jp.novi.FakeClockUp.plist"];
	
  if (udDict) {
    float durm = [[udDict objectForKey:@"duration"] floatValue];
    if (durm != 0.0 && durm >= 0.001 && durm <= 20) {
      duration *= durm;
    }
  }
  return %orig;
}
%end