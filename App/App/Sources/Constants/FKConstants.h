// Part of iOSAppTemplate http://foundationk.it

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Global App Constants
////////////////////////////////////////////////////////////////////////

extern const struct FKConstantStruct {
    /** URL Constants */
    struct {
        /** URL to determine Reachability */
        __unsafe_unretained NSString *Reachability;
        /** Hockey Beta Update URL */
        __unsafe_unretained NSString *Hockey;
    } URL;
    
    /** Notification Constants */
    struct {
        /** Notification that App will Suspend */
        __unsafe_unretained NSString *ApplicationWillSuspend;
    } Notification;
    
    /** Time Constants */
    struct {
        /** Delay after App launch to perform additional setup */
        NSTimeInterval PostFinishLaunchDelay;
        /** Default animation duration */
        NSTimeInterval AnimationDuration;
    } Time;
    
    /** Size Constants */
   // struct {

   // } Size;
} FKConstant;



////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Global App Defines
////////////////////////////////////////////////////////////////////////

#if TARGET_IPHONE_SIMULATOR
#define kFKDCIntrospectEnabled      // DCInstrospect, awesome visual debugging
#endif

#ifndef CONFIGURATION_AppStore
#define kFKUseHockeyKit             // HockeyKit for Beta Updates
#endif