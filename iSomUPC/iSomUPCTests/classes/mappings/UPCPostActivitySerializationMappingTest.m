//
//  UPCPostActivitySerializationMappingTest.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 08/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "Kiwi.h"
#import "RestKit/RestKit.h"
#import "ASActivityStreams.h"
#import "UPCRestKitConfigurator.h"


SPEC_BEGIN(UPCPostActivitySerializationMappingTest)

describe(@"ActivityStreams serialization mapping", ^{
    context(@"when serializing a valid post activity", ^{
        __block ASActivity *activity;
        __block NSDictionary *parsedActivity;
        __block NSError *serializationError;
        
        beforeAll(^{
            ASNote *note = [[ASNote alloc] init];
            note.content = @"Note content";
            
            ASPerson *actor = [[ASPerson alloc] init];
            actor.id = @"actor-id";
            actor.displayName = @"actor-displayName";
            
            activity = [[ASActivity alloc] init];
            activity.object = note;
            activity.actor = actor;
            activity.verb = @"post";
            activity.published = [NSDate date];
            activity.id = @"activity-id";
            
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedManager].mappingProvider;
            RKObjectMapping *serializationMapping = [provider serializationMappingForClass:[ASActivity class]];
            RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:activity mapping:serializationMapping];
            parsedActivity = [serializer serializedObject:&serializationError];
            
            NSError *error;
            NSLog(@"JSON result:\n %@", [serializer serializedObjectForMIMEType:@"application/json" error:&error]);
        });
        
        it(@"should have serialized the activity as a dictionary", ^{
            [serializationError shouldBeNil];
            [parsedActivity shouldNotBeNil];
            [[parsedActivity should] beKindOfClass:[NSDictionary class]];
        });
        
        it(@"should have correctly serialized the activity's attributes", ^{
            NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
            rfc3339DateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            rfc3339DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            rfc3339DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
            
            [[[parsedActivity objectForKey:@"verb"] should] equal:activity.verb];
            [[[parsedActivity objectForKey:@"published"] should] equal:[rfc3339DateFormatter stringFromDate:activity.published]];
            [[[parsedActivity objectForKey:@"id"] should] equal:activity.id];
        });
        
        it(@"should have correctly serialized the activity's object", ^{
            NSDictionary *parsedObject = [parsedActivity objectForKey:@"object"];
            [parsedObject shouldNotBeNil];
            [[[parsedObject objectForKey:@"content"] should] equal:((ASNote *)activity.object).content];
            [[[parsedObject objectForKey:@"objectType"] should] equal:@"note"];
        });
        
        it(@"should have correctly serialized the activity's actor", ^{
            NSDictionary *parsedActor = [parsedActivity objectForKey:@"actor"];
            [parsedActor shouldNotBeNil];
            [[[parsedActor objectForKey:@"id"] should] equal:((ASPerson *)activity.actor).id];
            [[[parsedActor objectForKey:@"displayName"] should] equal:((ASPerson *)activity.actor).displayName];
            [[[parsedActor objectForKey:@"objectType"] should] equal:@"person"];
        });
    });
});

SPEC_END
