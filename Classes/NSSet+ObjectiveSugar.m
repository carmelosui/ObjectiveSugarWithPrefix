//
//  NSSet+ObjectiveSugar.m
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import "NSSet+ObjectiveSugar.h"
#import "NSArray+ObjectiveSugar.h"

@implementation NSSet (ObjectiveSugar)

-  (id)ojs_firstObject {
    NSArray *allObjects = self.allObjects;

    if (allObjects.count > 0)
        return allObjects[0];
    return nil;
}

-  (id)ojs_lastObject {
    return self.allObjects.lastObject;
}

-  (id)ojs_sample {
    return [self anyObject];
}

-  (void)ojs_each:(void (^)(id))block {
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj);
    }];
}

-  (void)ojs_eachWithIndex:(void (^)(id, int))block {
    __block int counter = 0;
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj, counter);
        counter ++;
    }];
}

-  (NSArray *)ojs_map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];


    for (id object in self) {
        id mappedObject = block(object);
        if(mappedObject) {
            [array addObject:mappedObject];
        }
    }

    return array;
}

-  (NSArray *)ojs_select:(BOOL (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];

    for (id object in self) {
        if (block(object)) {
            [array addObject:object];
        }
    }

    return array;
}

-  (NSArray *)ojs_reject:(BOOL (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];

    for (id object in self) {
        if (block(object) == NO) {
            [array addObject:object];
        }
    }

    return array;
}

-  (NSArray *)ojs_sort {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    return [self sortedArrayUsingDescriptors:@[sortDescriptor]];
}

-  (id)ojs_reduce:(id(^)(id accumulator, id object))block {
    return [self ojs_reduce:nil withBlock:block];
}

-  (id)ojs_reduce:(id)initial withBlock:(id(^)(id accumulator, id object))block {
	id accumulator = initial;

	for(id object in self)
		accumulator = accumulator ? block(accumulator, object) : object;

	return accumulator;
}

@end

