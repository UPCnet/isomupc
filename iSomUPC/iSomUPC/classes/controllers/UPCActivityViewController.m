//
//  UPCTimelineViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 14/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCActivityViewController.h"
#import "UPCRestKitConfigurator.h"
#import "ASActivityStreams.h"


@interface UPCActivityViewController ()
{
    BOOL reloading;
}
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshView;
@property (strong, nonatomic) NSArray *timeline;
- (void)refresh;
@end


@implementation UPCActivityViewController

#pragma mark - Synthesized properties

@synthesize refreshView;
@synthesize timeline;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure EGOTableViewPullRefresh
    CGRect refreshViewFrame = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height);
    self.refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:refreshViewFrame];
    self.refreshView.delegate = self;
    [self.tableView addSubview:self.refreshView];
    
    [self refresh];
    [self.refreshView refreshLastUpdatedDate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
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

- (void)reloadTableData
{
    reloading = YES;
}

- (void)reloadingDone
{
    reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableData];
    [self performSelector:@selector(reloadingDone) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
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
