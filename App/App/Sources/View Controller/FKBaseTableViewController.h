// Part of iOSAppTemplate http://foundationk.it

#import "FKBaseViewController.h"

@interface FKBaseTableViewController : FKBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, readonly) UITableViewStyle tableViewStyle;
@property (nonatomic, assign) BOOL useShadows;

- (id)initWithStyle:(UITableViewStyle)style;

// Subclasses can override to customize even more
- (UITableView *)customizedTableView;

@end
