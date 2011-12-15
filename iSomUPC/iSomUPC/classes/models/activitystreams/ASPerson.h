//
//  ASPerson.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 15/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "ASObject.h"

@interface ASPerson : ASObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDate *published;
@property (strong, nonatomic) NSDate *updated;

@end
