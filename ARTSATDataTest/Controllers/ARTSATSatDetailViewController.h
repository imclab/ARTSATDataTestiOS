//
//  ARTSATSensorDetailViewController.h
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/10.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTSATSatDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *sensors;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@end
