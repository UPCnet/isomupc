//
//  UPCLoginController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 13/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCLoginController.h"
#import "UPCMaxConnector.h"


@implementation UPCLoginController

#pragma mark Synthesized properties

@synthesize userField;
@synthesize passwordField;

#pragma mark Init and dealloc

- (id)init
{
    self = [super initWithNibName:@"UPCLoginView" bundle:nil];
    return self;
}

#pragma mark View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.userField = nil;
    self.passwordField = nil;
}

#pragma mark Keyboard management

- (void)hideKeyboard
{
    [self.userField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

#pragma mark Event management

- (void)login:(id)sender
{
    if (self.userField.text.length > 0) 
    {
        [self hideKeyboard];
        [UPCMaxConnector sharedMaxConnector].authenticatedUser = self.userField.text;
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
        [[UPCMaxConnector sharedMaxConnector] refreshTimeline];
    }
}

@end
