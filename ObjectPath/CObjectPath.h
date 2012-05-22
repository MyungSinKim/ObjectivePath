//
//  CObjectPath.h
//  ObjectPath
//
//  Created by Jonathan Wight on 5/21/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CObjectPath : NSObject

+ (CObjectPath *)objectPathWithFormat:(NSString *)format argumentArray:(NSArray *)arguments;
//+ (CObjectPath *)objectPathWithFormat:(NSString *)format, ...;
//+ (CObjectPath *)objectPathWithFormat:(NSString *)format arguments:(va_list)argList;

- (id)evaluateObject:(id)inObject;

@end
