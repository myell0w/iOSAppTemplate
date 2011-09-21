// Part of iOSAppTemplate http://foundationk.it

#import <UIKit/UIKit.h>
#import "FKIncludes.h"

@interface FKBaseViewController : UIViewController <FKReachabilityAware> {
    BOOL sendInitialReachabilityNotification;
}

- (void)updateUI;
- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
