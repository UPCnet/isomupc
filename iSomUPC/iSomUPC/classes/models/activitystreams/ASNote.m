//
//  ASNote.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 15/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "ASNote.h"

@implementation ASNote

@synthesize author;
@synthesize content;
@synthesize url;
@synthesize published;
@synthesize updated;

- (NSString *)objectType
{
    return @"note";
}

@end
