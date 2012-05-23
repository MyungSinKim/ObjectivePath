//
//  CAppDelegate.m
//  GUI Test
//
//  Created by Jonathan Wight on 5/23/12.
//  Copyright (c) 2012 Jonathan Wight. All rights reserved.
//

#import "CAppDelegate.h"

#import "CBlockValueTransformer.h"
#import "CObjectivePath.h"

@interface CAppDelegate ()
@property (readwrite, nonatomic, strong) id input;
@property (readwrite, nonatomic, strong) NSString *path;
@property (readwrite, nonatomic, strong) NSString *output;
@end

#pragma mark -

@implementation CAppDelegate

+ (void)load
{
    @autoreleasepool
    {
        [NSValueTransformer setValueTransformerForName:@"JSON" block:^(id value) {
            NSString *theString = NULL;
            if (value != NULL)
            {
                NSData *theData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:NULL];
                if (theData)
                {
                    theString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
                }
            }
            return(theString);
        } reverseBlock:^(id value) {
            id theJSONObject = NULL;
            if (value != NULL)
            {
                NSData *theData = [value dataUsingEncoding:NSUTF8StringEncoding];
                theJSONObject = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingAllowFragments error:NULL];
            }
            return(theJSONObject);
        }];

        [NSValueTransformer setValueTransformerForName:@"JSON_REVERSE" invertingTransformer:[NSValueTransformer valueTransformerForName:@"JSON"]];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

- (IBAction)evaluate:(id)sender
{
    NSLog(@"> %@", self.input);

    CObjectivePath *thePath = [[CObjectivePath alloc] initWithFormat:self.path];
    self.output = [thePath evaluateObject:self.input error:NULL];
    NSLog(@"%@", self.output);

}

@end
