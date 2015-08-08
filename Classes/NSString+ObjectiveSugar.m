//
//  NSString+ObjectiveSugar.m
//  SampleProject
//
//  Created by Neil on 05/12/2012.
//  Copyright (c) 2012 @supermarin | supermar.in. All rights reserved.
//

#import "NSString+ObjectiveSugar.h"
#import "NSArray+ObjectiveSugar.h"

static NSString *const UNDERSCORE = @"_";
static NSString *const SPACE = @" ";
static NSString *const EMPTY_STRING = @"";

NSString *NSStringWithFormat(NSString *formatString, ...) {
    va_list args;
    va_start(args, formatString);

    NSString *string = [[NSString alloc] initWithFormat:formatString arguments:args];

    va_end(args);

#if defined(__has_feature) && __has_feature(objc_arc)
    return string;
#else
    return [string autorelease];
#endif
}


@implementation NSString(Additions)

-  (NSArray *)ojs_split {
    NSArray *result = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [result ojs_select:^BOOL(NSString *string) {
        return string.length > 0;
    }];
}

-  (NSArray *)ojs_split:(NSString *)delimiter {
    return [self componentsSeparatedByString:delimiter];
}

-  (NSString *)ojs_camelCase {
    NSString *spaced = [self stringByReplacingOccurrencesOfString:UNDERSCORE withString:SPACE];
    NSString *capitalized = [spaced capitalizedString];

    return [capitalized stringByReplacingOccurrencesOfString:SPACE withString:EMPTY_STRING];
}

-  (NSString *)ojs_lowerCamelCase {
    NSString *upperCamelCase = [self ojs_camelCase];
    NSString *firstLetter = [upperCamelCase substringToIndex:1];
    return [upperCamelCase stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter.lowercaseString];
}

-  (BOOL)ojs_containsString:(NSString *) string {
    NSRange range = [self rangeOfString:string options:NSCaseInsensitiveSearch];
    return range.location != NSNotFound;
}

-  (NSString *)ojs_strip {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
