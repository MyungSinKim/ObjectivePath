//
//  main.m
//  ObjectPath
//
//  Created by Jonathan Wight on 5/21/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CObjectPath.h"

int main(int argc, const char * argv[])
    {
    @autoreleasepool
        {
        NSDictionary *theDictionary = @{ @"A" : @{ @"B" : @[@"C", @"D"] } };
        CObjectPath *thePath = [CObjectPath objectPathWithFormat:@"A.B.(0,1)" argumentArray:NULL];
        id theResult = [thePath evaluateObject:theDictionary];
        NSLog(@"%@", theResult);
        }
    return(0);
    }

