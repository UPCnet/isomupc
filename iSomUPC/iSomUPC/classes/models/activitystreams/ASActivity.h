//
//  ASActivity.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 15/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "ASObject.h"
#import "ASMediaLink.h"

@interface ASActivity : ASObject

@property (strong, nonatomic) ASObject *actor;
@property (strong, nonatomic) NSDate *published;
@property (strong, nonatomic) NSString *verb;

@property (strong, nonatomic) NSDate *updated;
@property (strong, nonatomic) NSString *url;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) ASMediaLink *icon;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) ASObject *object;
@property (strong, nonatomic) ASObject *target;

@property (strong, nonatomic) ASObject *generator;
@property (strong, nonatomic) ASObject *provider;

@end
