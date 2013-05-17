//
//  ARTSATDataAppDelegate.m
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/08.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import "ARTSATDataTestAppDelegate.h"
#import "ARTSATApiDataRequest.h"
#import "ARTSATCoreDataManager.h"

@implementation ARTSATDataTestAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ARTSATCoreDataManager setManagedObjectContext]; // initiallize ManagedObjectContext
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    [ARTSATCoreDataManager savePersistensStore]; //save PersistensStore
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [ARTSATCoreDataManager savePersistensStore];  //save PersistensStore
}


@end
