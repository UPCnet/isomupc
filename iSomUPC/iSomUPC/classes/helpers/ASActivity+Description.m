//
//  ASActivity+Description.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 11/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "ASActivity+Description.h"
#import "ASActivityStreams.h"


@implementation ASActivity (Description)

- (NSString *)followDescription
{
    return [NSString stringWithFormat:@"%@ está siguiendo a %@", ((ASPerson *)self.actor).displayName, ((ASPerson *)self.object).displayName]; 
}

- (NSString *)postDescription
{
    return [NSString stringWithFormat:@"%@", [self.object valueForKey:@"content"]]; 
}

- (NSString *)description
{
    if ([self.verb isEqualToString:@"follow"])
        return [self followDescription];
    else if ([self.verb isEqualToString:@"post"])
        return [self postDescription];
    else
        return nil;
}

@end
