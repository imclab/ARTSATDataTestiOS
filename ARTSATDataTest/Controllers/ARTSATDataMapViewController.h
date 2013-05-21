//
//  ARTSATDataSecondViewController.h
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/08.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ARTSATDataMapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@end
