//
//  CBlockValueTransformer.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/10/11.
//  Copyright 2011 Jonathan Wight. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY JONATHAN WIGHT ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JONATHAN WIGHT OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of 2011 Jonathan Wight.

#import "CBlockValueTransformer.h"

@interface CBlockValueTransformer ()
@property (readwrite, nonatomic, copy) id (^block)(id);
@property (readwrite, nonatomic, copy) id (^reverseBlock)(id);
@end

@implementation CBlockValueTransformer

@synthesize block;
@synthesize reverseBlock;

- (id)initWithBlock:(id (^)(id))inBlock reverseBlock:(id (^)(id))inReverseBlock;
    {
    if ((self = [super init]) != NULL)
        {
        block = inBlock;
        reverseBlock = inReverseBlock;
        }
    return self;
    }

- (id)initWithBlock:(id (^)(id))inBlock;
    {
    if ((self = [self initWithBlock:inBlock reverseBlock:NULL]) != NULL)
        {
        }
    return self;
    }

- (id)transformedValue:(id)value
    {
    return(self.block(value));
    }

- (id)reverseTransformedValue:(id)value
    {
    return(self.reverseBlock(value));
    }

@end

#pragma mark -

@implementation NSValueTransformer (NSValueTransformer_BlockExtensions)

+ (void)setValueTransformerForName:(NSString *)inName block:(id (^)(id))inBlock;
    {
    CBlockValueTransformer *theTransformer = [[CBlockValueTransformer alloc] initWithBlock:inBlock];
    [self setValueTransformer:theTransformer forName:inName];
    }

+ (void)setValueTransformerForName:(NSString *)inName block:(id (^)(id))inBlock reverseBlock:(id (^)(id))inReverseBlock
    {
    CBlockValueTransformer *theTransformer = [[CBlockValueTransformer alloc] initWithBlock:inBlock reverseBlock:inReverseBlock];
    [self setValueTransformer:theTransformer forName:inName];
    }

+ (void)setValueTransformerForName:(NSString *)inName invertingTransformer:(NSValueTransformer *)inValueTransformer;
    {
    [self setValueTransformerForName:inName block:^(id value) { return([inValueTransformer reverseTransformedValue:value]); } reverseBlock:^(id value) { return([inValueTransformer transformedValue:value]); }];
    }

@end

