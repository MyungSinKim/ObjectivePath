//
//  CObjectivePath.h
//  ObjectPath
//
//  Created by Jonathan Wight on 5/21/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kObjectivePathErrorDomain;

enum {
    kObjectivePathErrorCode_Unknown = -1,
} EObjectivePathErrorCode;

@interface CObjectivePath : NSObject

@property (readonly, nonatomic, strong) NSString *format;
@property (readonly, nonatomic, strong) NSArray *arguments;
@property (readonly, nonatomic, assign) BOOL compiled;

- (id)initWithFormat:(NSString *)format argumentArray:(NSArray *)arguments;
- (id)initWithFormat:(NSString *)format, ...;
- (id)initWithFormat:(NSString *)format arguments:(va_list)argList;

/// C
- (BOOL)compile:(NSError **)outError;

- (id)evaluateObject:(id)inObject error:(NSError **)outError;

@end
