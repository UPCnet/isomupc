//
//  ASActivityTest.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 15/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "Kiwi.h"
#import "ASActivity.h"

SPEC_BEGIN(ASActivityTest)

describe(@"ASActivity", ^{
    context(@"when newly created", ^{
        it(@"should have post as default verb", ^{
            ASActivity *activity = [[ASActivity alloc] init];
            [[activity.verb should] equal:@"post"];
        });
    });
});

SPEC_END