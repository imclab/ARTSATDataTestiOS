//
//  ARTSATApiDataRequest.h
//  AratSatApiTest
//
//  Created by Koichiro Mori on 2013/05/08.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const ARTSAT_API_HOST = @"api.artsat.jp";
static NSString* const ARTSAT_API_PATH = @"/web/v2";
static NSString* const ARTSAT_API_SATTELITE_NAME = @"/invader";
static NSString* const ARTSAT_API_COMMAND_NAME = @"/sensor_data.json";
static NSString* const ARTSAT_API_PORT = @"80";

static NSString* const kARTSATAPIResultNotification = @"kARTSATAPIResultNotification";
static NSString* const kARTSATAPIRequestTimeOutNotification = @"kARTSATAPIRequestTimeOutNotification";

@interface UIDevice (ARTSATTransferQueue)

+ (dispatch_queue_t)ARTSATTransferQueue;
+ (dispatch_group_t)ARTSATWiFiTransferGroup;
+ (dispatch_queue_t)ARTSATWiFiTransferQueue;

@end


@interface ARTSATApiDataRequest : NSObject

+ (void)postGetInvadorDataAsync;
+ (void)postGetAsync:(NSDictionary*)values;

@end