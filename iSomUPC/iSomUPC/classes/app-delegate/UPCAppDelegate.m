//
//  UPCAppDelegate.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 13/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCAppDelegate.h"
#import "UPCSecondViewController.h"
#import "UPCRestKitConfigurator.h"
#import "FlurryAnalytics.h"

@implementation UPCAppDelegate

#pragma mark - Synthesized properties

@synthesize window = _window;

#pragma mark - Application life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FlurryAnalytics startSession:@"Q327W78Z3TYMEYARTQFM"];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
