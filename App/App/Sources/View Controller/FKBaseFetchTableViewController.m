#import "FKBaseFetchTableViewController.h"
#import "UIViewController+FKAnimatedFetchedResultsController.h"

@implementation FKBaseFetchTableViewController

$synthesize(fetchedResultsController);
$synthesize(updateAnimated);

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
        updateAnimated_ = YES;
    }
    
    return self;
}

- (void)dealloc {
    fetchedResultsController_.delegate = nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKBaseFetchTableViewController
////////////////////////////////////////////////////////////////////////

// Subclasses must override
- (NSFetchedResultsController *)fetchedResultsController {
    FKLogNotImplemented();
    return nil;
}

- (NSString *)cacheName {
    return NSStringFromClass([self class]);
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    FKAssert([self.fetchedResultsController performFetch:&error],
             @"Unable to perform fetch on NSFetchedResultsController: %@", 
             [error localizedDescription]);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.fetchedResultsController.delegate = nil;
    fetchedResultsController_ = nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource
////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionWhenExpanded:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (self.fetchedResultsController.sections.count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
        numberOfRows = sectionInfo.numberOfObjects;
    }
    
    return numberOfRows;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSFetchedResultsController Animated Update
////////////////////////////////////////////////////////////////////////

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller { 
    if (self.viewVisible && self.updateAnimated) {
        [self handleController:controller willChangeContentForTableView:self.tableView];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller { 
    if (self.viewVisible && self.updateAnimated) {
        [self handleController:controller didChangeContentForTableView:self.tableView];
    } else {
        // reload data and set selected on same cell as before
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        [self.tableView reloadData];
        [selectedCell setSelected:YES animated:NO];
    }
    
    [self updateUI];
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath { 
    
    if (self.viewVisible && self.updateAnimated) {
        [self handleController:controller
               didChangeObject:anObject
                   atIndexPath:indexPath
                 forChangeType:type
                  newIndexPath:newIndexPath
                     tableView:self.tableView];
    }
}

- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex 
     forChangeType:(NSFetchedResultsChangeType)type {
	
    if (self.viewVisible && self.updateAnimated) {
        [self handleController:controller
              didChangeSection:sectionInfo
                       atIndex:sectionIndex
                 forChangeType:type
                     tableView:self.tableView];
    }
}


@end
