//
//  UPCPostActivityViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 08/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCPostActivityViewController.h"
#import "UPCMaxConnector.h"
#import "UPCRestKitConfigurator.h"
#import "UPCPostActivityViewNotifications.h"
#import "ASActivityStreams.h"


#pragma mark - Class implementation

@implementation UPCPostActivityViewController

#pragma mark - Synthesized properties

@synthesize postActivityButton;
@synthesize activityTextView;

#pragma mark - Init and dealloc

- (id)init
{
    return [super initWithNibName:@"UPCPostActivityView" bundle:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.activityTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.postActivityButton = nil;
}

#pragma mark - UITextView delegate - Enable / disable post activity button

- (void)textViewDidChange:(UITextView *)textView
{
    self.postActivityButton.enabled = [textView.text length] > 0;
}

#pragma mark - Event management

- (IBAction)cancelActivityPosting:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_POSTING_CANCELLED object:self];
}

- (IBAction)postActivity:(id)sender
{
    ASPerson *user = [[ASPerson alloc] init];
    user.displayName = [[UPCMaxConnector sharedMaxConnector] authenticatedUser];
    ASNote *note = [[ASNote alloc] init];
    note.content = self.activityTextView.text;
    ASActivity *activity = [[ASActivity alloc] init];
    activity.verb = @"post";
    activity.actor = user;
    activity.object = note;
    RKObjectManager *objectManager = [UPCRestKitConfigurator sharedConfigurator].manager;
    [objectManager postObject:activity mapResponseWith:[objectManager.mappingProvider mappingForKeyPath:@"items"] delegate:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_POSTING_REQUESTED object:self];
}

#pragma mark - Object loader delegate: hanlde result of post operation

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_POSTING_SUCCEEDED object:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVITY_POSTING_FAILED object:self];
}

@end
