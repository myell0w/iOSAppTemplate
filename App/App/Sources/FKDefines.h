// Part of iOSAppTemplate http://foundationk.it

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Template Configuration
////////////////////////////////////////////////////////////////////////

// time interval in seconds after which additional setup is done after app startup
#define kFKPostFinishLaunchDelay                    FKTimeIntervalSeconds(1.5)

// DCInstrospect, awesome visual debugging
#if TARGET_IPHONE_SIMULATOR
  #define kFKDCIntrospectEnabled
#endif

// HockeyKit for Beta Updates
#ifndef CONFIGURATION_AppStore
    #define kFKUseHockeyKit
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
#define kFKHockeyKitUpdateURL                       @"www.yourotadistributionserver.com/betaapps/"
