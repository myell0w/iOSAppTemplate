// Part of iOSAppTemplate http://foundationk.it

#import "FKIncludes.h"

/**
 This class serves as the superclass for all ViewController in the App
 */
@interface FKBaseViewController : UIViewController <FKReachabilityAware> {
    /** flag to control if a reachability-notification is sent in viewDidLoad */
    BOOL sendInitialReachabilityNotification;
}

/** setup the UI for the current interface orientation */
- (void)updateUI;
/** setup the UI for a given interface orientation */
- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void)applicationDidBecomeActive:(NSNotification *)notification;

@end
