//
//  CObjectivePath.m
//  ObjectPath
//
//  Created by Jonathan Wight on 5/21/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import "CObjectivePath.h"

#import "NSScanner+Extensions.h"
#import "NSIndexSet+Extensions.h"

NSString *const kObjectivePathErrorDomain = @"ObjectPathErrorDomain";

typedef id (^Evaluator)(id value);

@interface CObjectivePath ()
@property (readwrite, nonatomic, strong) NSString *format;
@property (readwrite, nonatomic, strong) NSArray *arguments;
@property (readwrite, nonatomic, strong) NSArray *components;
@end

#pragma mark -

@implementation CObjectivePath

- (id)initWithFormat:(NSString *)format argumentArray:(NSArray *)arguments
    {
    if ((self = [super init]) != NULL)
        {
        _format = format;
        _arguments = arguments;
        }
    return self;
    }

- (id)initWithFormat:(NSString *)format, ...
    {
    va_list theArguments;
    va_start(theArguments, format);

    if ((self = [self initWithFormat:format arguments:theArguments]) != NULL)
        {
        }

    va_end(theArguments);

    return self;
    }

- (id)initWithFormat:(NSString *)format arguments:(va_list)argList
    {
    NSArray *theComponents = [[self class] componentsForPath:format error:NULL];
    __block NSInteger theArgumentCount = 0;
    [theComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectAtIndex:0] isEqualToString:@"argument"])
            {
            ++theArgumentCount;
            }
        }];

    NSMutableArray *theArguments = [NSMutableArray array];
    for (NSUInteger N = 0; N != theArgumentCount; ++N)
        {
        id theArgument = va_arg(argList, id);
        [theArguments addObject:theArgument];
        }

    if ((self = [self initWithFormat:format argumentArray:theArguments]) != NULL)
        {
        _components = theComponents;
        }
    return(self);
    }

#pragma mark -

+ (NSArray *)componentsForPath:(NSString *)inPath error:(NSError **)outError
    {
    NSUInteger theArgumentIndex = 0;
    NSMutableArray *theComponents = [NSMutableArray array];

    NSScanner *theScanner = [NSScanner scannerWithString:inPath];

    NSString *theString = NULL;

    while (theScanner.isAtEnd == NO)
        {
        if ([theScanner scanString:@"%@" intoString:NULL] == YES)
            {
            [theComponents addObject:@[@"argument", [NSNumber numberWithInteger:theArgumentIndex++]]];
            }
//        else if ([theScanner scanString:@"%^" intoString:NULL] == YES)
//            {
//            [theComponents addObject:@[@"argument", [NSNumber numberWithInteger:theArgumentIndex++]]];
//            }
        else if ([theScanner scanString:@"%%" intoString:NULL] == YES)
            {
            [theComponents addObject:@[@"key", @"%"]];
            }
        else if ([theScanner scanStringDelimiteredByPrefix:@"{" suffix:@"}" intoString:&theString] == YES)
            {
            NSPredicate *thePredicate = [NSPredicate predicateWithFormat:theString];
            [theComponents addObject:@[@"predicate", thePredicate]];
            }
        else if ([theScanner scanStringDelimiteredByPrefix:@"(" suffix:@")" intoString:&theString] == YES)
            {
            NSArray *theKeys = [theString componentsSeparatedByString:@","];
            [theComponents addObject:@[@"set", theKeys]];
            }
        else if ([theScanner scanQuotedStringIntoString:&theString] == YES)
            {
            [theComponents addObject:@[@"key", theString]];
            }
        else if ([theScanner scanString:@"#" intoString:NULL])
            {
            NSInteger theIndex = 0;
            if ([theScanner scanInteger:&theIndex] == NO)
                {
                return(NO);
                }
            [theComponents addObject:@[@"index", [NSNumber numberWithInteger:theIndex]]];
            }
        else if ([theScanner scanUpToString:@"." intoString:&theString] == YES)
            {
            [theComponents addObject:@[@"key", theString]];
            }

        [theScanner scanString:@"." intoString:NULL];
        }

    return(theComponents);
    }

- (BOOL)compile:(NSError **)outError
    {
    if (self.components == NULL)
        {
        self.components = [[self class] componentsForPath:self.format error:outError];
        }
    return(YES);
    }

- (id)evaluateObject:(id)inObject error:(NSError **)outError
    {
    id theCurrentObject = inObject;

    if ([self compile:outError] == NO)
        {
        return(NULL);
        }

    for (NSArray *theComponent in self.components)
        {
        Evaluator theBlock = [self blockForObject:theCurrentObject component:theComponent error:outError];
        if (theBlock == NULL)
            {
            return(NULL);
            }
        theCurrentObject = theBlock(theCurrentObject);
        }
    return(theCurrentObject);
    }

- (Evaluator)blockForObject:(id)inObject component:(NSArray *)inComponent error:(NSError **)outError
    {
    NSArray *theBlockRecipes = @[
        @[ @"index", [NSArray class], ^(id component, id value) { return([value objectAtIndex:[component integerValue]]); }],
        @[ @"key", [NSArray class], ^(id component, id value) { return([value objectAtIndex:[component integerValue]]); }],
        @[ @"key", [NSDictionary class], ^(id component, id value) { return([value objectForKey:component]); }],
        @[ @"key", [NSNull null], ^(id component, id value) { return([value filteredArrayUsingPredicate:component]); }],
        @[ @"set", [NSArray class], ^(id component, id value) { return([value objectsAtIndexes:[NSIndexSet indexSetWithIndexesInSet:[NSSet setWithArray:component]]]); }],
        @[ @"set", [NSDictionary class], ^(id component, id value) { return([value objectsForKeys:component notFoundMarker:[NSNull null]]); }],
        @[ @"predicate", [NSArray class], ^(id component, id value) { return([value filteredArrayUsingPredicate:component]); }],
        ];

    NSString *theComponentType = inComponent[0];
    id theComponentValue = inComponent[1];

    if ([theComponentType isEqualToString:@"argument"] == YES)
        {
        theComponentValue = [self.arguments objectAtIndex:[theComponentValue integerValue]];

        if ([theComponentValue isKindOfClass:NSClassFromString(@"NSBlock")] == YES)
            {
            theComponentType = @"block";
            }
        else if ([theComponentValue isKindOfClass:[NSPredicate class]] == YES)
            {
            theComponentType = @"predicate";
            }
        else
            {
            theComponentType = @"key";
            }
        }

    id (^theBlock)(id component, id value) = NULL;
    for (NSArray *theRecipe in theBlockRecipes)
        {
        NSString *theType = theRecipe[0];
        id theClass = theRecipe[1];
        if ([theComponentType isEqualToString:theType] && (theClass == [NSNull null] || [inObject isKindOfClass:theClass]))
            {
            theBlock = theRecipe[2];
            break;
            }
        }

    if (theBlock == NULL)
        {
        if (outError != NULL)
            {
            *outError = [NSError errorWithDomain:kObjectivePathErrorDomain code:kObjectivePathErrorCode_Unknown userInfo:NULL];
            }
        return(NULL);
        }

    Evaluator theEvaluator = ^(id value)
        {
        return(theBlock(theComponentValue, value));
        };

    return(theEvaluator);
    }

@end
