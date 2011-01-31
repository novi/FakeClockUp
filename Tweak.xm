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

__attribute__((constructor)) 
static void FakeClockUp_initializer() 
{ 
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
  NSDictionary *udDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/jp.novi.FakeClockUp.plist"];

  if (udDict) {
    float durm = [[udDict objectForKey:@"duration"] floatValue];
    if (durm != 0.0 && durm >= 0.001 && durm <= 20) {
      durMulti = durm;
    }
  }
	
	[pool release];
}