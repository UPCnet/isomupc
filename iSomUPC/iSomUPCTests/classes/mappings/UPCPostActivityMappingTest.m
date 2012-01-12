//
//  UPCPostActivityMappingTest.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 16/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "Kiwi.h"
#import "RestKit/RestKit.h"
#import "ASActivityStreams.h"
#import "UPCRestKitConfigurator.h"
#import "UPCRKJSonParser.h"

SPEC_BEGIN(UPCPostActivityMappingTest)

describe(@"ActivityStreams mapping", ^{
    context(@"when parsing a valid post activity", ^{
        __block NSArray *parsedActivities;
        __block ASActivity *parsedActivity;
        
        beforeAll(^{
            id activitiesInfo = [UPCRKJSonParser parse:@"timeline.post.json"];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedConfigurator].manager.mappingProvider;
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:activitiesInfo mappingProvider:provider];
            parsedActivities = [[mapper performMapping] asCollection];
            parsedActivity = [parsedActivities objectAtIndex:0];
        });
        
        it(@"should have parsed exactly one activity", ^{
            [[theValue([parsedActivities count]) should] equal:theValue(1)];
            [parsedActivity shouldNotBeNil];
        });
        
        it(@"should have correctly mapped the actor as a person", ^{
            [[parsedActivity.actor should] beKindOfClass:[ASPerson class]];
        });
        
        it(@"should have correctly mapped the actor's display name", ^{
            [[((ASPerson *)parsedActivity.actor).displayName should] equal:@"upcnet"];
        });
        
        it(@"should have correctly mapped the object as a note", ^{
            [[parsedActivity.object should] beKindOfClass:[ASNote class]];
        });
        
        it(@"should have correctly mapped the note's content", ^{
            [[((ASNote *)parsedActivity.object).content should] equal:@"test message"];
        });
        
        it(@"should have correctly mapped the activity's verb", ^{
            [[parsedActivity.verb should] equal:@"post"];
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
            [[parsedActivity.id should] equal:@"4ee74bb3637e0332cb00000f"];
        });
    });
});

SPEC_END