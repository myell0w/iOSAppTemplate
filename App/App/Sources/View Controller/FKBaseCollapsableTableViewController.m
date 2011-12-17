#import "FKBaseCollapsableTableViewController.h"

@implementation FKBaseCollapsableTableViewController

$synthesize(expandedSections);
$synthesize(minNumberOfRowsToCollapse);

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
        expandedSections_ = [[NSMutableIndexSet alloc] init];
        minNumberOfRowsToCollapse_ = 10;
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Collapsing
////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self tableView:tableView isSectionCollapsed:section]) {
        return [self tableView:tableView numberOfRowsInSectionWhenCollapsed:section];
    } else {
        int diff = [self tableView:tableView canCollapseSection:section] ? 1 : 0;
        return [self tableView:tableView numberOfRowsInSectionWhenExpanded:section] + diff;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionWhenCollapsed:(NSInteger)section {
    return self.minNumberOfRowsToCollapse + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionWhenExpanded:(NSInteger)section {
    FKLogNotImplemented();
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView isCollapseCellAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == [self tableView:tableView numberOfRowsInSectionWhenExpanded:indexPath.section];
}

- (BOOL)tableView:(UITableView *)tableView isExpandCellAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView isSectionCollapsed:indexPath.section] && indexPath.row == self.minNumberOfRowsToCollapse;
}

- (BOOL)tableView:(UITableView *)tableView isDataCellAtIndexPath:(NSIndexPath *)indexPath {
    return ![self tableView:tableView isExpandCellAtIndexPath:indexPath] &&
    ![self tableView:tableView isCollapseCellAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section {
    return [self tableView:tableView numberOfRowsInSectionWhenExpanded:section] > self.minNumberOfRowsToCollapse + 1;
}

- (BOOL)tableView:(UITableView *)tableView isSectionCollapsed:(NSInteger)section {
    return [self tableView:tableView canCollapseSection:section] && ![self.expandedSections containsIndex:section];
}

- (BOOL)tableView:(UITableView *)tableView isSectionExpanded:(NSInteger)section {
    return ![self tableView:tableView isSectionCollapsed:section];
}

- (void)tableView:(UITableView *)tableView collapseSection:(NSInteger)section {
    [self.expandedSections removeIndex:section];
    
    NSInteger numberOfRowsExpanded = [self tableView:tableView numberOfRowsInSectionWhenExpanded:section];
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (int i=self.minNumberOfRowsToCollapse+1;i<=numberOfRowsExpanded;i++) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:newIndexPath];
    }
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.minNumberOfRowsToCollapse inSection:section]]
                     withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
    
}

- (void)tableView:(UITableView *)tableView expandSection:(NSInteger)section {
    [self.expandedSections addIndex:section];
    
    NSInteger numberOfRowsExpanded = [self tableView:tableView numberOfRowsInSectionWhenExpanded:section];
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (int i=self.minNumberOfRowsToCollapse+1;i<=numberOfRowsExpanded;i++) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:newIndexPath];
    }
    
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.minNumberOfRowsToCollapse inSection:section]]
                     withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

@end
