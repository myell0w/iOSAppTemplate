// Part of iOSAppTemplate http://foundationk.it

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Template Configuration
////////////////////////////////////////////////////////////////////////

// time interval in seconds after which additional setup is done after app startup
#define kFKPostFinishLaunchDelay                    FKTimeIntervalSeconds(1.5)
// if defined, we try to load a nag-message from a defined URL that can be shown in the app
#define kFKLoadNagMessage
// the URL we load the nag-message from
#define kFKNagMessageURL                            @"TODO"

#if TARGET_IPHONE_SIMULATOR
  #define kFKDCIntrospectEnabled                    // DCInstrospect, awesome visual debugging
#endif

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Notifications
////////////////////////////////////////////////////////////////////////

#define kFKApplicationWillSuspendNotification       @"kFKApplicationWillSuspendNotification"

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Constants
////////////////////////////////////////////////////////////////////////

#define kFKAnimationDuration                        FKTimeIntervalSeconds(0.4)

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark URLs
////////////////////////////////////////////////////////////////////////

#define kFKReachabilityHostAddress                  @"www.google.at"