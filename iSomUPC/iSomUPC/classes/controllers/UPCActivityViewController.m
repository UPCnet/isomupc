//
//  UPCActivityViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 11/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCActivityViewController.h"


#pragma mark - Class extension

@interface UPCActivityViewController ()
@property (strong, nonatomic) ASActivity *activity;
@end


#pragma mark - Class implementation

@implementation UPCActivityViewController

#pragma mark Synthesized properties

@synthesize scrollView;
@synthesize userLabel;
@synthesize dateLabel;
@synthesize activityContentLabel;
@synthesize activity = _activity;

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
    
    self.navigationItem.title = @"Activity";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(comment:)];
    
    [super viewDidLoad];
    self.userLabel.text = ((ASPerson *)self.activity.actor).displayName;
    self.dateLabel.text = [dateFormatter stringFromDate:self.activity.published];
    self.activityContentLabel.text = [NSString stringWithFormat:@"%@", self.activity];
    [self.activityContentLabel sizeToFit];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.activityContentLabel.frame.origin.y + self.activityContentLabel.frame.size.height + 18);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.dateLabel = nil;
    self.activityContentLabel = nil;
}

- (void)comment:(id)sender
{
    NSLog(@"Comment button tapped");
}

@end
