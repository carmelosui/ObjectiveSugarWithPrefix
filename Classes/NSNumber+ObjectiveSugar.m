//
//  NSNumber+Rubyfy.m
//  Domainchy
//
//  Created by Marin Usalj on 11/15/12.
//  Copyright (c) 2012 supermar.in | @supermarin. All rights reserved.
//

#import "NSNumber+ObjectiveSugar.h"

@implementation NSNumber (ObjectiveSugar)

-  (void)ojs_times:(void (^)(void))block {
    for (int i = 0; i < self.integerValue; i++)
        block();
}

-  (void)ojs_timesWithIndex:(void (^)(NSUInteger))block {
    for (NSUInteger i = 0; i < self.unsignedIntegerValue; i++)
        block(i);
}

-  (void)ojs_upto:(int)number do:(void (^)(NSInteger))block {
    for (NSInteger i = self.integerValue; i <= number; i++)
        block(i);
}

-  (void)ojs_downto:(int)number do:(void (^)(NSInteger))block {
    for (NSInteger i = self.integerValue; i >= number; i--)
        block(i);
}

-  (NSNumber *)ojs_second {
    return self.ojs_seconds;
}

-  (NSNumber *)ojs_seconds {
    return self;
}

-  (NSNumber *)ojs_minute {
    return self.ojs_minutes;
}

-  (NSNumber *)ojs_minutes {
    return @(self.floatValue * 60);
}

-  (NSNumber *)ojs_hour {
    return self.ojs_hours;
}

-  (NSNumber *)ojs_hours {
    return @(self.floatValue * [@60 ojs_minutes].integerValue);
}

-  (NSNumber *)ojs_day {
    return self.ojs_days;
}

-  (NSNumber *)ojs_days {
    return @(self.floatValue * [@24 ojs_hours].integerValue);
}

-  (NSNumber *)ojs_week {
    return self.ojs_weeks;
}

-  (NSNumber *)ojs_weeks {
    return @(self.floatValue * [@7 ojs_days].integerValue);
}

-  (NSNumber *)ojs_fortnight {
    return self.ojs_fortnights;
}

-  (NSNumber *)ojs_fortnights {
    return @(self.floatValue * [@2 ojs_weeks].integerValue);
}

-  (NSNumber *)ojs_month {
    return self.ojs_months;
}

-  (NSNumber *)ojs_months {
    return @(self.floatValue * [@30 ojs_days].integerValue);
}

-  (NSNumber *)ojs_year {
    return self.ojs_years;
}

-  (NSNumber *)ojs_years {
    return @(self.floatValue * [@(365.25) ojs_days].integerValue);
}

-  (NSDate *)ojs_ago {
    return [self ojs_ago:[NSDate date]];
}

-  (NSDate *)ojs_ago:(NSDate *)time {
    return [NSDate dateWithTimeIntervalSince1970:([time timeIntervalSince1970] - self.floatValue)];
}

-  (NSDate *)ojs_since:(NSDate *)time {
    return [NSDate dateWithTimeIntervalSince1970:([time timeIntervalSince1970] + self.floatValue)];
}

-  (NSDate *)ojs_until:(NSDate *)time {
    return [self ojs_ago:time];
}

-  (NSDate *)ojs_fromNow {
    return [self ojs_since:[NSDate date]];
}

@end
