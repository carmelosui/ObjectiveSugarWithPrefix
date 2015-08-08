//
//  NSSetTests.m
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import "Kiwi.h"
#import "ObjectiveSugar.h"

SPEC_BEGIN(SetAdditions)

describe(@"Iterators", ^{


    NSSet *sampleSet = [NSSet setWithArray:@[@"first", @"second", @"third"]];

    context(@"Iterating using block", ^{

        it(@"iterates using -each:^", ^{
            NSMutableArray *duplicate = [sampleSet.allObjects mutableCopy];

            [sampleSet ojs_each:^(id object) {
                [[duplicate should] contain:object];
                [duplicate removeObject:object];
            }];
            [[duplicate should] beEmpty];
        });

        it(@"iterates using -eachWithIndex:^", ^{
            NSMutableArray *duplicate = [sampleSet.allObjects mutableCopy];

            [sampleSet ojs_eachWithIndex:^(id object, NSUInteger index) {
                [[object should] equal:sampleSet.allObjects[index]];
                [duplicate removeObject:object];
            }];
            [[duplicate should] beEmpty];
        });

    });

    context(@"first, last, sample", ^{

        it(@"-first returns object at index 0", ^{
            [[sampleSet.ojs_firstObject should] equal:sampleSet.allObjects[0]];
        });

        it(@"-first does not crash if there's no objects in set", ^{
            KWBlock *block = [[KWBlock alloc] initWithBlock:^{
                NSSet *empty = [NSSet set];
                [empty.ojs_firstObject description];
            }];
            [[block shouldNot] raise];
        });

        it(@"-last returns the last object", ^{
            [[sampleSet.ojs_lastObject should] equal:sampleSet.allObjects.lastObject];
        });

        it(@"-sample returns a random object", ^{
            [[sampleSet member:sampleSet.ojs_sample] shouldNotBeNil];
        });

        it(@"-sample of empty set returns nil", ^{
            NSSet *emptySet = [NSSet set];
            [emptySet.ojs_sample shouldBeNil];
        });
    });

    context(@"modifications", ^{

        NSSet *cars = [NSSet setWithArray:@[@"Testarossa", @"F50", @"F458 Italia"]];
        let(items, ^id{
            return @[@{ @"value": @4 }, @{ @"value": @5 }, @{ @"value": @9 }];
        });

        it(@"-map returns an array of objects returned by the block", ^{
            NSArray *mapped = [sampleSet ojs_map:^id(id object) {
                return @([object isEqualToString:@"third"]);
            }];
            [[mapped should] containObjects:@NO, @YES, @NO, nil];
        });

        it(@"-map treats nils the same way as -valueForKeyPath:", ^{
            NSSet *users = [NSSet setWithArray:@[@{@"name": @"Marin"}, @{@"fake": @"value"}, @{@"name": @"Neil"}]];
            NSArray *mappedUsers = [users ojs_map:^id(NSDictionary *user) { return user[@"name"]; }];

            [[mappedUsers.ojs_sort should] equal:[[users valueForKeyPath:@"name"] allObjects].ojs_sort];
            [[mappedUsers should] haveCountOf:2];
            [[mappedUsers should] containObjects:@"Marin", @"Neil", nil];
        });

        it(@"-select returns an array containing all the elements of NSArray for which block is not false", ^{
            [[[cars ojs_select:^BOOL(NSString *car) {
                return [car isEqualToString:@"F50"];
            }] should] equal:@[ @"F50" ]];
        });

        it(@"-reject returns an array containing all the elements of NSArray for which block is false", ^{
            [[[cars ojs_reject:^BOOL(NSString* car) {
                return [car isEqualToString:@"F50"];
            }] should] equal:@[ @"F458 Italia", @"Testarossa" ]];
        });

        it(@"-reduce returns a result of all the elements", ^{
            [[[items ojs_reduce:^id(NSDictionary *accumulator, NSDictionary *item) {
                return [accumulator[@"value"] intValue] > [item[@"value"] intValue]
                ? accumulator : item;
            }] should] equal:@{ @"value": @9 }];
        });

        it(@"-reduce:withBlock with accumulator behaves like -reduce and starts with user provided element", ^{
            [[[items ojs_reduce:@0 withBlock:^id(NSNumber *accumulator, NSDictionary *item) {
                return @(accumulator.intValue + [item[@"value"] intValue]);
            }] should] equal:@18];
        });

    });

    context(@"sorting", ^{

        it(@"-sort aliases -sortUsingComparator:", ^{
            NSSet *numbers = [NSSet setWithArray:@[ @4, @1, @3, @2 ]];
            [[[numbers ojs_sort] should] equal:@[ @1, @2, @3, @4 ]];
        });

    });

});

SPEC_END

