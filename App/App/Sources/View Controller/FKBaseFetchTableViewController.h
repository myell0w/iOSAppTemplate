// Part of iOSAppTemplate http://foundationk.it

#import "FKBaseTableViewController.h"

// Basic TableViewController managed by a NSFetchedResultsController
@interface FKBaseFetchTableViewController : FKBaseTableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@end
