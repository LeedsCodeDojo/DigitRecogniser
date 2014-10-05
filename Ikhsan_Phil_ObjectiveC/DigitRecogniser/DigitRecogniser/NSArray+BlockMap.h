//
//  NSArray+BlockMap.h
//  DigitRecogniser
//
//  Created by Ikhsan Assaat on 10/1/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BlockMap)

- (NSArray*)mapWithBlock:(id (^)(id obj, NSUInteger idx))mapBlock;

@end
