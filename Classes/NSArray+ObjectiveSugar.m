//
//  NSArray+ObjectiveSugar.m
//  WidgetPush
//
//  Created by Marin Usalj on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+ObjectiveSugar.h"
#import "NSMutableArray+ObjectiveSugar.h"
#import "NSString+ObjectiveSugar.h"

static NSString * const OSMinusString = @"-";

@implementation NSArray (ObjectiveSugar)

-  (id)ojs_sample {
    if (self.count == 0) return nil;

    NSUInteger index = arc4random_uniform((u_int32_t)self.count);
    return self[index];
}

-  (id)ojs_objectForKeyedSubscript:(id)key {
    if ([key isKindOfClass:[NSString class]])
        return [self subarrayWithRange:[self ojs_rangeFromString:key]];

    else if ([key isKindOfClass:[NSValue class]])
        return [self subarrayWithRange:[key rangeValue]];

    else
        [NSException raise:NSInvalidArgumentException format:@"expected NSString or NSValue argument, got %@ instead", [key class]];

    return nil;
}

-  (NSRange)ojs_rangeFromString:(NSString *)string {
    NSRange range = NSRangeFromString(string);

    if ([string containsString:@"..."]) {
        range.length = isBackwardsRange(string) ? (self.count - 2) - range.length : range.length - range.location;

    } else if ([string containsString:@".."]) {
        range.length = isBackwardsRange(string) ? (self.count - 1) - range.length : range.length - range.location + 1;
    }

    return range;
}

-  (void)ojs_each:(void (^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

-  (void)ojs_eachWithIndex:(void (^)(id object, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

-  (void)ojs_each:(void (^)(id object))block options:(NSEnumerationOptions)options {
    [self enumerateObjectsWithOptions:options usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

-  (void)ojs_eachWithIndex:(void (^)(id object, NSUInteger index))block options:(NSEnumerationOptions)options {
    [self enumerateObjectsWithOptions:options usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

-  (BOOL)ojs_includes:(id)object {
    return [self containsObject:object];
}

-  (NSArray *)ojs_take:(NSUInteger)numberOfElements {
    return [self subarrayWithRange:NSMakeRange(0, MIN(numberOfElements, [self count]))];
}

-  (NSArray *)ojs_takeWhile:(BOOL (^)(id object))block {
    NSMutableArray *array = [NSMutableArray array];

    for (id arrayObject in self) {
        if (block(arrayObject))
            [array addObject:arrayObject];

        else break;
    }

    return array;
}

-  (NSArray *)ojs_map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];

    for (id object in self) {
        [array addObject:block(object) ?: [NSNull null]];
    }

    return array;
}

-  (NSArray *)ojs_select:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]];
}

-  (NSArray *)ojs_reject:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !block(evaluatedObject);
    }]];
}

-  (id)ojs_detect:(BOOL (^)(id object))block {
    for (id object in self) {
        if (block(object))
            return object;
    }
    return nil;
}

-  (id)ojs_find:(BOOL (^)(id object))block {
    return [self ojs_detect:block];
}

-  (NSArray *)ojs_flatten {
    NSMutableArray *array = [NSMutableArray array];

    for (id object in self) {
        if ([object isKindOfClass:NSArray.class]) {
            [array ojs_concat:[object ojs_flatten]];
        } else {
            [array addObject:object];
        }
    }

    return array;
}

-  (NSArray *)ojs_compact {
    return [self ojs_select:^BOOL(id object) {
        return object != [NSNull null];
    }];
}

-  (NSString *)ojs_join {
    return [self componentsJoinedByString:@""];
}

-  (NSString *)ojs_join:(NSString *)separator {
    return [self componentsJoinedByString:separator];
}

-  (NSArray *)ojs_sort {
    return [self sortedArrayUsingSelector:@selector(compare:)];
}

-  (NSArray *)ojs_sortBy:(NSString*)key; {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    return [self sortedArrayUsingDescriptors:@[descriptor]];
}

-  (NSArray *)ojs_reverse {
    return self.reverseObjectEnumerator.allObjects;
}

-  (id)ojs_reduce:(id (^)(id accumulator, id object))block {
    return [self ojs_reduce:nil withBlock:block];
}

-  (id)ojs_reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block {
	id accumulator = initial;

	for(id object in self)
        accumulator = accumulator ? block(accumulator, object) : object;

	return accumulator;
}

-  (NSArray *)ojs_unique {
  return [[NSOrderedSet orderedSetWithArray:self] array];
}

#pragma mark - Set operations

-  (NSArray *)ojs_intersectionWithArray:(NSArray *)array {
    NSPredicate *intersectPredicate = [NSPredicate predicateWithFormat:@"SELF IN %@", array];
    return [self filteredArrayUsingPredicate:intersectPredicate];
}

-  (NSArray *)ojs_unionWithArray:(NSArray *)array {
    NSArray *complement = [self ojs_relativeComplement:array];
    return [complement arrayByAddingObjectsFromArray:array];
}

-  (NSArray *)ojs_relativeComplement:(NSArray *)array {
    NSPredicate *relativeComplementPredicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", array];
    return [self filteredArrayUsingPredicate:relativeComplementPredicate];
}

-  (NSArray *)ojs_symmetricDifference:(NSArray *)array {
    NSArray *aSubtractB = [self ojs_relativeComplement:array];
    NSArray *bSubtractA = [array ojs_relativeComplement:self];
    return [aSubtractB ojs_unionWithArray:bSubtractA];
}

#pragma mark - Private

static inline BOOL isBackwardsRange(NSString *rangeString) {
    return [rangeString containsString:OSMinusString];
}

#pragma mark - Aliases

-  (id)ojs_anyObject {
    return [self ojs_sample];
}

@end

