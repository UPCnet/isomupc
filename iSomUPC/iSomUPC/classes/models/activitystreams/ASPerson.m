//
//  ASPerson.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 15/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "ASPerson.h"

@implementation ASPerson

@synthesize displayName;
@synthesize image;
@synthesize url;
@synthesize published;
@synthesize updated;

- (NSString *)objectType
{
    return @"person";
}

@end
