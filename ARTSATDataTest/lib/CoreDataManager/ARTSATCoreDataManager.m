//
//  ARTSATCoreDataManager.m
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/09.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import "ARTSATCoreDataManager.h"
#import "ARTSATSensor.h"
#import "ARTSATApiDataRequest.h"

static NSString *const MODEL_CLASS_NAME = @"ARTSATSatManagedObject";
static NSString *const DB_NAME = @"satRecord.sqlite";

@implementation ARTSATCoreDataManager
@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator, sats, delegate;

static ARTSATCoreDataManager* sharedStatusManager = nil;

#pragma mark - Class Method
+(ARTSATCoreDataManager*)sharedInstance {
    @synchronized(self) {
        if (sharedStatusManager == nil) {
            sharedStatusManager = [[self alloc] init];
        }
    }
    return sharedStatusManager;
}

+(id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedStatusManager == nil) {
            sharedStatusManager = [super allocWithZone:zone];
            return sharedStatusManager;
        }
    }
    return nil;
}

#pragma mark - Instance Method
-(id)init {
    if(self = [super init]){
        [[NSNotificationCenter defaultCenter] addObserver:sharedStatusManager selector:@selector(recivedDataAndAddInvaderSat:) name:kARTSATAPIResultNotification object:nil];
        sharedStatusManager.sats = [NSMutableArray array];
    }
    return self;
}

-(id)copyWithZone:(NSZone*)zone {
    return self;
}

-(id)retain {
    return self;
}

-(void)release {
}

-(unsigned)retainCount {
    return UINT_MAX;
}


-(id)autorelease {
    return self;
}

