#import <UIKit/UIKIt.h>
#import <Preferences/Preferences.h>

@interface FakeClockUpListController: PSListController {
}
- (void)twitter:(id)twitter;
- (void)twitter:(id)aboutme;
@end

@implementation FakeClockUpListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"FakeClockUp" target:self];
	}
	return _specifiers;
}

- (void)twitter:(id)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/novi_"]];
}

- (void)twitter2:(id)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/r_plus"]];
}

- (void)aboutme:(id)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://about.me/yusukeito"]];
}
@end

// vim:ft=objc
