#import "AppDelegate.h"
#import "FKBaseViewController.h"
#import "DCIntrospect.h"

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
        NSLog(@"NSZombieEnabled / NSAutoreleaseFreedObjectCheckEnabled enabled! Disable for release.");
    }
    
    // Setup Window
    self.rootViewController = [FKBaseViewController viewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    
    if (kFKPostFinishLaunchDelay > 0.) {
        [self performSelector:@selector(postFinishLaunch) withObject:nil afterDelay:kFKPostFinishLaunchDelay];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
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
    // TODO:
}

@end