#pragma mark - App Documents Directory
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark - Set ManagedObjectContext
+ (void) setManagedObjectContext {

    NSURL *storeURL = [NSURL fileURLWithPath:[[self.sharedInstance applicationDocumentsDirectory] stringByAppendingPathComponent:DB_NAME] isDirectory:NO];
    
    NSError *error = nil;
    if (nil == self.sharedInstance.managedObjectModel) {
        self.sharedInstance.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    // NSPersistentStoreCoordinator をインスタンス化
    if(nil == self.sharedInstance.persistentStoreCoordinator) {
        self.sharedInstance.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.sharedInstance.managedObjectModel];
        if (![self.sharedInstance.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    // NSManagedObjectContext をインスタンス化
    if (self.sharedInstance.persistentStoreCoordinator != nil) {
        self.sharedInstance.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.sharedInstance.managedObjectContext setPersistentStoreCoordinator:self.sharedInstance.persistentStoreCoordinator];
    }
    
}

#pragma mark - Save PersistensStore
+ (void)savePersistensStore {
    NSError *error = nil;
    NSManagedObjectContext *context = self.sharedInstance.managedObjectContext;
    if (context != nil) {
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Fetch Entitys
+(void)fetchEntitys {
    
    ARTSATCoreDataManager * coredataManager = [ARTSATCoreDataManager sharedInstance];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription;
    entityDescription = [NSEntityDescription entityForName:@"ARTSATSat" inManagedObjectContext:coredataManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    
    NSSortDescriptor *desc;
    desc = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *sortDescriptors;
    sortDescriptors = [[NSArray alloc] initWithObjects:desc, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // 取得条件の設定
    //    NSPredicate *pred;
    //    pred = [NSPredicate predicateWithFormat:@"key = %@", key];
    //    [fetchRequest setPredicate:pred];
    
    [fetchRequest setFetchBatchSize:100];// 取得最大数の設定
    
    NSFetchedResultsController *resultsController;
    resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[coredataManager managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    resultsController.delegate = sharedStatusManager;
    
    NSError *error;
    if (![resultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSArray *results = resultsController.fetchedObjects;
    
    if (0 < [results count]) {
        for (ARTSATSat *result in results) {
            [sharedStatusManager.sats addObject:result];
        }
    }
}

+(ARTSATInvaderSat*)getSatAtIndex:(NSUInteger)index {
    if (0 < [sharedStatusManager.sats count]) {
        return (sharedStatusManager.sats)[index];
    }
    return nil;
};

#pragma mark delete Record
+(void)deleteSatAtIndex:(NSUInteger)index {
    ARTSATSat *sat = (sharedStatusManager.sats)[index];
    if(nil != sat){
        [sharedStatusManager.managedObjectContext deleteObject:sat];
    }
}


#pragma mark - Add SatInvader With Response
-(void)addSatInvaderWithResponse:(NSDictionary*)response {
    dispatch_async(UIDevice.ARTSATTransferQueue, ^{
        
        if (nil == self.managedObjectContext){
            return;
        };
        
        if (0 == [response count]) {
            return;
        }
        
        NSDictionary *results = response[@"results"];
        if(0 == [results count]) {
            return;
        }
        
        for (NSDictionary *result in results) {
            if ([self validateDuplicationSat:result[@"closest_available_time_unix"]]) {
                return;
            }
        };
        
        ARTSATInvaderSat *sat = (ARTSATInvaderSat *)[NSEntityDescription insertNewObjectForEntityForName:@"ARTSATInvaderSat" inManagedObjectContext:self.managedObjectContext];
        
        for (NSDictionary *result in results) {
            
            sat.interpolated = result[@"interpolated"];
            sat.requested_time_unix = result[@"requested_time_unix"];
            sat.requested_time_iso_string = result[@"requested_time_iso_string"];
            sat.closest_available_time_unix = result[@"closest_available_time_unix"];
            sat.closest_available_time_iso_string = result[@"closest_available_time_iso_string"];
            
            NSTimeInterval interval = [sat.closest_available_time_unix doubleValue];
            sat.date = [NSDate dateWithTimeIntervalSince1970:interval];
            
            NSArray *allSensorsKeys = [result[@"sensors"] allKeys];

            if (0 < [allSensorsKeys count]) {
                for (NSString *key in allSensorsKeys) {
                    
                    ARTSATSensor *sensor = (ARTSATSensor*)[NSEntityDescription insertNewObjectForEntityForName:@"ARTSATSensor" inManagedObjectContext:self.managedObjectContext];
                    NSDictionary *sensorsObject = result[@"sensors"][key];
                    sensor.sensor_name = key;
                    sensor.type = sensorsObject[@"type"];
                    sensor.unit = sensorsObject[@"unit"];
                    sensor.value = sensorsObject[@"value"];
                    [sat addSensorsObject:sensor];
                }
            }
        }
        
    });
}

#pragma mark - Validate Duplication of Sat Data
-(BOOL)validateDuplicationSat:(NSNumber*)closest_available_time_unix { //check data dupulication by closest_available_time_unix
    for (ARTSATInvaderSat* currentSat in self.sats) {
        if ([closest_available_time_unix isEqualToNumber: currentSat.closest_available_time_unix] ) {
            return YES;
        };
    }
    return NO;
}

-(void)recivedDataAndAddInvaderSat:(NSNotification*)notificatin {
    if(nil != [notificatin userInfo]) {
        [self addSatInvaderWithResponse:[notificatin userInfo]];
    }
    [self.delegate refershFinished];
}

#pragma mark NSFetchedResultsController delegate method
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch ( type ) {
        case NSFetchedResultsChangeInsert:
            [sharedStatusManager.sats insertObject:anObject atIndex:indexPath.row];
            break;
        case NSFetchedResultsChangeDelete:
            [sharedStatusManager.sats removeObjectAtIndex:indexPath.row];
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            //TODO Test
            [sharedStatusManager.sats removeObjectAtIndex:indexPath.row];
            [sharedStatusManager.sats insertObject:anObject atIndex:newIndexPath.row];
            break;
        default:
            break;
    }
    
    [sharedStatusManager.delegate controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}

@end
