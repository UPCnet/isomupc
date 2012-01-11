//
//  ASNote.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 15/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "ASObject.h"

@interface ASNote : ASObject

@property (strong, nonatomic) ASObject *author;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDate *published;
@property (strong, nonatomic) NSDate *updated;

@end
