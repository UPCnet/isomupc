//
//  NSDate+HumanReadableInterval.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 19/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "NSDate+HumanReadableInterval.h"


@implementation NSDate (HumanReadableInterval)

- (NSString *)humanReadableIntervalFrom:(NSDate *)date
{
    double timeInterval = [self timeIntervalSinceDate:date];
    timeInterval = timeInterval * -1;
    if(timeInterval < 1)
        return @"en el futur";
    else if (timeInterval < 60)
        return @"fa menys d'un minut";
    else if (timeInterval < 3600)
    {
        int diff = round(timeInterval / 60);
        return [NSString stringWithFormat:@"fa %d minuts", diff];
    } 
    else if (timeInterval < 86400) 
    {
        int diff = round(timeInterval / 60 / 60);
        return[NSString stringWithFormat:@"fa %d hores", diff];
    } 
    else if (timeInterval < 2629743) 
    {
        int diff = round(timeInterval / 60 / 60 / 24);
        return[NSString stringWithFormat:@"fa %d dies", diff];
    } 
    else
        return @"mai";
}

@end
