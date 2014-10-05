//
//  DigitRecord.h
//  DigitRecogniser
//
//  Created by Ikhsan Assaat on 10/1/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DigitRecord : NSObject

@property (nonatomic, strong) NSNumber *label;
@property (nonatomic, strong) NSArray *pixels;

- (instancetype)initWithLabel:(NSNumber *)label pixels:(NSArray *)pixels;
- (void)draw;

- (DigitRecord *)classifyWithTrainingData:(NSArray *)trainingData;
- (NSInteger)classifyWithData:(NSArray *)trainingData;
- (NSInteger)calculateDistanceFromKnownDigit:(DigitRecord *)digit;

@end
