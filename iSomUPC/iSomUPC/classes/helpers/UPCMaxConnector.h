//
//  UPCMaxConnector.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 20/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"

@interface UPCMaxConnector : NSObject <RKObjectLoaderDelegate>

@property (strong, nonatomic) NSString *authenticatedUser;
@property (strong, readonly, nonatomic) NSArray *timeline;
@property (strong, readonly, nonatomic) NSDate *timelineLastUpdate;
@property (strong, readonly, nonatomic) NSArray *activities;
@property (strong, readonly, nonatomic) NSDate *activitiesLastUpdate;

+ (UPCMaxConnector *)sharedMaxConnector;

- (void)refreshTimeline;
- (void)refreshActivities;

@end
