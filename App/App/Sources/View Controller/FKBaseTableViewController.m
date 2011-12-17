#import "FKBaseTableViewController.h"
#import "UITableView+FKPlaceholder.h"

@interface FKBaseTableViewController ()

@property (nonatomic, assign, readwrite) UITableViewStyle tableViewStyle;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end

@implementation FKBaseTableViewController

$synthesize(tableView);
$synthesize(tableViewStyle);
$synthesize(useShadows);
$synthesize(clearsSelectionOnViewWillAppear);

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        tableViewStyle_ = style;
        useShadows_ = NO;
        clearsSelectionOnViewWillAppear_ = YES;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)dealloc {
    tableView_.delegate = nil;
    tableView_.dataSource = nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tableView == nil) {
        self.tableView = [self customizedTableView];
        [self.view addSubview:self.tableView];
    }
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([self.tableView respondsToSelector:@selector(setBackgroundView:)]) {
		[self.tableView setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (clearsSelectionOnViewWillAppear_) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - FKBaseTableViewController
////////////////////////////////////////////////////////////////////////

- (void)setTableView:(UITableView *)tableView {
    if (tableView_ != tableView) {
        tableView_ = tableView;
        tableView_.delegate = self;
        tableView_.dataSource = self;
    }
}

- (UITableView *)customizedTableView {
    UITableView *tableView = nil;
    
    if (self.useShadows) {
        tableView = [[FKShadowedTableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    } else {
        tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    }
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    return tableView;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FKLogNotImplemented();
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FKLogNotImplemented();
    return nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (void)keyboardWillShow:(NSNotification *)notification {
	// keyboard frame is in window coordinates
	NSDictionary *userInfo = [notification userInfo];
	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
	// convert own frame to window coordinates, frame is in superview's coordinates
	CGRect ownFrame = [self.tableView.window convertRect:self.tableView.frame fromView:self.tableView.superview];
    
	// calculate the area of own frame that is covered by keyboard
	CGRect coveredFrame = CGRectIntersection(ownFrame, keyboardFrame);
    
	// now this might be rotated, so convert it back
	coveredFrame = [self.tableView.window convertRect:coveredFrame toView:self.tableView.superview];
    
    [UIView animateWithDuration:animationDuration 
                          delay:0.f
                        options:(UIViewAnimationOptions)animationCurve
                     animations:^{
                         // set inset to make up for covered array at bottom
                         [self.tableView setContentAndScrollIndicatorInset:UIEdgeInsetsMake(0.f, 0.f, coveredFrame.size.height, 0.f)];
                     } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:animationDuration 
                          delay:0.f
                        options:(UIViewAnimationOptions)animationCurve
                     animations:^{
                         [self.tableView setContentAndScrollIndicatorInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
                     } completion:nil];
    
}

@end
