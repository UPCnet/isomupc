//
//  UPCMaxConnector.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 20/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCMaxConnector.h"
#import "UPCMaxNotifications.h"
#import "UPCRestKitConfigurator.h"

#define TIMELINE_RESOURCE_PATH_TEMPLATE @"/people/%@/timeline"


@implementation UPCMaxConnector

#pragma mark - Synthesized properties

@synthesize authenticatedUser = _authenticatedUser;
@synthesize timeline = _timeline;
@synthesize activities = _activities;
@synthesize timelineLastUpdate = _timelineLastUpdate;
@synthesize activitiesLastUpdate = _activitiesLastUpdate;

#pragma mark - Shared Max connector creation

+ (UPCMaxConnector *)sharedMaxConnector
{
    static UPCMaxConnector *maxConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maxConnector = [UPCMaxConnector alloc];
        maxConnector = [maxConnector init];
    });
    
    return maxConnector;
}

#pragma mark - Resource path generation

- (NSString *)timelineResourcePath
{
    return [NSString stringWithFormat:TIMELINE_RESOURCE_PATH_TEMPLATE, [self authenticatedUser]];
}

#pragma mark - Data refresh methods

- (void)refreshTimeline
{
    if (self.authenticatedUser != nil) 
    {
        RKObjectManager *objectManager = [UPCRestKitConfigurator sharedConfigurator].manager;
        [objectManager loadObjectsAtResourcePath:[self timelineResourcePath] delegate:self];
    }
}

- (void)refreshActivities
{
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    if ([objectLoader.resourcePath isEqual:[self timelineResourcePath]] ) 
    {
        _timeline = [NSArray array];
        _timelineLastUpdate = nil;
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
        [[NSNotificationCenter defaultCenter] postNotificationName:TIMELINE_REFRESH_ERROR_NOTIFICATION object:self userInfo:errorInfo];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if ([objectLoader.resourcePath isEqual:[self timelineResourcePath]] ) 
    {
        _timeline = objects;
        _timelineLastUpdate = [NSDate date];
        [[NSNotificationCenter defaultCenter] postNotificationName:TIMELINE_REFRESHED_NOTIFICATION object:self];
    }
}

@end
