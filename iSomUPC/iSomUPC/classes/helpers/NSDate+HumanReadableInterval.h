//
//  NSDate+HumanReadableInterval.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 19/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (HumanReadableInterval)

- (NSString *)humanReadableIntervalFrom:(NSDate *)date;

@end
