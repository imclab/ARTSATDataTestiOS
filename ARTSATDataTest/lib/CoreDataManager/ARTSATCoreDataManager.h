//
//  ARTSATCoreDataManager.h
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/09.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ARTSATInvaderSat.h"

@protocol ARTSATCoreDataManagerDelegate <NSObject>
@required
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
-(void)refershFinished;

@end

@interface ARTSATCoreDataManager : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSMutableArray *sats;
@property (nonatomic, assign) id<ARTSATCoreDataManagerDelegate>delegate;

+(ARTSATCoreDataManager*) sharedInstance;
+(id) allocWithZone:(NSZone *)zone;
+(void) setManagedObjectContext;
+(void) savePersistensStore;
+(void) fetchEntitys;
+(ARTSATInvaderSat*)getSatAtIndex:(NSUInteger)index;
+(void)deleteSatAtIndex:(NSUInteger)index;

-(NSString*) applicationDocumentsDirectory;

-(void) addSatInvaderWithResponse:(NSDictionary*)response;
-(void) recivedDataAndAddInvaderSat:(NSNotification*)notificatin;

@end
