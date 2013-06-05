//
//  ARTSATDataSecondViewController.m
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/08.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import "ARTSATDataMapViewController.h"
#import "ARTSATDataGraphViewController.h"

@interface ARTSATDataMapViewController ()
@property (weak) ARTSATDataGraphViewController * graphVIewController;
@end

@implementation ARTSATDataMapViewController
@synthesize mapView, graphVIewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView.userLocation addObserver:self forKeyPath:@"location" options:0 context:NULL];
    
    
    UIStoryboard * storyboard;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    
    graphVIewController = [storyboard instantiateViewControllerWithIdentifier:@"ARTSATDataGraphViewController"];
    
    [self addChildViewController:graphVIewController];
    
    [self.view addSubview:graphVIewController.view];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    mapView.userLocation.title = @"現在地";
    mapView.showsUserLocation = YES;
    mapView.centerCoordinate = mapView.userLocation.location.coordinate;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGSize gfViewSize = graphVIewController.view.frame.size;
    
    NSLog(@"size ------- %@", NSStringFromCGSize(gfViewSize));
    [graphVIewController.view setFrame:CGRectMake(0, self.mapView.frame.size.height, gfViewSize.width, gfViewSize.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (YES == [object isKindOfClass:[MKMapView class]]) {
        self.mapView.centerCoordinate = mapView.userLocation.location.coordinate;
    }
}

@end
