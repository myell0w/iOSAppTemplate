#import "FKConstants.h"
#import "FoundationKit.h"


const struct FKConstantStruct FKConstant = {
    .URL = {
        .Reachability               = @"www.google.com",
        .Hockey                     = @"www.yourotadistributionserver.com/betaapps/"
    },
    
    .Notification = {
        .ApplicationWillSuspend     = @"kFKApplicationWillSuspendNotification"
    },
    
    .Time = {
        .PostFinishLaunchDelay      = 1.5,
        .AnimationDuration          = 0.4
    }
};