//
//  UPCRestKitConfigurator.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 16/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "RestKit/RestKit.h"

@interface UPCRestKitConfigurator : NSObject

@property (strong, readonly, nonatomic) RKObjectManager *manager;

@property (strong, readonly, nonatomic) RKObjectMapping *personMapping;
@property (strong, readonly, nonatomic) RKObjectMapping *noteMapping;
@property (strong, readonly, nonatomic) RKObjectMapping *commentMapping;
@property (strong, readonly, nonatomic) RKObjectMapping *activityMapping;

@property (strong, readonly, nonatomic) RKObjectMapping *postCommentActivitySerialization;

+ (UPCRestKitConfigurator *)sharedConfigurator;

@end
