//
//  ARTSATApiDataRequest.m
//  AratSatApiTest
//
//  Created by Koichiro Mori on 2013/05/08.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import "ARTSATApiDataRequest.h"

static dispatch_queue_t _ARTSATTransferQueue = NULL;
static dispatch_queue_t _ARTSATWiFiTransferQueue = NULL;
static dispatch_group_t _ARTSATWiFiTransferGroup = NULL;

#pragma mark - UIDevice
@implementation UIDevice (ARTSATTransferQueue)
+ (dispatch_queue_t)ARTSATTransferQueue {
	if (NULL == _ARTSATTransferQueue) {
		_ARTSATTransferQueue = dispatch_queue_create("ARTSATTransferQueue", DISPATCH_QUEUE_SERIAL);
	}
	return _ARTSATTransferQueue;
}

+ (dispatch_queue_t)ARTSATWiFiTransferQueue {
	if (NULL == _ARTSATWiFiTransferQueue) {
		_ARTSATWiFiTransferQueue = dispatch_queue_create("ARTSATWiFiTransferQueue", DISPATCH_QUEUE_SERIAL);
	}
	return _ARTSATWiFiTransferQueue;
}

+ (dispatch_group_t)ARTSATWiFiTransferGroup {
	if (NULL == _ARTSATWiFiTransferGroup) {
		_ARTSATWiFiTransferGroup = dispatch_group_create();
	}
	return _ARTSATWiFiTransferGroup;
}

@end

#pragma mark - ARTSATApiDataRequest
@implementation ARTSATApiDataRequest

+ (NSString*)getCurrentTimeString  {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/$Tokyo"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *now = [NSDate date];
    
    NSString *currentString = @"";
    currentString = [NSString stringWithFormat:@"'%@'", [formatter stringFromDate:now]];

    return currentString;
}


+ (NSString*)getParamaterStringFromValueDictionary:(NSDictionary*)values {
    NSString *string = nil;
    if( 0 == [values count]) {
        return string;
    }
    int i = 0;
    for (NSString *keyName in [values allKeys]) {
        NSLog(@"getParamaterStringFromValueDictionary items : %@=%@",keyName, values[keyName]);
        if(i==0){
            string = [NSString stringWithFormat:@"?%@=%@",keyName, values[keyName]];
        } else {
            string = [NSString stringWithFormat:@"%@%@=%@",string ,keyName, values[keyName] ];
        }
        i++;
    }
    return string;
}

+ (NSURL*)getUrl:(NSString*)valueString {
    NSURL *url = nil;
    NSString *stringUrl = [NSString stringWithFormat:@"http://%@:%@%@%@%@", ARTSAT_API_HOST, ARTSAT_API_PORT, ARTSAT_API_PATH, ARTSAT_API_SATTELITE_NAME, ARTSAT_API_COMMAND_NAME];
    if(nil != valueString){
        stringUrl = [NSString stringWithFormat:@"%@%@", stringUrl, valueString];
    }
    url = [NSURL URLWithString:stringUrl];
    return url;
}

#pragma mark - Post Get Invador Data Async
+ (void)postGetInvadorDataAsync {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *currentTime = [self getCurrentTimeString];
    dict[@"time"] = currentTime;
    [self postGetAsync:dict];
}

+ (void)postGetAsync:(NSDictionary*)values {
	__block NSMutableDictionary *responseJSON = nil;
    __block NSURL *url = nil;
    
    NSDictionary *dict = values;
    url = [self getUrl:[self getParamaterStringFromValueDictionary:dict]];
    
	dispatch_async(UIDevice.ARTSATTransferQueue, ^{
		if (nil == url) {
            return;
        }
        NSMutableDictionary *headerFields = @{@"Content-Transfer-Encoding" : @"8bit"}.mutableCopy;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:20.0f];//[[NSMutableURLRequest alloc] initWithURL:self.url];

        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        request.HTTPMethod = @"GET";
        request.allHTTPHeaderFields = headerFields;
        
        NSURLResponse *requestResponse = nil;
        NSError *responseError = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:&responseError];
        
        if (nil != responseError) {
            NSLog(@"response error = %@",responseError);
            //[UIAlertView showAlertWithError:responseError andAutoDismissWithDelayInSeconds:3.0f];
            [self postTimeOutNotification];
        }
        
        if (nil == responseData) {
            return;
        }
        NSError *jsonLoadingError = nil;
        NSJSONReadingOptions readingOptions = (NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments);
        
        responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:readingOptions error:&jsonLoadingError];
        
        if (nil != jsonLoadingError) {
            NSLog(@"self.json = %@",jsonLoadingError);
            //[UIAlertView showAlertWithError:jsonLoadingError andAutoDismissWithDelayInSeconds:3.0f];
            [self postTimeOutNotification];
            
        } else {
            /*
             レスポンス成功時
             */
            //responseJSON.url = self.url;
            //responseJSON.type = self.type;
            
            NSNotification * resrutNotification = [NSNotification notificationWithName:kARTSATAPIResultNotification object:self userInfo:responseJSON];
            [[NSNotificationCenter defaultCenter] postNotification:resrutNotification];
            
        }
	});
}

+ (void)postTimeOutNotification {
    NSNotification *notification = [NSNotification notificationWithName:kARTSATAPIRequestTimeOutNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end


