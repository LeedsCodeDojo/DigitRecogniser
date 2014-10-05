//
//  NSArray+BlockMap.m
//  DigitRecogniser
//
//  Created by Ikhsan Assaat on 10/1/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import "NSArray+BlockMap.h"

@implementation NSArray (BlockMap)

- (NSArray*)mapWithBlock:(id (^)(id obj, NSUInteger idx))mapBlock {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id currentObject, NSUInteger index, BOOL *stop) {
        id mappedCurrentObject = mapBlock(currentObject, index);
        if (mappedCurrentObject)
        {
            [result addObject:mappedCurrentObject];
        }
    }];
    
    return result;
}

@end
