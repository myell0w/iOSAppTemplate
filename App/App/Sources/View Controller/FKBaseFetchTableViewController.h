// Part of iOSAppTemplate http://foundationk.it

#import "FKBaseCollapsableTableViewController.h"

/**
 This class serves as the superclass for all tableViewController managed by a fetchedResultsController
 */
@interface FKBaseFetchTableViewController : FKBaseCollapsableTableViewController <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController_;
}

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
/** Indicates whether updates should happen animated or not */
@property (nonatomic, assign) BOOL updateAnimated;
/** The cache name of the viewController */
@property (nonatomic, readonly) NSString *cacheName;
@end
