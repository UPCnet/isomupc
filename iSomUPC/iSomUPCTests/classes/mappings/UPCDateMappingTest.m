//
//  UPCDateMappingTest.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 20/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "Kiwi.h"
#import "UPCRestKitConfigurator.h"
#import "ASActivityStreams.h"
#import "RestKit/RestKit.h"
#import "UPCRKJSonParser.h"

SPEC_BEGIN(UPCDateMappingTest)

describe(@"ActivityStreams date mapping", ^{
    context(@"when parsing an activity with a valid date", ^{
        __block NSArray *parsedActivities;
        __block ASActivity *parsedActivity;
        
        beforeAll(^{
            id activitiesInfo = [UPCRKJSonParser parse:@"timeline.post.json"];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedManager].mappingProvider;
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:activitiesInfo mappingProvider:provider];
            parsedActivities = [[mapper performMapping] asCollection];
            parsedActivity = [parsedActivities objectAtIndex:0];
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
    
    context(@"when parsing an activity with an invalid date", ^{
        __block NSArray *parsedActivities;
        __block ASActivity *parsedActivity;
        
        beforeAll(^{
            id activitiesInfo = [UPCRKJSonParser parse:@"timeline.post.invalid-date.json"];
            RKObjectMappingProvider *provider = [UPCRestKitConfigurator sharedManager].mappingProvider;
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:activitiesInfo mappingProvider:provider];
            parsedActivities = [[mapper performMapping] asCollection];
            parsedActivity = [parsedActivities objectAtIndex:0];
        });
        
        it(@"should have been unable to correctly map the activity's publication date", ^{
            [parsedActivity.published shouldBeNil];
        });
    });
});

SPEC_END