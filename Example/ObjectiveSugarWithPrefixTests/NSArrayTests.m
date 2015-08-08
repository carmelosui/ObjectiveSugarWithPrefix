//
//  NSArrayCategoriesTests.m
//  SampleProject
//
//  Created by Marin Usalj on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveSugar.h"
#import "Kiwi.h"

SPEC_BEGIN(ArrayAdditions)

describe(@"NSArray categories", ^{

    NSArray *sampleArray = @[@"first", @"second", @"third"];
    NSArray *oneToTen = @[ @1, @2, @3, @4, @5, @6, @7, @8, @9, @10 ];
    let(duplicate, ^{ return [NSMutableArray new]; });

    it(@"aliases -anyObject to -sample", ^{
        [[sampleArray should] receive:@selector(ojs_sample)];
        [sampleArray ojs_anyObject];
    });

    it(@"-sample returns a random object", ^{
        [[theValue([sampleArray indexOfObject:sampleArray.ojs_sample]) shouldNot] equal:theValue(NSNotFound)];
    });

    it(@"-sample of empty array returns nil", ^{
        NSArray *emptyArray = @[];
        [emptyArray.ojs_sample shouldBeNil];
    });

    context(@"Iterating using block", ^{

        it(@"iterates using -each:^", ^{
            [sampleArray ojs_each:^(id object) {
                [duplicate addObject:object];
            }];
            [[duplicate should] equal:sampleArray];
        });

        it(@"iterates using -eachWithIndex:^", ^{
            [sampleArray ojs_eachWithIndex:^(id object, NSUInteger index) {
                [[object should] equal:[sampleArray objectAtIndex:index]];
                [duplicate addObject:object];
            }];
            [[duplicate should] equal:sampleArray];
        });

        it(@"iterates using -each:^withOptions:", ^{
            [sampleArray ojs_each:^(id object) {
                [duplicate addObject:object];
            } options:NSEnumerationReverse];

            [[duplicate should] equal:[sampleArray ojs_reverse]];
        });

        it(@"iterates using -eachWithIndex:^withOptions:", ^{
            [sampleArray ojs_eachWithIndex:^(id object, NSUInteger index) {
                [[object should] equal:[sampleArray objectAtIndex:index]];
                [duplicate addObject:object];
            } options:NSEnumerationReverse];

            [[duplicate should] equal:[sampleArray ojs_reverse]];
        });

    });

    it(@"aliases -containsObject to -includes", ^{
        [[@([sampleArray ojs_includes:@"second"]) should] equal:@(YES)];
    });

    it(@"-map returns an array of objects returned by the block", ^{
        NSArray *mapped = [sampleArray ojs_map:^id(id object) {
            return [NSNumber numberWithBool:[object isEqualToString:@"second"]];
        }];

        [[mapped should] containObjects:@(NO), @(YES), @(NO), nil];
    });

    it(@"-map treats nils the same way as -valueForKeyPath:", ^{
        NSArray *users = @[@{@"name": @"Marin"},@{},@{@"name": @"Neil"}];
        [[[users ojs_map:^id(NSDictionary *user) {
            return user[@"name"];
        }] should] equal:[users valueForKeyPath:@"name"]];
    });

    it(@"-select returns an array containing all the elements of NSArray for which block is not false", ^{
        [[[oneToTen ojs_select:^BOOL(id object) {
            return [object integerValue] % 3 == 0;
        }] should] equal:@[ @3, @6, @9 ]];
    });

    it(@"-detect returns the first element in NSArray for which block is true", ^{
        [[[oneToTen ojs_detect:^BOOL(id object) {
            return [object intValue] % 3 == 0;
        }] should] equal:@3];
    });

    it(@"-detect is safe", ^{
       [[[oneToTen ojs_detect:^BOOL(id object) {
           return [object intValue] == 1232132143;
       }] should] beNil];
    });

    it(@"-find aliases detect", ^{
        [[[oneToTen ojs_find:^BOOL(id object) {
            return [object intValue] % 3 == 0;
        }] should] equal:@3];
    });

    it(@"-reject returns an array containing all the elements of NSArray for which block is false", ^{
        [[[oneToTen ojs_reject:^BOOL(id object) {
            return [object integerValue] % 3 == 0;
        }] should] equal:@[ @1, @2, @4, @5, @7, @8, @10 ]];
    });

    it(@"-flatten returns a one-dimensional array that is a recursive flattening of the array", ^{
        NSArray *multiDimensionalArray = @[ @[ @1, @2, @3 ], @[ @4, @5, @6, @[ @7, @8 ] ], @9, @10 ];
        [[[multiDimensionalArray ojs_flatten] should] equal:oneToTen];
    });

    it(@"-compact removes NSNull objects", ^{
        NSArray *arrayWithNulls = @[@1, @2, [NSNull null], @3, [NSNull null], @4];
        [[[arrayWithNulls ojs_compact] should] equal:@[@1, @2, @3, @4]];
    });

    it(@"-reduce returns a result of all the elements", ^{
        [[[sampleArray ojs_reduce:^id(NSString *accumulator, NSString *word) {
            return [accumulator stringByAppendingString:word.uppercaseString];
        }] should] equal:@"firstSECONDTHIRD"];

        [[[oneToTen ojs_reduce:^id(NSNumber *accumulator, NSNumber *numbah) {
            return @(accumulator.intValue + numbah.intValue);
        }] should] equal:@55];
    });

    it(@"-reduce:withBlock with accumulator behaves like -reduce and starts with user provided element", ^{
        [[[sampleArray ojs_reduce:@"" withBlock:^id(NSString *accumulator, NSString *word) {
            return [accumulator stringByAppendingString:word.uppercaseString];
        }] should] equal:@"FIRSTSECONDTHIRD"];

        [[[oneToTen ojs_reduce:@5 withBlock:^id(NSNumber *accumulator, NSNumber *numbah) {
          return @(accumulator.intValue + numbah.intValue);
        }] should] equal:@60];
    });
  
    it(@"-unique produces a duplicate-free array", ^{
      NSArray *arrayWithDuplicates = @[@1, @1, @"something", @"something"];
      [[[arrayWithDuplicates ojs_unique] should] equal:@[@1, @"something"]];
    });

    context(@"array subsets", ^{

        it(@"creates subset of array", ^{
            [[[sampleArray ojs_take:2] should] equal:@[ @"first", @"second" ]];
        });


        it(@"creates subset of array and shouldn't raise exeption", ^{
            [[[sampleArray ojs_take:[sampleArray count]+1] should] equal:sampleArray];
        });

        it(@"creates subset of array using block", ^{
            [[[sampleArray ojs_takeWhile:^BOOL(id object) {

                return ![object isEqualToString:@"third"];

            }] should] equal:@[ @"first", @"second" ]];
        });

    });

    context(@"array range subscripting", ^{

        it(@"returns an array containing elements at the specified range when passing an NSValue containing an NSRange", ^{
            NSValue *range = [NSValue valueWithRange: NSMakeRange(2, 5)];
            [[oneToTen[range] should] equal:@[@3, @4, @5, @6, @7]];
        });

        it(@"returns subarray with NSRange in string format", ^{
            [[oneToTen[@"2,5"] should] equal:@[@3, @4, @5, @6, @7]];
        });

        it(@"returns subarray with inclusive range", ^{
            [[oneToTen[@"2..5"] should] equal:@[@3, @4, @5, @6]];
        });

        it(@"returns subarray with inclusive range but excludes the end value", ^{
            [[oneToTen[@"2...5"] should] equal:@[@3, @4, @5]];
        });

        it(@"returns subarray with inclusive range up to the end element", ^{
            [[oneToTen[@"2..-1"] should] equal:@[@3, @4, @5, @6, @7, @8, @9, @10]];
        });

        it(@"returns subarray with inclusive range up to the element before end element", ^{
            [[oneToTen[@"2...-1"] should] equal:@[@3, @4, @5, @6, @7, @8, @9]];
        });

        it(@"returns an empty array when passing an invalid or empty range", ^{
            [[oneToTen[@"notarange"] should] equal:@[]];
        });

        it(@"throws an invalid argument exception when passing anything other than an NSString or NSValue", ^{
            [[theBlock(^{
                [oneToTen[[[NSSet alloc] initWithArray:@[@1, @2]]] description];
            }) should] raiseWithName:NSInvalidArgumentException reason:@"expected NSString or NSValue argument, got __NSSetI instead"];
        });

        it(@"shouldn't break existing indexed subscripting", ^{
            [[oneToTen[1] should] equal:@2];
        });
    });

    context(@"join elements", ^{

        it(@"join the array with elements ", ^{
            [[[oneToTen ojs_join] should] equal:@"12345678910"];
        });

        it(@"join the array with elements separated by a dash", ^{
            [[[sampleArray ojs_join:@"-"] should] equal:@"first-second-third"];
        });

    });

    context(@"reverse elements", ^{
        it(@"reverses the elements in the array", ^{
            [[[oneToTen ojs_reverse] should] equal:@[@10, @9, @8, @7, @6, @5, @4, @3, @2, @1]];
        });
    });

    context(@"sorting", ^{

        it(@"-sort aliases -sortUsingComparator:", ^{
            [[[@[ @4, @1, @3, @2 ] ojs_sort] should] equal:@[ @1, @2, @3, @4 ]];
        });

        it(@"-sortsortBy sorts using the default comparator on the given key:", ^{
            NSDictionary *dict_1 = @{@"name": @"1"};
            NSDictionary *dict_2 = @{@"name": @"2"};
            NSDictionary *dict_3 = @{@"name": @"3"};
            NSDictionary *dict_4 = @{@"name": @"3"};
            [[[@[ dict_4, dict_1, dict_3, dict_2 ] ojs_sortBy:@"name"] should] equal:@[ dict_1, dict_2, dict_3, dict_4 ]];
        });

    });

});


describe(@"Set operations", ^{

    NSArray *a = @[ @1, @2 ];
    NSArray *b = @[ @2, @3 ];

    it(@"return the elements common to both arrays ", ^{
        [[[a ojs_intersectionWithArray:b] should] equal:@[ @2 ]];
    });

    it(@"combine the two arrays, removing duplicate elements", ^{
        [[[a ojs_unionWithArray:b] should] equal:@[ @1, @2, @3 ]];
    });

    it(@"return the elements in a that are not in b", ^{
        [[[a ojs_relativeComplement:b] should] equal:@[ @1 ]];
    });

    it(@"return the elements in b that are not in a", ^{
        [[[b ojs_relativeComplement:a] should] equal:@[ @3 ]];
    });

    it(@"return the elements unique to both arrays", ^{
        [[[a ojs_symmetricDifference:b] should] equal:@[ @1, @3 ]];
    });
});


SPEC_END


