//
//  NSScanner+Extensions.m
//  ObjectPath
//
//  Created by Jonathan Wight on 5/21/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import "NSScanner+Extensions.h"

@implementation NSScanner (Extensions)

- (BOOL)scanStringDelimiteredByPrefix:(NSString *)inPrefix suffix:(NSString *)inSuffix intoString:(NSString **)outString
    {
    const NSUInteger theCurrentLocation = self.scanLocation;
    if ([self scanString:inPrefix intoString:NULL] == NO)
        {
        goto error;
        }
    if ([self scanUpToString:inSuffix intoString:outString] == NO)
        {
        goto error;
        }

    if ([self scanString:inSuffix intoString:NULL] == NO)
        {
        goto error;
        }

    return(YES);

    error:
        self.scanLocation = theCurrentLocation;
        return(NO);
    }

- (BOOL)scanCharacterFromSet:(NSCharacterSet *)inCharacterSet intoString:(NSString **)outString;
    {
    unichar theCharacter = [self.string characterAtIndex:self.scanLocation];
    if ([inCharacterSet characterIsMember:theCharacter] == YES)
        {

        self.scanLocation += 1;
        if (outString != NULL)
            {
            *outString = [[NSString alloc] initWithCharacters:&theCharacter length:1];
            }
        return(YES);
        }
    else
        {
        return(NO);
        }
    }

- (BOOL)scanQuotedStringIntoString:(NSString **)outString;
    {
    // TODO -- escaped characters.

    NSUInteger theCurrentLocation = self.scanLocation;
    NSString *theQuoteCharacter = NULL;

    if ([self scanCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"\'"] intoString:&theQuoteCharacter] == NO)
        {
        goto error;
        }
    if ([self scanUpToString:theQuoteCharacter intoString:outString] == NO)
        {
        goto error;
        }

    if ([self scanString:theQuoteCharacter intoString:NULL] == NO)
        {
        goto error;
        }

    error:
        self.scanLocation = theCurrentLocation;
        return(NO);
    }

@end
