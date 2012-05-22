//
//  NSIndexSet+Extensions.h
//  ObjectPath
//
//  Created by Jonathan Wight on 5/22/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexSet (Extensions)

+ (NSIndexSet *)indexSetWithIndexesInSet:(NSSet *)set;
- (id)initWithIndexesInSet:(NSSet *)set;

@end
