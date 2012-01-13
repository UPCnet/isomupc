//
//  UPCSecondViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 13/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCProfileViewController.h"
#import "UPCMaxConnector.h"
#import "UPCLoginController.h"


@implementation UPCProfileViewController

@synthesize displayNameLabel;

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.displayNameLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.displayNameLabel.text = [UPCMaxConnector sharedMaxConnector].authenticatedUser;
}

#pragma mark Event management

- (void)logout:(id)sender
{
    [UPCMaxConnector sharedMaxConnector].authenticatedUser = nil;
    UPCLoginController *loginController = [[UPCLoginController alloc] init];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentModalViewController:loginController animated:YES];
}

@end
