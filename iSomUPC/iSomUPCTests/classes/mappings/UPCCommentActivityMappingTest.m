//
//  UPCCommentActivityMappingTest.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 11/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "Kiwi.h"
#import "RestKit/RestKit.h"
#import "UPCRestKitConfigurator.h"
#import "UPCRKJSonParser.h"
#import "ASActivityStreams.h"

SPEC_BEGIN(UPCCommentActivityMappingTest)
describe(@"ActivityStreams mapping", ^{
    context(@"when parsing a valid comment activity", ^{
        __block NSArray *parsedActivities;
        __block ASActivity *parsedActivity;
        
        beforeAll(^{
            id activitiesInfo = [UPCRKJSonParser parse:@"timeline.comment.json"];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedConfigurator].manager.mappingProvider;
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:activitiesInfo mappingProvider:provider];
            parsedActivities = [[mapper performMapping] asCollection];
            parsedActivity = [parsedActivities objectAtIndex:0];
        });
        
        it(@"should have parsed exactly one activity", ^{
            [[theValue([parsedActivities count]) should] equal:theValue(1)];
            [parsedActivity shouldNotBeNil];
        });
        
        it(@"should have correctly mapped the actor (poster) as a person", ^{
            [[parsedActivity.actor should] beKindOfClass:[ASPerson class]];
        });
        
        it(@"should have correctly mapped the actor's (poster) display name", ^{
            [[((ASPerson *)parsedActivity.actor).displayName should] equal:@"jose"];
        });
        
        it(@"should have correctly mapped the object as a comment", ^{
            [[parsedActivity.object should] beKindOfClass:[ASComment class]];
        });
        
        it(@"should have correctly mapped the comment's content", ^{
            [[((ASComment *)parsedActivity.object).content should] equal:@"Test comment"];
        });
        
        it(@"should have correctly mapped the id of the object to which the comment is a reply", ^{
            [[[((ASComment *)parsedActivity.object).inReplyTo objectAtIndex:0] should] beKindOfClass:[ASNote class]];
            [[((ASNote *)[((ASComment *)parsedActivity.object).inReplyTo objectAtIndex:0]).id should] equal:@"4f0a1cd3637e035619000008"];
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
            [[parsedActivity.id should] equal:@"4f0ac8a7637e0365f1000000"];
        });
    });
});

SPEC_END
