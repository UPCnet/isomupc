//
//  UPCActivityViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 11/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCActivityViewController.h"
#import "UPCRestKitConfigurator.h"
#import "UPCPostCommentViewController.h"
#import "UPCPostCommentViewNotifications.h"
#import "UPCCommentView.h"


#pragma mark - Class extension

@interface UPCActivityViewController ()
@property (strong, nonatomic) ASActivity *activity;
@property (strong, nonatomic) NSMutableArray *commentViews;
- (void)newComment:(id)sender;
- (void)commentPostingCancelled:(NSNotification *)notification;
- (void)commentPostingRequested:(NSNotification *)notification;
- (void)commentPostingSucceeded:(NSNotification *)notification;
- (void)commentPostingFailed:(NSNotification *)notification;
- (void)loadComments;
@end


#pragma mark - Class implementation

@implementation UPCActivityViewController

#pragma mark Synthesized properties

@synthesize scrollView;
@synthesize userLabel;
@synthesize dateLabel;
@synthesize activityContentLabel;
@synthesize activity = _activity;
@synthesize commentViews;

#pragma mark Init and dealloc

- (id)initWithActivity:(ASActivity *)activity
{
    self = [super initWithNibName:@"UPCActivityView" bundle:nil];
    if (self!= nil) 
    {
        self.activity = activity;
    }
    return self;
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) 
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }

    [super viewDidLoad];
    
    self.commentViews = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"Actividad";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newComment:)];
    
    self.userLabel.text = ((ASPerson *)self.activity.actor).displayName;
    self.dateLabel.text = [dateFormatter stringFromDate:self.activity.published];
    self.activityContentLabel.text = [NSString stringWithFormat:@"%@", self.activity];
    [self.activityContentLabel sizeToFit];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.activityContentLabel.frame.origin.y + self.activityContentLabel.frame.size.height + 18);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentPostingCancelled:) name:COMMENT_POSTING_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentPostingRequested:) name:COMMENT_POSTING_REQUESTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentPostingSucceeded:) name:COMMENT_POSTING_SUCCEEDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentPostingFailed:) name:COMMENT_POSTING_FAILED object:nil];

    [self loadComments];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COMMENT_POSTING_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COMMENT_POSTING_REQUESTED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COMMENT_POSTING_SUCCEEDED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COMMENT_POSTING_FAILED object:nil];

    self.scrollView = nil;
    self.dateLabel = nil;
    self.activityContentLabel = nil;
    
    self.commentViews = nil;
}

#pragma mark Create and place comments

- (void)showComments:(NSArray *)comments
{
    [self.commentViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UPCCommentView *commentView = (UPCCommentView *)obj;
        [commentView removeFromSuperview];
    }];
    [self.commentViews removeAllObjects];
    
    CGRect commentViewRect = CGRectMake(20, 0, self.scrollView.bounds.size.width - 40, 40);
    [comments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ASComment *comment = (ASComment *)obj;
        UPCCommentView *commentView = [[UPCCommentView alloc] initWithFrame:commentViewRect];
        [commentView populateWithComment:comment];
        [self.commentViews addObject:commentView];
    }];
    
    __block float currentYCoord = self.activityContentLabel.frame.origin.y + self.activityContentLabel.frame.size.height;
    [self.commentViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UPCCommentView *commentView = (UPCCommentView *)obj;
        [commentView sizeToFit];
        commentView.frame = CGRectMake(20, currentYCoord, commentView.frame.size.width, commentView.frame.size.height);
        [self.scrollView addSubview:commentView];
        currentYCoord += commentView.frame.size.height;
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, currentYCoord);
}

- (void)loadComments
{
    UPCRestKitConfigurator *configurator = [UPCRestKitConfigurator sharedConfigurator];
    NSString *commentsPath = [NSString stringWithFormat:@"/activities/%@/comments", self.activity.id];
    [configurator.manager loadObjectsAtResourcePath:commentsPath delegate:self block:^(RKObjectLoader *objectLoader) {
        objectLoader.objectMapping = configurator.commentMapping;
    }];
}

#pragma mark Comment loading

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [self showComments:objects];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"TODO: Show error while retreiving comments: %@", error);
}

#pragma mark Event management

- (void)newComment:(id)sender
{
    UPCPostCommentViewController *postCommentViewController = [[UPCPostCommentViewController alloc] initWithActivity:self.activity];
    [self presentModalViewController:postCommentViewController animated:YES];
}

- (void)commentPostingCancelled:(NSNotification *)notification
{
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
}

- (void)commentPostingRequested:(NSNotification *)notification
{
}

- (void)commentPostingSucceeded:(NSNotification *)notification
{
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
    [self loadComments];
}

- (void)commentPostingFailed:(NSNotification *)notification
{
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"TODO: Show error message");
}

@end
