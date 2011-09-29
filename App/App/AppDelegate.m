#import "AppDelegate.h"
#import "DCIntrospect.h"
#import "FKBaseViewController.h"
#import "FKLogFormatter.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "FKDefines.h"


@interface AppDelegate ()

- (void)applicationPrepareForBackgroundOrTermination:(UIApplication *)application;

- (void)postFinishLaunch;
- (void)setup;

@end

@implementation AppDelegate

$synthesize(window);
$synthesize(rootViewController);

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Setup Logging, synchronize UserDefaults
    [self setup];
    
    // check for NSZombie (memory leak if enabled, but very useful!)
    if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        FKLogWarning(@"NSZombieEnabled / NSAutoreleaseFreedObjectCheckEnabled enabled! Disable for release.");
    }
    
    // Setup Window
    self.rootViewController = [FKBaseViewController viewController];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    
    if (kFKPostFinishLaunchDelay > 0.) {
        [self performSelector:@selector(postFinishLaunch) withObject:nil afterDelay:kFKPostFinishLaunchDelay];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self applicationPrepareForBackgroundOrTermination:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self applicationPrepareForBackgroundOrTermination:application];
}

///////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Reachability
///////////////////////////////////////////////////////////////////////

- (void)configureForNetworkStatus:(NSNotification *)notification {
    // NetworkStatus networkStatus = FKReachabilityGetNetworkStatus(notification);
    
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private
////////////////////////////////////////////////////////////////////////

- (void)applicationPrepareForBackgroundOrTermination:(UIApplication *)application {
    // DDLogInfo(@"detected application termination.");
    
    // post notification to all listeners
    [[NSNotificationCenter defaultCenter] postNotificationName:kFKApplicationWillSuspendNotification object:application];
}

- (void)postFinishLaunch {
    // visual debugging!
#ifdef kFKDCIntrospectEnabled
    [[DCIntrospect sharedIntrospector] start];
#endif
    
    // Setup Reachability
    [[FKReachability sharedReachability] startCheckingHostAddress:kFKReachabilityHostAddress];
    [[FKReachability sharedReachability] setupReachabilityFor:self];
}

- (void)setup {
    // Setup UserDefaults
    [[NSUserDefaults standardUserDefaults] registerDefaultsFromSettingsBundle];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Setup Logger
    FKLogFormatter *logFormatter = [[FKLogFormatter alloc] init];
    [[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
#ifdef DEBUG
    // log to file
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = FKTimeIntervalDays(1);
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
#endif
}

@end
