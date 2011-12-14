//
//  UPCTimelineTableViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 14/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCActivityTableViewController.h"

@implementation UPCActivityTableViewController

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TIMELINE_CELL_ID = @"TIMELINE_CELL_ID";
    UITableViewCell *timelineCell = [tableView dequeueReusableCellWithIdentifier:TIMELINE_CELL_ID];
    if (timelineCell == nil) 
    {
        timelineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TIMELINE_CELL_ID];
    }
    
    timelineCell.textLabel.text = @"Algo está pasando en mi timeline";
    timelineCell.detailTextLabel.text = @"Jose - 2011/12/10 18:50";
    
    return timelineCell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
