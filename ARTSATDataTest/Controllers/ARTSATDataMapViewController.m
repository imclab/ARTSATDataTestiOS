//
//  ARTSATDataSecondViewController.m
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/08.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import "ARTSATDataMapViewController.h"

@interface ARTSATDataMapViewController ()

@end

@implementation ARTSATDataMapViewController
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView.userLocation addObserver:self forKeyPath:@"location" options:0 context:NULL];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    mapView.userLocation.title = @"現在地";
    mapView.showsUserLocation = YES;
    mapView.centerCoordinate = mapView.userLocation.location.coordinate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    self.mapView.centerCoordinate = mapView.userLocation.location.coordinate;
}

@end
