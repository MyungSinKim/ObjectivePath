//
//  main.m
//  ObjectPath
//
//  Created by Jonathan Wight on 5/21/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CObjectivePath.h"

int main(int argc, const char * argv[])
    {
    @autoreleasepool
        {
        id theTestData = @[ @"A", @"B", @"C" ];
        CObjectivePath *thePath = [[CObjectivePath alloc] initWithFormat:@"%@", [NSNumber numberWithInt:0]];
        NSError *theError = NULL;
        id theResult = [thePath evaluateObject:theTestData error:&theError];
//        id theExpectedResult = @[@"a", @"c"];
        NSLog(@"%@", theError);
        NSLog(@"%@", theResult);
        }
    return(0);
    }

