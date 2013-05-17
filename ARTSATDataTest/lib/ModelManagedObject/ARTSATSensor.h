//
//  ARTSATSensorManagedObject.h
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/09.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ARTSATSensor : NSManagedObject

@property (nonatomic, retain) NSString * sensor_name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSNumber * value;

@end
