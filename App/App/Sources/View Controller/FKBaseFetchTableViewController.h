// Part of iOSAppTemplate http://foundationk.it

#import "FKBaseTableViewController.h"

/**
 This class serves as the superclass for all tableViewController managed by a fetchedResultsController
 */
@interface FKBaseFetchTableViewController : FKBaseTableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
/** Indicates whether updates should happen animated or not */
@property (nonatomic, assign) BOOL updateAnimated;

@end
