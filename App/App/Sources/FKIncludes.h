// Part of iOSAppTemplate http://foundationk.it

// Since Syntax-Highlighting and Auto-Comletion currently break under Xcode 4,
// if you put custom imports into your Precompiled Headers File, this file
// serves as a replacement that can be included into other files

// Frameworks
#import "FoundationKit.h"
#import "iOSKit.h"
#import "Reachability+FKAdditions.h"
#import "BlocksKit.h"

// Logging
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

// App-intern
#import "FKDefines.h"
#import "NSUserDefaults+FKAppAdditions.h"