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


#pragma mark - Class extension

@interface UPCRestKitConfigurator ()

@property (strong, nonatomic) RKObjectManager *manager;
@property (strong, nonatomic) RKObjectMapping *personMapping;
@property (strong, nonatomic) RKObjectMapping *noteMapping;
@property (strong, nonatomic) RKObjectMapping *commentMapping;
@property (strong, nonatomic) RKObjectMapping *activityMapping;
@property (strong, nonatomic) RKObjectMapping *postCommentActivitySerialization;

- (void)configureRestKitObjectManager;

@end


#pragma mark - Class implementation

@implementation UPCRestKitConfigurator

#pragma mark Synthesized properties

@synthesize manager;
@synthesize personMapping;
@synthesize noteMapping;
@synthesize commentMapping;
@synthesize activityMapping;
@synthesize postCommentActivitySerialization;

#pragma mark Init and dealloc

- (id)init {
    self = [super init];
    if (self != nil) 
    {
        [self configureRestKitObjectManager];
    }
    return self;
}

#pragma mark Factory methods

- (void)configureRestKitObjectManager
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
    
    self.personMapping = [RKObjectMapping mappingForClass:[ASPerson class]];
    [self.personMapping mapAttributes:@"id", @"displayName", @"image", @"url", @"published", @"updated", nil];
    
    self.noteMapping = [RKObjectMapping mappingForClass:[ASNote class]];
    [self.noteMapping mapAttributes:@"id", @"content", @"url", @"published", @"updated", nil];
    [self.noteMapping mapRelationship:@"author" withMapping:objectDynamicMapping];
    
    self.commentMapping = [RKObjectMapping mappingForClass:[ASComment class]];
    [self.commentMapping mapAttributes:@"id", @"displayName", @"content", @"published", @"updated", nil];
    [self.commentMapping mapRelationship:@"author" withMapping:objectDynamicMapping];
    [self.commentMapping mapRelationship:@"inReplyTo" withMapping:objectDynamicMapping];
    self.commentMapping.rootKeyPath = @"items";
    
    [objectDynamicMapping setObjectMapping:personMapping whenValueOfKeyPath:@"objectType" isEqualTo:@"person"];
    [objectDynamicMapping setObjectMapping:noteMapping whenValueOfKeyPath:@"objectType" isEqualTo:@"note"];
    [objectDynamicMapping setObjectMapping:commentMapping whenValueOfKeyPath:@"objectType" isEqualTo:@"comment"];
    
    // ActivityStreams activity mapping
    self.activityMapping = [RKObjectMapping mappingForClass:[ASActivity class]];
    [self.activityMapping mapAttributes:@"id", @"published", @"verb", @"updated", @"url", @"title", @"content", nil];
    [self.activityMapping mapRelationship:@"actor" withMapping:objectDynamicMapping];
    [self.activityMapping mapRelationship:@"icon" withMapping:mediaLinkMapping];
    [self.activityMapping mapRelationship:@"object" withMapping:objectDynamicMapping];
    [self.activityMapping mapRelationship:@"target" withMapping:objectDynamicMapping];
    [self.activityMapping mapRelationship:@"generator" withMapping:objectDynamicMapping];
    [self.activityMapping mapRelationship:@"provider" withMapping:objectDynamicMapping];
    
    // ActivityStreams object serialization
    RKObjectMapping *personSerialization = [personMapping inverseMapping];
    [personSerialization mapAttributes:@"objectType", nil];
    RKObjectMapping *noteSerialization = [noteMapping inverseMapping];
    [noteSerialization mapAttributes:@"objectType", nil];
    RKObjectMapping *commentSerialization = [commentMapping inverseMapping];
    [commentSerialization mapAttributes:@"objectType", nil];
    
    // ActivityStreams activity serialization
    RKObjectMapping *activitySerialization = [activityMapping inverseMapping];
    [activitySerialization mapRelationship:@"actor" withMapping:personSerialization];
    [activitySerialization mapRelationship:@"object" withMapping:noteSerialization];
    
    self.postCommentActivitySerialization = [activityMapping inverseMapping];
    [self.postCommentActivitySerialization mapRelationship:@"actor" withMapping:personSerialization];
    [self.postCommentActivitySerialization mapRelationship:@"object" withMapping:commentSerialization];
    
    self.manager = [RKObjectManager objectManagerWithBaseURL:@"http://max.beta.upcnet.es"];
    [self.manager.mappingProvider setMapping:activityMapping forKeyPath:@"items"];
    [self.manager.mappingProvider setSerializationMapping:activitySerialization forClass:[ASActivity class]];
    self.manager.serializationMIMEType = RKMIMETypeJSON;
    
    // Route mapping
    [self.manager.router routeClass:[ASActivity class] toResourcePath:@"/people/:actor.displayName/activities" forMethod:RKRequestMethodPOST];
    [self.manager.router routeClass:[ASActivity class] toResourcePath:@"/activities/:id"];
}

+ (UPCRestKitConfigurator *)sharedConfigurator
{
    static UPCRestKitConfigurator *sharedConfigurator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfigurator = [UPCRestKitConfigurator alloc];
        sharedConfigurator = [sharedConfigurator init];
    });
    
    return sharedConfigurator;
}

@end
