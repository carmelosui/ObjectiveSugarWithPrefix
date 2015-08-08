//
//  NSMutableArray+ObjectiveSugar.m
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import "NSMutableArray+ObjectiveSugar.h"
#import "NSArray+ObjectiveSugar.h"

@implementation NSMutableArray (ObjectiveSugar)

-  (void)ojs_push:(id)object {
    [self addObject:object];
}

-  (id)ojs_pop {
    id object = [self lastObject];
    [self removeLastObject];

    return object;
}

-  (NSArray *)ojs_pop:(NSUInteger)numberOfElements {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:numberOfElements];

    for (NSUInteger i = 0; i < numberOfElements; i++)
        [array insertObject:[self ojs_pop] atIndex:0];

    return array;
}

-  (void)ojs_concat:(NSArray *)array {
    [self addObjectsFromArray:array];
}

-  (id)ojs_shift {
    NSArray *result = [self ojs_shift:1];
    return [result firstObject];
}

-  (NSArray *)ojs_shift:(NSUInteger)numberOfElements {
    NSUInteger shiftLength = MIN(numberOfElements, [self count]);

    NSRange range = NSMakeRange(0, shiftLength);
    NSArray *result = [self subarrayWithRange:range];
    [self removeObjectsInRange:range];

    return result;
}

-  (NSArray *)ojs_keepIf:(BOOL (^)(id object))block {
    [self filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]];
    return self;
}

@end
