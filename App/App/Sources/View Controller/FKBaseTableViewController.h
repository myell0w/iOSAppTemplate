// Part of iOSAppTemplate http://foundationk.it

#import "FKBaseViewController.h"

/**
 This class serves as the superclass for all tableViewControllers in the App
 */
@interface FKBaseTableViewController : FKBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, readonly) UITableViewStyle tableViewStyle;
@property (nonatomic, assign) BOOL clearsSelectionOnViewWillAppear;
/** Flag to control if the tableView shows shadows on top and bottom */
@property (nonatomic, assign) BOOL useShadows;

/** The designated initializer of the tableViewController */
- (id)initWithStyle:(UITableViewStyle)style;

/** 
 Returns a customized tableView, subclasses can override to customize more
 @return a shadowed tableView, if useShadows = YES, else a normal tableView
 */
- (UITableView *)customizedTableView;

@end
