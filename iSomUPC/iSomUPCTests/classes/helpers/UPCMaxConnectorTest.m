//
//  UPCMaxConnectorTest.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 20/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "Kiwi.h"
#import "UPCMaxConnector.h"
#import "UPCMaxNotifications.h"
#import "UPCRestKitConfigurator.h"

SPEC_BEGIN(UPCMaxConnectorTest)

describe(@"UPCMaxConnector", ^{
    context(@"when refreshing timeline", ^{
        __block UPCMaxConnector *maxConnector;
        __block RKObjectLoader *objectLoader;
        
        beforeEach(^{
            maxConnector = [[UPCMaxConnector alloc] init];
            objectLoader = [RKObjectLoader mock];
        });
        
        it(@"should delegate operation to UPCRestKitConfigurator's sharedObjectManager", ^{
            RKObjectManager *objectManager = [RKObjectManager mock];
            [[objectManager should] receive:@selector(loadObjectsAtResourcePath:delegate:)];
            [[[UPCRestKitConfigurator sharedConfigurator] stubAndReturn:objectManager] manager];
            
            [maxConnector refreshTimeline];
        });
        
        context(@"and operation is successful", ^{
            __block NSArray *receivedTimeline;
            
            beforeEach(^{
                receivedTimeline = [NSArray array];
            });
            
            context(@"for current user", ^{
                beforeEach(^{
                    [objectLoader stub:@selector(resourcePath) andReturn:@"/people/jose/timeline"];
                });
                
                it(@"should store the received timeline", ^{
                    [maxConnector objectLoader:objectLoader didLoadObjects:receivedTimeline];
                    [[maxConnector.timeline should] beIdenticalTo:receivedTimeline]; 
                });
                
                it(@"should store the date of the update", ^{
                    NSDate *dateBeforeUpdate = [NSDate date];
                    [maxConnector objectLoader:objectLoader didLoadObjects:receivedTimeline];
                    NSDate *dateAfterUpdate = [NSDate date];
                    
                    [[maxConnector.timelineLastUpdate should] beBetween:dateBeforeUpdate and:dateAfterUpdate];
                });
                
                it(@"should notify the success", ^{
                    [[[[NSNotificationCenter defaultCenter] should] receive] postNotificationName:TIMELINE_REFRESHED_NOTIFICATION object:maxConnector];
                    [maxConnector objectLoader:objectLoader didLoadObjects:receivedTimeline];
                });
            });
            
            context(@"for another user", ^{
                beforeEach(^{
                    [objectLoader stub:@selector(resourcePath) andReturn:@"/people/victor/timeline"];
                });
                
                it(@"should ignore the received timeline", ^{
                    [maxConnector objectLoader:objectLoader didLoadObjects:receivedTimeline];
                    [maxConnector.timeline shouldBeNil]; 
                });
                
                it(@"shouldn't store the date of the update", ^{
                    [maxConnector objectLoader:objectLoader didLoadObjects:receivedTimeline];
                    [maxConnector.timelineLastUpdate shouldBeNil];
                });
                
                it(@"shouldn't notify the success", ^{
                    [[[[NSNotificationCenter defaultCenter] shouldNot] receive] postNotificationName:TIMELINE_REFRESHED_NOTIFICATION object:maxConnector];
                    [maxConnector objectLoader:objectLoader didLoadObjects:receivedTimeline];
                });
            });
        });
        
        context(@"and operation fails", ^{
            __block NSError *error;
            __block NSArray *previousTimeline;
            
            beforeEach(^{
                error = [NSError errorWithDomain:@"UPCMax" code:0 userInfo:nil];

                previousTimeline = [NSArray arrayWithObject:@"activity"];
                RKObjectLoader *previousObjectLoader = [RKObjectLoader mock];
                [previousObjectLoader stub:@selector(resourcePath) andReturn:@"/people/jose/timeline"];
                [maxConnector objectLoader:previousObjectLoader didLoadObjects:previousTimeline];
            });
            
            context(@"for current user", ^{
                beforeEach(^{
                    [objectLoader stub:@selector(resourcePath) andReturn:@"/people/jose/timeline"];
                });
                
                it(@"should empty the timeline", ^{
                    [[maxConnector.timeline shouldNot] beEmpty];
                    [maxConnector objectLoader:objectLoader didFailWithError:error];
                    [[maxConnector.timeline should] beEmpty];
                });
                
                it(@"should empty the date of the last update", ^{
                    [maxConnector.timelineLastUpdate shouldNotBeNil];
                    [maxConnector objectLoader:objectLoader didFailWithError:error];
                    [maxConnector.timelineLastUpdate shouldBeNil];
                });
                
                it(@"should notify the error", ^{
                    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
                    [[[[NSNotificationCenter defaultCenter] should] receive] postNotificationName:TIMELINE_REFRESH_ERROR_NOTIFICATION object:maxConnector userInfo:errorInfo];
                    [maxConnector objectLoader:objectLoader didFailWithError:error];
                });
            });
            
            context(@"for another user", ^{
                beforeEach(^{
                    [objectLoader stub:@selector(resourcePath) andReturn:@"/people/victor/timeline"];
                });
                
                it(@"should preserve the existing timeline", ^{
                    [maxConnector objectLoader:objectLoader didFailWithError:error];
                    [[maxConnector.timeline should] beIdenticalTo:previousTimeline];
                });
                
                it(@"should preserve the date of the last update", ^{
                    NSDate *previousLastUpdateDate = maxConnector.timelineLastUpdate;
                    [maxConnector objectLoader:objectLoader didFailWithError:error];
                    [[maxConnector.timelineLastUpdate should] beIdenticalTo:previousLastUpdateDate];
                });
                
                it(@"shouldn't notify anything", ^{
                    [[[NSNotificationCenter defaultCenter] shouldNot] receive:@selector(postNotification:)];
                    [[[NSNotificationCenter defaultCenter] shouldNot] receive:@selector(postNotificationName:object:)];
                    [[[NSNotificationCenter defaultCenter] shouldNot] receive:@selector(postNotificationName:object:userInfo:)];
                    
                    [maxConnector objectLoader:objectLoader didFailWithError:error];
                });
            });
        });
    });
});

SPEC_END
