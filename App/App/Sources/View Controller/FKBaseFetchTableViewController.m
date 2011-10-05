#import "FKBaseFetchTableViewController.h"

@implementation FKBaseFetchTableViewController

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKBaseFetchTableViewController
////////////////////////////////////////////////////////////////////////

// Subclasses must override
- (NSFetchedResultsController *)fetchedResultsController {
    FKLogNotImplemented();
    return nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    FKAssert([self.fetchedResultsController performFetch:&error], @"Unable to perform fetch on NSFetchedResultsController: %@", [error localizedDescription]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.fetchedResultsController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.fetchedResultsController.delegate = nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource
////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (self.fetchedResultsController.sections.count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSFetchedResultsController Animated Update
////////////////////////////////////////////////////////////////////////

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller { 
	//[self handleController:controller willChangeContentForTableView:self.tableView];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller { 
	//[self handleController:controller didChangeContentForTableView:self.tableView];
    [self updateUI];
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath { 
    
//    [self handleController:controller
//           didChangeObject:anObject
//               atIndexPath:indexPath
//             forChangeType:type
//              newIndexPath:newIndexPath
//                 tableView:self.tableView];
}

- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex 
     forChangeType:(NSFetchedResultsChangeType)type {
	
//    [self handleController:controller
//          didChangeSection:sectionInfo
//                   atIndex:sectionIndex
//             forChangeType:type
//                 tableView:self.tableView];
}


@end
