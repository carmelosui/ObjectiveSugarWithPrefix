//
//  NSNumber+Rubyfy.h
//  Domainchy
//
//  Created by Marin Usalj on 11/15/12.
//  Copyright (c) 2012 supermar.in | @supermarin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (ObjectiveSugar)

-  (void)ojs_times:(void(^)(void))block;
-  (void)ojs_timesWithIndex:(void(^)(NSUInteger index))block;

-  (void)ojs_upto:(int)number do:(void(^)(NSInteger number))block;
-  (void)ojs_downto:(int)number do:(void(^)(NSInteger number))block;

// Numeric inflections
-  (NSNumber *)ojs_seconds;
-  (NSNumber *)ojs_minutes;
-  (NSNumber *)ojs_hours;
-  (NSNumber *)ojs_days;
-  (NSNumber *)ojs_weeks;
-  (NSNumber *)ojs_fortnights;
-  (NSNumber *)ojs_months;
-  (NSNumber *)ojs_years;

// There are singular aliases for the above methods
-  (NSNumber *)ojs_second;
-  (NSNumber *)ojs_minute;
-  (NSNumber *)ojs_hour;
-  (NSNumber *)ojs_day;
-  (NSNumber *)ojs_week;
-  (NSNumber *)ojs_fortnight;
-  (NSNumber *)ojs_month;
-  (NSNumber *)ojs_year;

-  (NSDate *)ojs_ago;
-  (NSDate *)ojs_ago:(NSDate *)time;
-  (NSDate *)ojs_since:(NSDate *)time;
-  (NSDate *)ojs_until:(NSDate *)time;
-  (NSDate *)ojs_fromNow;

@end
