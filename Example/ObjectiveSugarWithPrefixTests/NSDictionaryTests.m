//
//  NSDictionaryTests.m
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import "Kiwi.h"
#import "ObjectiveSugar.h"

SPEC_BEGIN(DictionaryAdditions)

describe(@"Iterators", ^{

    NSDictionary *sampleDict = @{
        @"one" : @1,
        @"two" : @2,
        @"three" : @3
    };
    __block NSInteger counter;

    beforeEach(^{
        counter = 0;
    });

    afterEach(^{
        [[@(counter) should] equal:@(sampleDict.allKeys.count)];
    });


    it(@"iterates each key and value", ^{
        [sampleDict ojs_each:^(id key, id value) {
            [[sampleDict.allKeys[counter] should] equal:key];
            [[sampleDict.allValues[counter] should] equal:value];
            counter ++;
        }];
    });

    it(@"iterates all keys", ^{
        [sampleDict ojs_eachKey:^(id key){
            [[sampleDict.allKeys[counter] should] equal:key];
            counter ++;
        }];
    });

    it(@"iterates all values", ^{
        [sampleDict ojs_eachValue:^(id value){
            [[sampleDict.allValues[counter] should] equal:value];
            counter ++;
        }];
    });

    it(@"iterates all keys when mapping", ^{
        NSArray *mapped = [sampleDict ojs_map:^id(id key, id value) {
            counter ++;
            return key;
        }];

        [[mapped should] equal:sampleDict.allKeys];
    });

    it(@"iterates all values when mapping", ^{
        NSArray *mapped = [sampleDict ojs_map:^id(id key, id value) {
            counter ++;
            return value;
        }];

        [[mapped should] equal:sampleDict.allValues];
    });
});

describe(@"Keys", ^{

    NSDictionary *sampleDict = @{
        @"one": @1,
        @"two": @2,
        @"null": [NSNull null]
    };

    it(@"checks that dictionary contains the specified key", ^{
        [[@([sampleDict ojs_hasKey:@"one"]) should] beTrue];
        [[@([sampleDict ojs_hasKey:@"imaginaryKey"]) should] beFalse];
    });

    it(@"tolerates null keys", ^{
        [[@([sampleDict ojs_hasKey:@"null"]) should] beTrue];
    });

});

describe(@"Pick", ^{
    NSDictionary *sampleDict = @{
        @"one": @1,
        @"two": @2,
        @"null": [NSNull null]
    };

    it(@"returns a new dictionary with only the whitelisted keys", ^{
        [[[sampleDict ojs_pick:@[@"one", @"two"]] should] equal:@{
            @"one": @1,
            @"two": @2
        }];
    });
});

describe(@"Omit", ^{
    NSDictionary *sampleDict = @{
        @"one": @1,
        @"two": @2,
        @"null": [NSNull null]
    };

    it(@"returns a new dictionary without the blacklisted keys", ^{
        [[[sampleDict ojs_omit:@[@"one", @"two"]] should] equal:@{@"null": [NSNull null]}];
    });
});

SPEC_END

