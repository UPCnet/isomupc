//
//  UPCTimelineTableViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 14/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCActivityTableViewController.h"
#import "RestKit/RestKit.h"
#import "ASActivityStreams.h"
#import "UPCRestKitConfigurator.h"


@interface UPCActivityTableViewController ()
@property (strong, nonatomic) NSArray *timeline;
@property (strong, nonatomic) UITableView *tableView;
- (void)refresh;
@end


@implementation UPCActivityTableViewController

#pragma mark - Synthesized properties

@synthesize timeline;
@synthesize tableView;

#pragma mark - Init and dealloc

- (id)init
{
    self = [super init];
    if (self != nil) 
    {
        [self refresh];
    }
    return self;
}

#pragma mark - Web services communication

- (void)refresh
{
    [[UPCRestKitConfigurator sharedManager] loadObjectsAtResourcePath:@"/users/jose/timeline" delegate:self]; 
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    self.timeline = objects;
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView = tableView;
    return [self.timeline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TIMELINE_CELL_ID = @"TIMELINE_CELL_ID";
    UITableViewCell *timelineCell = [tableView dequeueReusableCellWithIdentifier:TIMELINE_CELL_ID];
    if (timelineCell == nil) 
    {
        timelineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TIMELINE_CELL_ID];
    }
    
    ASActivity *activity = [self.timeline objectAtIndex:indexPath.row];
    
    timelineCell.textLabel.text = [activity.verb isEqualToString:@"post"] ? ((ASNote *)activity.object).content : ((ASPerson *)activity.object).displayName;
    timelineCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@", ((ASPerson *)activity.actor).displayName, activity.verb, activity.published];
    
    return timelineCell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
