// Part of iOSAppTemplate http://foundationk.it

#import "FKBaseTableViewController.h"

/**
 This class serves as the superclass for all tableViewController managed by a fetchedResultsController
 */
@interface FKBaseFetchTableViewController : FKBaseTableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@end
