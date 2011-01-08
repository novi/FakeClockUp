
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <objc/objc.h>
#include <objc/object.h>
#include <objc/runtime.h>
#include "substrate.h"


static float durMulti = 1.0;


@protocol AnimHook<NSObject>

-(void) __orig_setDuration:(NSTimeInterval)duration;

@end


static void __CAAnimation_setDuration(id<AnimHook> selfobj, SEL sel, NSTimeInterval duration)
{
//	NSLog(@"%s, %f", sel, duration);
	[selfobj __orig_setDuration:duration*durMulti];
}

extern "C" void FakeClockUpInitialize() {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	Class _$CAAnimation = objc_getClass("CAAnimation");
	MSHookMessage(_$CAAnimation, @selector(setDuration:), (IMP) &__CAAnimation_setDuration, "__orig_");
	
	
	NSLog(@"FakeClockUp Initialize-----");
	
	NSDictionary* udDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/jp.novi.FakeClockUp.plist"];
	//NSLog(@"%@", udDict);
	
	if (udDict) {
		float durm = [[udDict objectForKey:@"duration"] floatValue];
		if (durm != 0.0 && durm >= 0.001 && durm <= 20) {
			durMulti = durm;
		}
	}
	
	
	[pool release];
}
