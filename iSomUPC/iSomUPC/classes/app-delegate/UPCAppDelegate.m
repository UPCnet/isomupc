//
//  UPCAppDelegate.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 13/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCAppDelegate.h"
#import "UPCMaxConnector.h"
#import "UPCLoginController.h"
#import "FlurryAnalytics.h"

@implementation UPCAppDelegate

#pragma mark - Synthesized properties

@synthesize window = _window;

#pragma mark - Application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FlurryAnalytics startSession:@"Q327W78Z3TYMEYARTQFM"];
    [self.window makeKeyAndVisible];
    if ([UPCMaxConnector sharedMaxConnector].authenticatedUser == nil) 
    {
        UPCLoginController *loginController = [[UPCLoginController alloc] init];
        [self.window.rootViewController presentModalViewController:loginController animated:NO];
    }
    return YES;
}

@end
