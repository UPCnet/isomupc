//
//  ASComment.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 11/01/12.
//  Copyright (c) 2012 UPCnet. All rights reserved.
//

#import "ASObject.h"


@interface ASComment : ASObject

@property (strong, nonatomic) ASObject *author;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *inReplyTo;

@property (strong, nonatomic) NSDate *published;
@property (strong, nonatomic) NSDate *updated;

@end
