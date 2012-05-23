//
//  Unit_Tests.m
//  Unit Tests
//
//  Created by Jonathan Wight on 5/22/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import "Unit_Tests.h"

#import "CObjectivePath.h"

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
    CObjectivePath *thePath = [[CObjectivePath alloc] initWithFormat:@"A.B.#0"];
    id theTestData = @{ @"A" : @{ @"B" : @[@"C", @"D"] } };
    id theExpectedResult = @"C";
    NSError *theError = NULL;
    id theResult = [thePath evaluateObject:theTestData error:&theError];
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }

- (void)testSimple2
    {
    CObjectivePath *thePath = [[CObjectivePath alloc] initWithFormat:@"A.B.(0,1)"];
    id theTestData = @{ @"A" : @{ @"B" : @[@"C", @"D"] } };
    id theExpectedResult = @[@"C", @"D"];
    NSError *theError = NULL;
    id theResult = [thePath evaluateObject:theTestData error:&theError];
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }

- (void)testSimple3
    {
    CObjectivePath *thePath = [[CObjectivePath alloc] initWithFormat:@"(A,C)"];
    id theTestData = @{ @"A" : @"a", @"B": @"b", @"C": @"c" };
    id theExpectedResult = @[@"a", @"c"];
    NSError *theError = NULL;
    id theResult = [thePath evaluateObject:theTestData error:&theError];
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }

- (void)testSimple4
    {
    CObjectivePath *thePath = [[CObjectivePath alloc] initWithFormat:@"(A,C)"];
    id theTestData = @{ @"A" : @"a", @"B": @"b", @"C": @"c" };
    id theExpectedResult = @[@"a", @"c"];
    NSError *theError = NULL;
    id theResult = [thePath evaluateObject:theTestData error:&theError];
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }

- (void)testSimple5
    {
    CObjectivePath *thePath = [[CObjectivePath alloc] initWithFormat:@"{ self LIKE[cd] 'a' }"];
    id theTestData = @[ @"A", @"a", @"B", @"b", @"C", @"c" ];
    NSError *theError = NULL;
    id theResult = [thePath evaluateObject:theTestData error:&theError];
    id theExpectedResult = @[@"A", @"a"];
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }

- (void)testSimple6
    {
    CObjectivePath *thePath = [[CObjectivePath alloc] initWithFormat:@"%@", @"A"];
    id theTestData = @{ @"A" : @"a", @"B": @"b", @"C": @"c" };
    NSError *theError = NULL;
    id theResult = [thePath evaluateObject:theTestData error:&theError];
    id theExpectedResult = @"a";
    STAssertEqualObjects(theResult, theExpectedResult, @"TODO_DESCRIPTION");
    }



@end
