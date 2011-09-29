// Part of iOSAppTemplate http://foundationk.it

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Template Configuration
////////////////////////////////////////////////////////////////////////

#define kFKPostFinishLaunchDelay                    FKTimeIntervalSeconds(1.5)

#if TARGET_IPHONE_SIMULATOR
  #define kFKDCIntrospectEnabled                    // DCInstrospect, awesome visual debugging
#endif

#if DEBUG
  #define kFKLogToFile
#endif

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Logging
////////////////////////////////////////////////////////////////////////

#define FKLogVerbose(...)                           DDLogVerbose(__VA_ARGS__)
#define FKLogInfo(...)                              DDLogInfo(__VA_ARGS__)
#define FKLogWarning(...)                           DDLogWarn(__VA_ARGS__)
#define FKLogError(...)                             DDLogError(__VA_ARGS__)
#define Log(...)                                    FKLogInfo(@"%@", FKLogToString(__VA_ARGS__))
#define FKLogLocation()                             FKLogInfo(@"--- Logged ---")
#define FKNotImplemented()                          do { FKLogError(@"Not implemented yet."); [self doesNotRecognizeSelector:_cmd];} while(0)

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