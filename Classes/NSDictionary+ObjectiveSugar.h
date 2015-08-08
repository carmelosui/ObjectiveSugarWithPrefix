//
//  NSDictionary+ObjectiveSugar.h
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ObjectiveSugar)

-  (void)ojs_each:(void (^)(id key, id value))block;
-  (void)ojs_eachKey:(void (^)(id key))block;
-  (void)ojs_eachValue:(void (^)(id value))block;
-  (NSArray *)ojs_map:(id (^)(id key, id value))block;
-  (BOOL)ojs_hasKey:(id)key;
-  (NSDictionary *)ojs_pick:(NSArray *)keys;
-  (NSDictionary *)ojs_omit:(NSArray *)keys;

@end
