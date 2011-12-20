//
//  UPCRKJSonParser.h
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 16/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPCRKJSonParser : NSObject

+ (id)parse:(NSString *)jsonFile;

@end
