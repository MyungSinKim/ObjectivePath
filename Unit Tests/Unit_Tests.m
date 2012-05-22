//
//  Unit_Tests.m
//  Unit Tests
//
//  Created by Jonathan Wight on 5/22/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import "Unit_Tests.h"

#import "CObjectPath.h"

@implementation Unit_Tests

- (void)setUp
    {
    [super setUp];
    }

- (void)tearDown
    {
    [super tearDown];
    }

- (void)testSimple1
    {
    NSDictionary *theTestData = @{ @"A" : @{ @"B" : @[@"C", @"D"] } };
    CObjectPath *thePath = [[CObjectPath alloc] initWithFormat:@"A.B.#0" argumentArray:NULL];
    id theResult = [thePath evaluateObject:theTestData error:NULL];
    id theExpectedResult = @"C";
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }

- (void)testSimple2
    {
    NSDictionary *theTestData = @{ @"A" : @{ @"B" : @[@"C", @"D"] } };
    CObjectPath *thePath = [[CObjectPath alloc] initWithFormat:@"A.B.(0,1)" argumentArray:NULL];
    id theResult = [thePath evaluateObject:theTestData error:NULL];
    id theExpectedResult = @[@"C", @"D"];
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }

- (void)testSimple3
    {
    NSDictionary *theTestData = @{ @"A" : @"a", @"B": @"b", @"C": @"c" };
    CObjectPath *thePath = [[CObjectPath alloc] initWithFormat:@"(A,C)" argumentArray:NULL];
    id theResult = [thePath evaluateObject:theTestData error:NULL];
    id theExpectedResult = @[@"a", @"c"];
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }

- (void)testSimple4
    {
    NSDictionary *theTestData = @{ @"A" : @"a", @"B": @"b", @"C": @"c" };
    CObjectPath *thePath = [[CObjectPath alloc] initWithFormat:@"(A,C)" argumentArray:NULL];
    NSError *theError = NULL;
    id theResult = [thePath evaluateObject:theTestData error:&theError];
    id theExpectedResult = @[@"a", @"c"];
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }


@end
