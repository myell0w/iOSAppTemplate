#import "FKBaseTableViewController.h"
#import "UITableView+FKPlaceholder.h"

@interface FKBaseTableViewController ()

@property (nonatomic, assign, readwrite) UITableViewStyle tableViewStyle;

@end

@implementation FKBaseTableViewController

$synthesize(tableView);
$synthesize(tableViewStyle);
$synthesize(useShadows);

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        tableViewStyle_ = style;
        useShadows_ = NO;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithStyle:UITableViewStylePlain];
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [self customizedTableView];
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([self.tableView respondsToSelector:@selector(setBackgroundView:)]) {
		[self.tableView setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (animated) {
        [self.tableView flashScrollIndicators];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKBaseViewController
////////////////////////////////////////////////////////////////////////

- (void)updateUI {
    [super updateUI];
    
    // If the tableView has no data, show placeholder instead
    // Subclasses must implement the delegate-method contentUnavailableViewForTableView:
    
    // TODO: does this check work, to determine if tableView is empty?
    if (self.tableView.visibleCells.count == 0) {
        [self.tableView setContentUnavailableViewHidden:NO];
    } else {
        [self.tableView setContentUnavailableViewHidden:YES];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKBaseTableViewController
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
       // TODO: Use shadowed tableView
        tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    } else {
        tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    }
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    return tableView;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource
////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FKLogNotImplemented();
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FKLogNotImplemented();
    return nil;
}

@end
