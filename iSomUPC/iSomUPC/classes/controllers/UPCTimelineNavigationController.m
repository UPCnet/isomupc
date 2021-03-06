//
//  UPCTimelineNavigationController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 08/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCTimelineNavigationController.h"
#import "UPCMaxConnector.h"
#import "UPCPostActivityViewController.h"
#import "UPCPostActivityViewNotifications.h"
#import "UPCTimelineViewNotifications.h"
#import "UPCActivityViewController.h"


#pragma mark - Class extension

@interface UPCTimelineNavigationController ()
- (void) activityPostingCancelled:(NSNotification *)notification;
- (void) activityPostingRequested:(NSNotification *)notification;
- (void) activityPostingSucceeded:(NSNotification *)notification;
- (void) activityPostingFailed:(NSNotification *)notification;
- (void) activitySelected:(NSNotification *)notification;
@end


#pragma mark - Class implementation

@implementation UPCTimelineNavigationController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityPostingCancelled:) name:ACTIVITY_POSTING_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityPostingRequested:) name:ACTIVITY_POSTING_REQUESTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityPostingSucceeded:) name:ACTIVITY_POSTING_SUCCEEDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityPostingFailed:) name:ACTIVITY_POSTING_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activitySelected:) name:ACTIVITY_SELECTED object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTIVITY_POSTING_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTIVITY_POSTING_REQUESTED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTIVITY_POSTING_SUCCEEDED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTIVITY_POSTING_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTIVITY_SELECTED object:nil];
}

#pragma mark - Event management

- (void)newActivity:(id)sender
{
    UPCPostActivityViewController *postActivityViewController = [[UPCPostActivityViewController alloc] init];
    [self presentModalViewController:postActivityViewController animated:YES];
}

- (void) activityPostingCancelled:(NSNotification *)notification
{
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
}

- (void) activityPostingRequested:(NSNotification *)notification
{
}

- (void) activityPostingSucceeded:(NSNotification *)notification
{
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
    [[UPCMaxConnector sharedMaxConnector] refreshTimeline];
}

- (void) activityPostingFailed:(NSNotification *)notification
{
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"TODO: Show error message");
}

- (void)activitySelected:(NSNotification *)notification
{
    ASActivity *activity = [notification.userInfo objectForKey:ACTIVITY_KEY];
    UPCActivityViewController *activityViewController = [[UPCActivityViewController alloc] initWithActivity:activity];
    [self pushViewController:activityViewController animated:YES];
}

@end
