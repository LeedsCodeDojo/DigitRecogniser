//
//  DigitRecord.m
//  DigitRecogniser
//
//  Created by Ikhsan Assaat on 10/1/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import "DigitRecord.h"
#import "NSArray+BlockMap.h"

@implementation DigitRecord

- (instancetype)initWithLabel:(NSNumber *)label pixels:(NSArray *)pixels {
    self = [super init];
    if (self) {
        self.label = label;
        self.pixels = pixels;
    }
    return self;
}

#pragma mark -

- (NSString *)description {
    NSUInteger size = ceil(sqrt(self.pixels.count));
    
    __block NSString *visuals = @"\n";
    visuals = [visuals stringByAppendingFormat:@"[ %@ ]\n", self.label];
    
    NSArray *dt = @[@" ", @".", @"\"", @"*", @":", @"%%", @"#", @"X"];
    
    [self.pixels enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        if (idx % size == 0) {
            NSString *margin = (idx == 0)? @"|" : @"\n|";
            visuals = [visuals stringByAppendingString:margin];
        }
        NSString *character = dt[ number.integerValue % dt.count ];
        visuals = [visuals stringByAppendingFormat:@"%@%@", character, character];
    }];
    
    return visuals;
}

- (void)draw {
    NSLog(@"%@", self);
}

#pragma mark -

- (DigitRecord *)classifyWithTrainingData:(NSArray *)trainingData {
    NSInteger minimumDistance = INT_MAX;
    DigitRecord *nearestDigit = nil;
    
    for (DigitRecord *knownDigit in trainingData) {
        NSInteger distance = [self calculateDistanceFromKnownDigit:knownDigit];
        if (distance < minimumDistance) {
            minimumDistance = distance;
            nearestDigit = knownDigit;
        }
    }
    
    return nearestDigit;
}

- (NSInteger)classifyWithData:(NSArray *)trainingData {
    NSInteger k = 1;
    
    NSMutableArray *neighbours = [[trainingData mapWithBlock:^id(DigitRecord *knownDigit, NSUInteger idx) {
        return @[knownDigit.label, @([self calculateDistanceFromKnownDigit:knownDigit])]; // label | distance
    }] mutableCopy];
    
    // sort
    [neighbours sortUsingComparator:^NSComparisonResult(NSArray *distance1, NSArray *distance2) {
        if ([distance1[1] integerValue] > [distance2[1] integerValue]) return NSOrderedDescending;
        return NSOrderedAscending;
    }];
    
    // voting system
    NSMutableArray *votes = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) { [votes addObject:@0]; }
    for (NSArray *labelAndDistance in [neighbours subarrayWithRange:NSMakeRange(0, k)]) {
        // increment value for nearest
        NSInteger index = [labelAndDistance[0] integerValue];
        NSInteger weight = 10 - index;
        votes[index] = @([votes[index] integerValue] + weight);
    }
    
    // pick the largest point
    __block NSInteger result = INT_MAX;
    __block NSInteger maximumVote = -1;
    
    [votes enumerateObjectsUsingBlock:^(NSNumber *totalVotes, NSUInteger idx, BOOL *stop) {
        if (totalVotes.integerValue > maximumVote) {
            maximumVote = totalVotes.integerValue;
            result = idx;
        }
    }];
    
    return result;
}

#pragma mark - Distance calculation

- (NSInteger)calculateDistanceUsingWhitespaces:(DigitRecord *)digit {
    __block NSInteger counter1 = 0;
    __block NSInteger counter2 = 0;
    
    [self.pixels enumerateObjectsUsingBlock:^(NSNumber *pixel1, NSUInteger idx, BOOL *stop) {
        NSNumber *pixel2 = digit.pixels[idx];
        
        if (pixel1.integerValue == 0) counter1++;
        if (pixel2.integerValue == 0) counter2++;
    }];
    
    return labs(counter1 - counter2);
}

- (NSInteger)calculateDistanceUsingSumOfDifferences:(DigitRecord *)digit {
    __block NSInteger distance = 0;
    
    [self.pixels enumerateObjectsUsingBlock:^(NSNumber *pixel1, NSUInteger idx, BOOL *stop) {
        NSNumber *pixel2 = digit.pixels[idx];
        distance += labs(pixel1.integerValue - pixel2.integerValue);
    }];
    
    return distance;
}

- (NSInteger)calculateDistanceUsingEuclidianDistance:(DigitRecord *)digit power:(NSInteger)power {
    __block NSInteger distance = 0;
    
    [self.pixels enumerateObjectsUsingBlock:^(NSNumber *pixel1, NSUInteger idx, BOOL *stop) {
        NSNumber *pixel2 = digit.pixels[idx];
        distance += pow(labs(pixel1.integerValue - pixel2.integerValue), power);
    }];
    
    return distance;
}

- (NSInteger)calculateDistanceFromKnownDigit:(DigitRecord *)digit {
    //  -- Check for whitespaces --
    // result : 18.75% (125.62 s)
//    return [self calculateDistanceUsingWhitespaces:digit];
    
    // -- Use sums of each pixel's differences --
    // result : 88.75% (90.38 s)
//    return [self calculateDistanceUsingSumOfDifferences:digit];
    
    // -- User euclidian distance, pow 2 --
    // k = 1 | 90.25% (106.87 s)
    // k = 2 | 89.00% (106.27 s)
    // k = 3 | 86.75% (109.14 s)
    return [self calculateDistanceUsingEuclidianDistance:digit power:2];
    
    // -- User euclidian distance, pow 3 --
    // result| 90.25% (111.04 s)
    // k = 2 | 90.00% (115.29 s)
    // k = 3 | 87.50% (115.97 s)
//    return [self calculateDistanceUsingEuclidianDistance:digit power:3];
}


@end
