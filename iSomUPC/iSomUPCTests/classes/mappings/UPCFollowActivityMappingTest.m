//
//  UPCFollowActivityMappingTest.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 20/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "Kiwi.h"
#import "RestKit/RestKit.h"
#import "ASActivityStreams.h"
#import "UPCRestKitConfigurator.h"
#import "UPCRKJSonParser.h"

SPEC_BEGIN(UPCFollowActivityMappingTest)

describe(@"ActivityStreams mapping", ^{
    context(@"when parsing a valid follow activity", ^{
        __block NSArray *parsedActivities;
        __block ASActivity *parsedActivity;
        
        beforeAll(^{
            id activitiesInfo = [UPCRKJSonParser parse:@"timeline.follow.json"];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedConfigurator].manager.mappingProvider;
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:activitiesInfo mappingProvider:provider];
            parsedActivities = [[mapper performMapping] asCollection];
            parsedActivity = [parsedActivities objectAtIndex:0];
        });
        
        it(@"should have parsed exactly one activity", ^{
            [[theValue([parsedActivities count]) should] equal:theValue(1)];
            [parsedActivity shouldNotBeNil];
        });
        
        it(@"should have correctly mapped the actor (follower) as a person", ^{
            [[parsedActivity.actor should] beKindOfClass:[ASPerson class]];
        });
        
        it(@"should have correctly mapped the actor's (follower) display name", ^{
            [[((ASPerson *)parsedActivity.actor).displayName should] equal:@"jose"];
        });
        
        it(@"should have correctly mapped the object (followee) as a person", ^{
            [[parsedActivity.object should] beKindOfClass:[ASPerson class]];
        });
        
        it(@"should have correctly mapped the followees's display name", ^{
            [[((ASPerson *)parsedActivity.object).displayName should] equal:@"victor"];
        });
        
        it(@"should have correctly mapped the activity's verb", ^{
            [[parsedActivity.verb should] equal:@"follow"];
        });
        
        it(@"should have correctly mapped the activity's publication date", ^{
            NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
            rfc3339DateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            rfc3339DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            rfc3339DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
            NSDate *expectedPublicationDate = [rfc3339DateFormatter dateFromString:@"2011-12-13T14:15:16Z"];
            
            [expectedPublicationDate shouldNotBeNil];
            [[parsedActivity.published should] equal:expectedPublicationDate];
        });
        
        it(@"should have correctly mapped the activity's id", ^{
            [[parsedActivity.id should] equal:@"4ee721dd637e0332cb000006"];
        });
    });
});

SPEC_END