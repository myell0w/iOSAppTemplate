// Part of iOSAppTemplate http://foundationk.it

#import "FKBaseTableViewController.h"

@interface FKBaseCollapsableTableViewController : FKBaseTableViewController

@property (nonatomic, copy) NSMutableIndexSet *expandedSections;
@property (nonatomic, assign) NSInteger minNumberOfRowsToCollapse;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionWhenCollapsed:(NSInteger)section;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionWhenExpanded:(NSInteger)section;

- (BOOL)tableView:(UITableView *)tableView isCollapseCellAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView isExpandCellAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView isDataCellAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section;

- (BOOL)tableView:(UITableView *)tableView isSectionExpanded:(NSInteger)section;
- (BOOL)tableView:(UITableView *)tableView isSectionCollapsed:(NSInteger)section;

- (void)tableView:(UITableView *)tableView collapseSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView expandSection:(NSInteger)section;

@end
