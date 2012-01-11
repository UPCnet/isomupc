//
//  ASComment.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 11/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "ASComment.h"


@implementation ASComment

@synthesize author;
@synthesize displayName;
@synthesize content;
@synthesize inReplyTo;
@synthesize published;
@synthesize updated;

- (NSString *)objectType
{
    return @"comment";
}

@end
