//
//  NSDate+Format.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/8.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

+ (NSString *)dateStrOfYesterday {
    return [self dateStrWithFormat:YMD sinceNow:-1];
}

+ (NSString *)dateStrOfToday {
    return [self dateStrWithFormat:YMD sinceNow:0];
}

+ (NSString *)dateStrOfTomorrow {
    return [self dateStrWithFormat:YMD sinceNow:1];
}

+ (NSString *)dateStrSinceNow:(double)day {
    return [self dateStrWithFormat:YMD sinceNow:day];
}

+ (NSString *)weekStrOfToday {
    return [self dateStrWithFormat:E sinceNow:0];
}

+ (NSString *)completeDateStrOfYesterday {
    return [self dateStrWithFormat:YMD_HMS sinceNow:-1];
}

+ (NSString *)completeDateStrOfToday {
    return [self dateStrWithFormat:YMD_HMS sinceNow:0];
}

+ (NSString *)completeDateStrOfTomorrow {
    return [self dateStrWithFormat:YMD_HMS sinceNow:1];
}

+ (NSString *)completeDatrSinceNow:(double)day {
    return [self dateStrWithFormat:YMD_HMS sinceNow:day];
}

+ (NSString *)completeWeekStrOfToday {
    return [self dateStrWithFormat:EEEE sinceNow:0];
}

+ (BOOL)isWeekDay {
    NSArray *arr = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday"];
    return [arr containsObject:[self completeWeekStrOfToday]];
}

+ (BOOL)isWeekEnd {
    NSArray *arr = @[@"Saturday", @"Sunday"];
    return [arr containsObject:[self completeWeekStrOfToday]];
}

+ (NSString *)dateStrWithFormat:(NSString *)format sinceNow:(double)day {
    
    if (isNullStr(format)) {
        format = YMD_HMS;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_CN"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:day * 24 * 60 * 60];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

@end
