//
//  UPCRestKitConfigurator.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 16/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCRestKitConfigurator.h"
#import "RestKit/RestKit.h"
#import "ASActivityStreams.h"


@implementation UPCRestKitConfigurator

+ (void)configureRestKitObjectManager
{
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    rfc3339DateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    rfc3339DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    rfc3339DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    [RKObjectMapping setPreferredDateFormatter:rfc3339DateFormatter];
    
    RKObjectMapping *mediaLinkMapping = [RKObjectMapping mappingForClass:[ASMediaLink class]];
    [mediaLinkMapping mapAttributes:@"url", @"duration", @"height", @"width", nil];
    
    // ActivityStreams object mapping
    RKDynamicObjectMapping *objectDynamicMapping = [RKDynamicObjectMapping dynamicMapping];
    
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[ASObject class]];
    [objectMapping mapAttributes:@"id", nil];
    
    RKObjectMapping *personMapping = [RKObjectMapping mappingForClass:[ASPerson class]];
    [personMapping mapAttributes:@"id", @"displayName", @"image", @"url", @"published", @"updated", nil];
    
    RKObjectMapping *noteMapping = [RKObjectMapping mappingForClass:[ASNote class]];
    [noteMapping mapAttributes:@"id", @"content", @"url", @"published", @"updated", nil];
    [noteMapping mapRelationship:@"author" withMapping:objectDynamicMapping];
    
    RKObjectMapping *commentMapping = [RKObjectMapping mappingForClass:[ASComment class]];
    [commentMapping mapAttributes:@"id", @"displayName", @"content", @"published", @"updated", nil];
    [commentMapping mapRelationship:@"author" withMapping:objectDynamicMapping];
    [commentMapping mapRelationship:@"inReplyTo" withMapping:objectDynamicMapping];
    
    [objectDynamicMapping setObjectMapping:personMapping whenValueOfKeyPath:@"objectType" isEqualTo:@"person"];
    [objectDynamicMapping setObjectMapping:noteMapping whenValueOfKeyPath:@"objectType" isEqualTo:@"note"];
    [objectDynamicMapping setObjectMapping:commentMapping whenValueOfKeyPath:@"objectType" isEqualTo:@"comment"];
    
    // ActivityStreams activity mapping
    RKObjectMapping *activityMapping = [RKObjectMapping mappingForClass:[ASActivity class]];
    [activityMapping mapAttributes:@"id", @"published", @"verb", @"updated", @"url", @"title", @"content", nil];
    [activityMapping mapRelationship:@"actor" withMapping:objectDynamicMapping];
    [activityMapping mapRelationship:@"icon" withMapping:mediaLinkMapping];
    [activityMapping mapRelationship:@"object" withMapping:objectDynamicMapping];
    [activityMapping mapRelationship:@"target" withMapping:objectDynamicMapping];
    [activityMapping mapRelationship:@"generator" withMapping:objectDynamicMapping];
    [activityMapping mapRelationship:@"provider" withMapping:objectDynamicMapping];
    
    // ActivityStreams object serialization
    RKObjectMapping *personSerialization = [personMapping inverseMapping];
    [personSerialization mapAttributes:@"objectType", nil];
    RKObjectMapping *noteSerialization = [noteMapping inverseMapping];
    [noteSerialization mapAttributes:@"objectType", nil];
    
    // ActivityStreams activity serialization
    RKObjectMapping *activitySerialization = [activityMapping inverseMapping];
    [activitySerialization mapRelationship:@"actor" withMapping:personSerialization];
    [activitySerialization mapRelationship:@"object" withMapping:noteSerialization];
    
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:@"http://max.beta.upcnet.es"];
    [manager.mappingProvider setMapping:activityMapping forKeyPath:@"items"];
    [manager.mappingProvider setSerializationMapping:activitySerialization forClass:[ASActivity class]];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    // Route mapping
    [manager.router routeClass:[ASActivity class] toResourcePath:@"/people/:actor.displayName/activities" forMethod:RKRequestMethodPOST];
    [manager.router routeClass:[ASActivity class] toResourcePath:@"/activities/:id"];
}

+ (RKObjectManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UPCRestKitConfigurator configureRestKitObjectManager];
    });
    
    return [RKObjectManager sharedManager];
}

@end
