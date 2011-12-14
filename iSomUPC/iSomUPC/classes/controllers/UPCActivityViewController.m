//
//  UPCTimelineViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 14/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCActivityViewController.h"
#import "UPCActivityTableViewController.h"


@interface UPCActivityViewController ()
@property (strong, nonatomic) UPCActivityTableViewController *activityTableViewController;
@end


@implementation UPCActivityViewController

#pragma mark - Synthesized properties

@synthesize activityTableView;
@synthesize activityTableViewController;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.activityTableViewController = [[UPCActivityTableViewController alloc] init];
    self.activityTableView.dataSource = activityTableViewController;
    self.activityTableView.delegate = activityTableViewController;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.activityTableView = nil;
    self.activityTableViewController = nil;
}

@end
