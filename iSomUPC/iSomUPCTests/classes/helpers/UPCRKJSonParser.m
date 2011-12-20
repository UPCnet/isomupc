//
//  UPCRKJSonParser.m
//  iSomUPC
//
//  Created by Jose Gonzalez Gomez on 16/12/11.
//  Copyright (c) 2011 UPCnet. All rights reserved.
//

#import "UPCRKJSonParser.h"
#import "RestKit/RestKit.h"

@implementation UPCRKJSonParser

+ (NSString *)read:(NSString *)fileName
{
    NSError* error = nil;
    NSBundle *bundle = [NSBundle bundleForClass:[UPCRKJSonParser class]];
    NSString* filePath = [bundle pathForResource:fileName ofType:nil];
    NSString* fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (fileContent == nil && error) 
    {
        [NSException raise:nil format:@"Failed to read contents of file '%@'. Error: %@", fileName, [error localizedDescription]];
    }
    return fileContent;
}

+ (id)parse:(NSString *)jsonFileName
{
    NSError *error = nil;
    NSString* data = [UPCRKJSonParser read:jsonFileName];
    NSString* MIMEType = RKMIMETypeJSON;
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    return [parser objectFromString:data error:&error];
}

@end
