//
//  NSDictionary+ObjectiveSugar.m
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import "NSDictionary+ObjectiveSugar.h"

@implementation NSDictionary (Rubyfy)

-  (void)ojs_each:(void (^)(id k, id v))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

-  (void)ojs_eachKey:(void (^)(id k))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key);
    }];
}

-  (void)ojs_eachValue:(void (^)(id v))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj);
    }];
}

-  (NSArray *)ojs_map:(id (^)(id key, id value))block {
    NSMutableArray *array = [NSMutableArray array];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id object = block(key, obj);
        if (object) {
          [array addObject:object];
        }
    }];

    return array;
}

-  (BOOL)ojs_hasKey:(id)key {
    return !!self[key];
}

-  (NSDictionary *)ojs_pick:(NSArray *)keys {
    NSMutableDictionary *picked = [[NSMutableDictionary alloc] initWithCapacity:keys.count];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([keys containsObject:key]) {
            picked[key] = obj;
        }
    }];

    return picked;
}

-  (NSDictionary *)ojs_omit:(NSArray *)keys {
    NSMutableDictionary *omitted = [[NSMutableDictionary alloc] initWithCapacity:([self allKeys].count - keys.count)];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![keys containsObject:key]) {
            omitted[key] = obj;
        }
    }];

    return omitted;
}

@end
