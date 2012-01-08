//
//  UPCPostActivityViewController.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 08/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "UPCPostActivityViewController.h"

@implementation UPCPostActivityViewController

#pragma mark - Synthesized properties

@synthesize postActivityButton;

#pragma mark - View lifecycle

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
    NSLog(@"Cancel activity posting");
}

- (IBAction)postActivity:(id)sender
{
    NSLog(@"Post activity");
}

#pragma mark - Object loader delegate: hanlde result of post operation

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
}

@end
