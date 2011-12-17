// Part of iOSAppTemplate http://foundationk.it

#import "FKBaseCollapsableTableViewController.h"

/**
 This class serves as the superclass for all tableViewController managed by a fetchedResultsController
 */
@interface FKBaseFetchTableViewController : FKBaseTableViewController <NSFetchedResultsControllerDelegate> 

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;

/** Indicates whether updates should happen animated or not */
@property (nonatomic, assign) BOOL updateAnimated;
/** The cache name of the viewController */
@property (nonatomic, readonly) NSString *cacheName;

/** The class of the objects to fetch */
@property (nonatomic, strong) Class entityClass;
/** The predicate of the fetchedResultsController */
@property (nonatomic, strong) NSPredicate *predicate;
/** The sectionKeyPath of the fetchedResultsController, defaults to nil */
@property (nonatomic, copy) NSString *sectionKeyPath;
/** The sort descriptors of the fetchedResultsController */
@property (nonatomic, copy) NSArray *sortDescriptors;
/** The view that is visible if there is no content */
@property (nonatomic, strong) UIView *contentUnavailableView;

/**
 Re-creates fetchedResultsController and performs a fetch
 */
- (void)refetch;

/**
 Sets the predicate and refetches the fetchedResultsController
 
 @param predicate The new predicate of the fetchedResultsController
 */
- (void)refetchWithPredicate:(NSPredicate *)predicate;

/**
 Convenience Method:
 Sets one sortDescriptor as the sortDescriptors of the fetchedResultsController
 
 @param sortDescriptor the sortDescriptor of the fetchedResultsController
 */
- (void)setSortDescriptor:(NSSortDescriptor *)sortDescriptor;

@end
