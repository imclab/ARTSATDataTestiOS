//
//  ARTSATInvaderSatManagedObject.h
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/09.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ARTSATSat.h"

@class ARTSATSensor;

@interface ARTSATInvaderSat : ARTSATSat

@property (nonatomic, retain) NSSet *sensors;
@end

@interface ARTSATInvaderSat (CoreDataGeneratedAccessors)

- (void)addSensorsObject:(ARTSATSensor *)value;
- (void)removeSensorsObject:(ARTSATSensor *)value;
- (void)addSensors:(NSSet *)values;
- (void)removeSensors:(NSSet *)values;

@end
