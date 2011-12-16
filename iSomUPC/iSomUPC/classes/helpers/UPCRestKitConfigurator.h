//
//  UPCRestKitConfigurator.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 16/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "RestKit/RestKit.h"

@interface UPCRestKitConfigurator : NSObject

+ (RKObjectManager *)sharedManager;

@end
