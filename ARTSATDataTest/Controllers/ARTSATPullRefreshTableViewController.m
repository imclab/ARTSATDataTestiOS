//
//  ARTSATPullRefreshTableViewController.m
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/05/16.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import "ARTSATPullRefreshTableViewController.h"
#import "ARTSATDataTestAppDelegate.h"
#import "ARTSATApiDataRequest.h"
#import "ARTSATInvaderSat.h"
#import "ARTSATCoreDataManager.h"
#import "ARTSATSatDetailViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface ARTSATPullRefreshTableViewController ()

- (void)recivedDataAndAddSat:(NSNotification*)notification;
- (void)sendGetRequest;

@end

@implementation ARTSATPullRefreshTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ViewController Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedDataAndAddSat:) name:kARTSATAPIResultNotification object:nil];
    [ARTSATCoreDataManager fetchEntitys];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [ARTSATCoreDataManager sharedInstance].delegate = self;
    
    self.refreshControl  =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.refreshControl beginRefreshing];
    [self refresh:self];
}

-(void)viewWillUnload {
    [super viewWillUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kARTSATAPIResultNotification object:nil];
}

#pragma mark - refresh Override
- (void) refresh:(id)sender {
    [self.refreshControl beginRefreshing];
    [self sendGetRequest];
}

#pragma mark - Send Request Method
- (void)sendGetRequest {
    [ARTSATApiDataRequest postGetInvadorDataAsync];
}

- (void)recivedDataAndAddSat:(NSNotification*)notification {
    // do somethig when recieved data
};


#pragma mark - UITableView Deta Sourcce
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    ARTSATSatDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARTSATSatDetail"];
    
    [detailViewController setSensors:[[ARTSATCoreDataManager getSatAtIndex:row].sensors allObjects]];
    detailViewController.dateString = [ARTSATCoreDataManager getSatAtIndex:row].requested_time_iso_string;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ARTSATCoreDataManager sharedInstance] sats] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    static NSString *tableIdentifier = @"SatTableCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    ARTSATInvaderSat *sat = [ARTSATCoreDataManager getSatAtIndex:row];
    
    NSString * dateString = sat.requested_time_iso_string;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = dateString;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = @"test";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [ARTSATCoreDataManager deleteSatAtIndex:indexPath.row];
}

#pragma mark - NSFetchedResultsController delegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    [self.refreshControl endRefreshing];
}

-(void)refershFinished {
    [self.refreshControl endRefreshing];
}

@end
