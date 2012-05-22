//
//  NSIndexSet+Extensions.m
//  ObjectPath
//
//  Created by Jonathan Wight on 5/22/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import "NSIndexSet+Extensions.h"

@implementation NSIndexSet (Extensions)

+ (NSIndexSet *)indexSetWithIndexesInSet:(NSSet *)set;
    {
    return([[self alloc] initWithIndexesInSet:set]);
    }

- (id)initWithIndexesInSet:(NSSet *)set;
    {
    NSMutableIndexSet *theSet = [[NSMutableIndexSet alloc] init];

    for (NSNumber *theIndex in set)
        {
        [theSet addIndex:[theIndex integerValue]];
        }

    if ((self = [self initWithIndexSet:theSet]) != NULL)
        {
        }
    return self;
    }

@end
