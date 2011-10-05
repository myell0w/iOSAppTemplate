#import "AppDelegate.h"
#import "DCIntrospect.h"
#import "FKBaseViewController.h"
#import "FKDefines.h"
#import "AFJSONRequestOperation.h"

#ifndef APPSTORE
#import "BWHockeyManager.h"
#endif

@interface AppDelegate ()

- (void)applicationPrepareForBackgroundOrTermination:(UIApplication *)application;

- (void)postFinishLaunch;
- (void)setup;
- (void)loadNagMessage;

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
    [MagicalRecordHelpers cleanUp];
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
    FKLogInfo(@"detected application termination.");
    
    // post notification to all listeners
    [[NSNotificationCenter defaultCenter] postNotificationName:kFKApplicationWillSuspendNotification object:application];
    // save CoreData-Context for mainThread
    [[NSManagedObjectContext defaultContext] save];
}

- (void)postFinishLaunch {
    // visual debugging!
#ifdef kFKDCIntrospectEnabled
    [[DCIntrospect sharedIntrospector] start];
#endif
    
#ifdef kFKLoadNagMessage
    [self loadNagMessage];
#endif
    
#ifdef kFKUseHockeyKit
    [BWHockeyManager sharedHockeyManager].updateURL = kFKHockeyKitUpdateURL;
#endif
    
    // Listen for Reachability Notifications
    [[FKReachability sharedReachability] setupReachabilityFor:self];
}

- (void)setup {
    // Setup UserDefaults
    [[NSUserDefaults standardUserDefaults] registerDefaultsFromSettingsBundle];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Setup CoreData
    [MagicalRecordHelpers setupCoreDataStackWithAutoMigratingSqliteStoreNamed:FKApplicationName()];
    
    // Setup Reachability
    [[FKReachability sharedReachability] startCheckingHostAddress:kFKReachabilityHostAddress];
}

- (void)loadNagMessage {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kFKNagMessageURL]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation operationWithRequest:request success:^(id JSON) {
        BOOL showNagMessage = [[JSON valueForKey:@"showNagMessage"] boolValue];
        
        if (showNagMessage) {
            NSString *title = [JSON valueForKey:@"title"];
            NSString *message = [JSON valueForKey:@"message"];
            
            UIAlertView *alertView = [UIAlertView alertWithTitle:title message:message];
            [alertView show];
         }
    }];
    
    [operation start];
}

@end
