//
//  ARTSATSensorDetailViewController.m
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/10.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import "ARTSATSatDetailViewController.h"
#import "ARTSATSensor.h"

@interface ARTSATSatDetailViewController ()

@end

@implementation ARTSATSatDetailViewController
@synthesize sensors, tableView, dateString, dateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(nil == sensors){
        sensors = @[];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dateLabel.text = self.dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Deta Sourcce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sensors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableIdentifier = @"DetailTableCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    NSUInteger row = [indexPath row];
    
    /*
    sort sensor data
     */
    NSMutableArray *sortingArray = [NSMutableArray arrayWithArray:self.sensors];
    NSSortDescriptor *sortDiscripter = [[NSSortDescriptor alloc] initWithKey:@"sensor_name" ascending:YES];
    NSArray *sortedArray = [sortingArray sortedArrayUsingDescriptors:@[sortDiscripter]];
    /*
     */
    
    ARTSATSensor *sensor = sortedArray[row];
    NSString * nameString = sensor.sensor_name;
    NSString * unitString = sensor.unit;
    NSString * valueString = [NSString stringWithFormat:@"%@", sensor.value];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = nameString;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", valueString, unitString];
    
    return cell;
}

@end
