//
//  ASActivity.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 15/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "ASActivity.h"

@implementation ASActivity

#pragma mark - Synthesized properties

@synthesize actor;
@synthesize published;
@synthesize verb;

@synthesize replies;

@synthesize updated;
@synthesize url;

@synthesize title;
@synthesize icon;
@synthesize content;
@synthesize object;
@synthesize target;

@synthesize generator;
@synthesize provider;

#pragma mark - Init and dealloc

- (id)init
{
    self = [super init];
    if (self != nil) 
    {
        self.verb = @"post";
    }
    return self;
}

@end
