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
#import "UIImageView+WebCache.h"


@implementation UPCProfileViewController

@synthesize avatarImageView;
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
    id userDisplayName = [UPCMaxConnector sharedMaxConnector].authenticatedUser;
    NSString *avatarURL = [NSString stringWithFormat:@"http://max.beta.upcnet.es/people/%@/avatar", userDisplayName];
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"user"]];
    self.displayNameLabel.text = userDisplayName;
}

#pragma mark Event management

- (void)logout:(id)sender
{
    [UPCMaxConnector sharedMaxConnector].authenticatedUser = nil;
    UPCLoginController *loginController = [[UPCLoginController alloc] init];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentModalViewController:loginController animated:YES];
}

@end
