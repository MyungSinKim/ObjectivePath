//
//  CObjectPath.m
//  ObjectPath
//
//  Created by Jonathan Wight on 5/21/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import "CObjectPath.h"

#import "NSScanner+Extensions.h"
#import "NSIndexSet+Extensions.h"

typedef id (^Evaluator)(id value);

@interface CObjectPath ()
@property (readwrite, nonatomic, strong) NSString *format;
@property (readwrite, nonatomic, strong) NSArray *arguments;
@property (readwrite, nonatomic, strong) NSArray *components;
@end

#pragma mark -

@implementation CObjectPath

+ (CObjectPath *)objectPathWithFormat:(NSString *)format argumentArray:(NSArray *)arguments
    {
    return([[self alloc] initWithFormat:format argumentArray:arguments]);
    }

//+ (CObjectPath *)objectPathWithFormat:(NSString *)format, ...
//    {
//    }

//+ (CObjectPath *)objectPathWithFormat:(NSString *)format arguments:(va_list)argList
//    {
//    }

#pragma mark -

- (id)initWithFormat:(NSString *)format argumentArray:(NSArray *)arguments
    {
    if ((self = [super init]) != NULL)
        {
        _format = format;
        _arguments = arguments;
        }
    return self;
    }

#pragma mark -

- (id)evaluateWithObject:(id)object error:(NSError **)outError
    {
    [self compile:NULL];

    return(NULL);
    }


#pragma mark - 

- (BOOL)compile:(NSError **)outError
    {
    NSUInteger theArgumentIndex = 0;
    NSMutableArray *theComponents = [NSMutableArray array];

    NSScanner *theScanner = [NSScanner scannerWithString:self.format];

    NSString *theString = NULL;

    while (theScanner.isAtEnd == NO)
        {
        if ([theScanner scanString:@"%@" intoString:NULL] == YES)
            {
            NSString *theKey = [self.arguments objectAtIndex:theArgumentIndex++];
            [theComponents addObject:@[@"key", theKey]];
            }
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
            NSSet *theKeys = [NSSet setWithArray:[theString componentsSeparatedByString:@","]];
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

    self.components = theComponents;


    return(YES);
    }

- (id)evaluateObject:(id)inObject
    {
    id theCurrentObject = inObject;

    [self compile:NULL];

    for (NSArray *theComponent in self.components)
        {
        Evaluator theBlock = [self blockForObject:theCurrentObject component:theComponent];
        theCurrentObject = theBlock(theCurrentObject);
        }
    return(theCurrentObject);

    }

- (Evaluator)blockForObject:(id)inObject component:(NSArray *)inComponent
    {
    NSArray *theBlockRecipes = @[
        @[ @"index", [NSArray class], [^(id component, id value) { return([value objectAtIndex:[component integerValue]]); } copy]],
        @[ @"key", [NSDictionary class], [^(id component, id value) { return([value objectForKey:component]); } copy]],
        @[ @"set", [NSArray class], [^(id component, id value) { return([value objectsAtIndexes:[NSIndexSet indexSetWithIndexesInSet:component]]); } copy]],
        @[ @"predicate", [NSArray class], [^(id component, id value) { return([value filteredArrayUsingPredicate:component]); } copy]],
        @[ @"key", [NSNull null], [^(id component, id value) { return([value filteredArrayUsingPredicate:component]); } copy]],
        ];

    NSString *theComponentType = inComponent[0];
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

    Evaluator theEvaluator = ^(id value)
        {
        return(theBlock(inComponent[1], value));
        };

    return(theEvaluator);
    }

#pragma mark -

- (NSArray *)pathComponents
    {
    // This isn't good enough but will do for now.
    return([self.format componentsSeparatedByString:@"."]);
    }


@end
