//
//  UPCTimelineViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 14/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCTimelineViewController.h"
#import "UPCMaxConnector.h"
#import "UPCMaxNotifications.h"
#import "ASActivityStreams.h"
#import "UPCActivityViewController.h"
#import "UPCTimelineViewNotifications.h"


@interface UPCTimelineViewController ()
{
    BOOL reloading;
}
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshView;
@end


@implementation UPCTimelineViewController

#pragma mark - Synthesized properties

@synthesize refreshView;

#pragma mark - Notification subscriptions

- (void)subscribeToMaxConnectorEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timelineRefreshed:) name:TIMELINE_REFRESHED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timelineRefreshError:) name:TIMELINE_REFRESH_ERROR_NOTIFICATION object:nil];
}

- (void)unsubscribeFromMaxConnectorEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self subscribeToMaxConnectorEvents];
    
    // Configure EGOTableViewPullRefresh
    CGRect refreshViewFrame = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height);
    self.refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:refreshViewFrame];
    self.refreshView.delegate = self;
    [self.tableView addSubview:self.refreshView];
    
    // Trigger refresh of timeline to update table view
    [[UPCMaxConnector sharedMaxConnector] refreshTimeline];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self unsubscribeFromMaxConnectorEvents];
    self.refreshView = nil;
}

#pragma mark - Pull to refresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    reloading = YES;
    [[UPCMaxConnector sharedMaxConnector] refreshTimeline];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [[UPCMaxConnector sharedMaxConnector] timelineLastUpdate];
}

- (void)timelineRefreshed:(NSNotification *)notification
{
    reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
}

- (void)timelineRefreshError:(NSNotification *)notification
{
    reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.tableView reloadData];
    //TODO: Show error
}

#pragma mark - UITableViewDataSource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView = tableView;
    return [[UPCMaxConnector sharedMaxConnector].timeline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TIMELINE_CELL_ID = @"TIMELINE_CELL_ID";
    UITableViewCell *timelineCell = [tableView dequeueReusableCellWithIdentifier:TIMELINE_CELL_ID];
    if (timelineCell == nil) 
    {
        timelineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TIMELINE_CELL_ID];
        timelineCell.imageView.image = [UIImage imageNamed:@"user"];
        timelineCell.textLabel.font = [timelineCell.textLabel.font fontWithSize:14];
        timelineCell.detailTextLabel.font = [timelineCell.detailTextLabel.font fontWithSize:10];
    }
    
    ASActivity *activity = [[UPCMaxConnector sharedMaxConnector].timeline objectAtIndex:indexPath.row];
    
    timelineCell.textLabel.text = [activity.verb isEqualToString:@"post"] ? ((ASNote *)activity.object).content : ((ASPerson *)activity.object).displayName;
    timelineCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@", ((ASPerson *)activity.actor).displayName, activity.verb, activity.published];
    
    return timelineCell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASActivity *activity = [[[UPCMaxConnector sharedMaxConnector] timeline] objectAtIndex:indexPath.row];
    NSDictionary *activityInfo = [NSDictionary dictionaryWithObject:activity forKey:ACTIVITY_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_SELECTED object:self userInfo:activityInfo];
}

@end
