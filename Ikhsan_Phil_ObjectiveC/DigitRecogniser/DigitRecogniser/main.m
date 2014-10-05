//
//  main.m
//  DigitRecogniser
//
//  Created by Ikhsan Assaat on 10/1/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+BlockMap.h"
#import "DigitRecord.h"

void execute() {
    
    /**
     * Framework code for tutorial creating a digit classifier using K-Nearest-Neighbours.
     * Ported to Objective-C from Grant Crofton's C# version by Ikhsan Assaat - twitter @ixnixnixn
     */
    
    // Follow the steps below to implement your digit classifier.
    // If you need a bit of help, check out the hints.
    // If you need even more, have a peek at the example solutions.  (But don't let anyone see you!)
    
    // The first few steps have been implemented for you, so you can get onto the interesting part!
    
    /******* 0. GETTING TO KNOW YOUR DATA *******/
    
    // First let's have a look at "trainingsample.csv". Understand the format,
    // so you know what you're working with.
    // Each line has the digit (0-9), then 784 numbers representing pixels, with
    // greyscale values from 0-255
    
    /******* 1. READING THE DATA *******/
    
    // First let's read the contents of "trainingsample.csv" into an array, one element per line
    
    /** MAKE SURE TO CHANGE YOUR PROJ DIRECTORY! **/
    NSString *projectDirectory = @"/Users/ikhsan/Documents/Open Source/DigitRecogniser/Ikhsan_Phil_ObjectiveC";
    NSString *path = [projectDirectory stringByAppendingPathComponent:@"trainingsample.csv"];
    
    NSString *dataInString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *trainingDataString = [dataInString componentsSeparatedByString:@"\n"];
    
    /******* 2. CLEANING UP HEADERS *******/
    
    // Did you notice that the file has a header? We want to get rid of it.
    NSArray *dataWithoutHeader = [trainingDataString subarrayWithRange:NSMakeRange(1, trainingDataString.count - 1)];
    
    /******* 3. EXTRACTING COLUMNS *******/
    
    // Each line of the file is a comma-separated list of numbers.
    // Break each line of the file into an array of strings.
    
    NSArray *dataValues = [dataWithoutHeader mapWithBlock:^id(NSString *value, NSUInteger idx) {
        return [value componentsSeparatedByString:@","];
    }];
    
    /******* 4. CONVERTING FROM STRINGS TO INTS *******/
    
    // Now that we have an array containing arrays of strings,
    // and the headers are gone, we need to transform it into an array of arrays of integers.
    NSArray *dataNumbers = [dataValues mapWithBlock:^id(NSArray *line, NSUInteger idx) {
        NSArray *lineNumbers = [line mapWithBlock:^id(NSString *value, NSUInteger idx) {
            return @([value integerValue]);
        }];
        return lineNumbers;
    }];
    
    /******* 5. CONVERTING ARRAYS TO CLASSES *******/
    
    // Rather than dealing with a raw array of ints,
    // for convenience let's store these into an array of something a bit more structured.
    // A class called 'DigitRecord' has been started for your convenience - let's use that.
    NSArray *digitRecords = [dataNumbers mapWithBlock:^id(NSArray *line, NSUInteger idx) {
        NSNumber *label = line[0];
        NSArray *pixels = [line subarrayWithRange:NSMakeRange(1, line.count - 1)];
        DigitRecord *digitRecord = [[DigitRecord alloc] initWithLabel:label pixels:pixels];
        return digitRecord;
    }];
    
    /******* 6. LET'S SEE SOME DIGITS! *******/
    
    // Now we have things structured sensibly, if you want, you can have a look at some digits.
    // The digit class can draw on the consolse, which can be called like so:
    // [someDigitRecord draw];
    
    DigitRecord *digit = digitRecords[0];
    [digit draw];
    
    /******* 7. TRAINING vs VALIDATION DATA *******/
    
    // How will we see if our algorithm works?  We need to take our known character data and split
    // it into 'training data' and the 'validation set'.
    // Let's keep say 1600 records for training and 400 for validation.
    
    NSArray *trainingData = [digitRecords subarrayWithRange:NSMakeRange(0, 1600)];
    NSArray *validationData = [digitRecords subarrayWithRange:NSMakeRange(1600, 400)];
    
    /******* 8. COMPUTING DISTANCES *******/
    
    // We need to compute the distance between two images, so we can see what the 'closest' ones are.
    // This is implemented in DigitRecords's calculateDistanceFromKnownDigit:
    
    /******* 9. WRITING THE CLASSIFIER FUNCTION *******/
    
    // We are now ready to write the classifier!
    // This is implemented in DigitRecord's classifyWithTrainingData:
    
    /******* 10. SEE THE CLASSIFIER IN ACTION *******/
    
    // Now that we have a classifier, let's see it in action.
    // For each example in the validation set, we can use the classifier to predict
    // the digit.  Let's take, say, the first 20 classifications and see if it seems to be working
    // by writing the actual and predicted values to the console.
    
    NSArray *first20ValidationData = [validationData subarrayWithRange:NSMakeRange(0, 20)];
    NSLog(@"-- First 20 digits to Validate --");
    for (DigitRecord *digit in first20ValidationData) {
        NSLog(@"actual %@ -- %lu Prediction ", digit.label, [digit classifyWithData:trainingData]);
    }
    
    /******* 11. EVALUATING THE MODEL AGAINST VALIDATION DATA *******/
    
    // Let's judge with a little more accuracy how good our classifier is.
    // Let's classify all of the validation records, and work out the % correctly predicted.
    
    NSInteger matched = 0;
    NSInteger tested = 0;
    
    NSDate *start = [NSDate date];
    for (DigitRecord *testDigit in validationData) {
        if (testDigit.label.integerValue == [testDigit classifyWithData:trainingData]) {
            printf(".");
            matched++;
        }
        tested++;
    }
    printf("\n");
    
    NSDate *finish = [NSDate date];
    NSTimeInterval executionTime = [finish timeIntervalSinceDate:start];
    
    double accuracy = ((double)matched / (double)tested) * 100;
    NSLog(@"result : %.2f%% (%.2f s)", accuracy, executionTime);
    
    // If this is going too slowly (e.g. no results within a couple of minutes),
    // you might want to try to make your distance calculation faster
    
    // CONGRATULATIONS!  Hopefully, you have a working digit classifier.
    // Want to make it better?  See some suggestions below..
    
    /******* 12. NEXT STEPS *******/
    // Once you have something working, there are many things you can try to do:
    // - Try higher values of k (more neighbours)
    // - Improve the distance calculation (
    //     compare each pixel,
    //     euclidian distance (distance of each pixel squared),
    //     distance of each pixel to other powers)
    // - Try other things to improve the score (e.g.
    //     blur the images,
    //     downsize the images)
    // - Make it faster (you can use a StopWatch to see how long things take)
    // - Submit your classifier to Kaggle (http://www.kaggle.com/competitions)
    
    // There are many more hours of machine learning fun to be had, even for this simple problem.
    // Enjoy!
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        execute();
    }
    return 0;
}