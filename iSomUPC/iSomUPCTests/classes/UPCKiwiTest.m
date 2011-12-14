//
//  UPCKiwiTest.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 13/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(UPCKiwiTest)

describe(@"BDD", ^{
    it(@"is cool", ^{
        NSUInteger a = 12;
        NSUInteger b = 16;
        [[theValue(a+b) should] equal:theValue(28)];
    });
});

SPEC_END