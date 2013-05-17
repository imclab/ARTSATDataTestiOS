//
//  ARTSATSatManagedObject.h
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/09.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ARTSATSat : NSManagedObject

@property (nonatomic, retain) NSString * closest_available_time_iso_string;
@property (nonatomic, retain) NSNumber * closest_available_time_unix;
@property (nonatomic, retain) NSString * requested_time_iso_string;
@property (nonatomic, retain) NSNumber * requested_time_unix;
@property (nonatomic, retain) NSNumber * interpolated;
@property (nonatomic, retain) NSDate * date;

@end
