#import "FKBaseViewController.h"


@implementation FKBaseViewController

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController
////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Rotation
////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return FKRotateOnPad(toInterfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self setupForInterfaceOrientation:toInterfaceOrientation];
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKBaseViewController
////////////////////////////////////////////////////////////////////////

- (void)updateUI {
    [self setupForInterfaceOrientation:$appOrientation];
}

- (void)setupForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // UIView+FKRotation
    [self.view setSubviewFramesForInterfaceOrientation:interfaceOrientation];
}

@end
