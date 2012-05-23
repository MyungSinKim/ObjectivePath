//
//  NSScanner+Extensions.h
//  ObjectPath
//
//  Created by Jonathan Wight on 5/21/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSScanner (Extensions)

- (BOOL)scanStringDelimiteredByPrefix:(NSString *)inPrefix suffix:(NSString *)inSuffix intoString:(NSString **)outString;
- (BOOL)scanCharacterFromSet:(NSCharacterSet *)inCharacterSet intoString:(NSString **)outString;
- (BOOL)scanQuotedStringIntoString:(NSString **)outString;

@end
