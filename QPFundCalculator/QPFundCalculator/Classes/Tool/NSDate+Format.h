//
//  NSDate+Format.h
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *YMD_HMS = @"yyyy-MM-dd HH:mm:ss";
static NSString *YMD_HM  = @"yyyy-MM-dd HH:mm";
static NSString *YMD_H   = @"yyyy-MM-dd HH";
static NSString *YMD     = @"yyyy-MM-dd";
static NSString *YM      = @"yyyy-MM";
static NSString *Y       = @"yyyy";
static NSString *EEEE    = @"EEEE";
static NSString *E       = @"E";

@interface NSDate (Format)

+ (NSString *)dateStrOfYesterday;
+ (NSString *)dateStrOfToday;
+ (NSString *)dateStrOfTomorrow;
+ (NSString *)dateStrSinceNow:(double)day;

+ (NSString *)weekStrOfToday;

+ (NSString *)completeDateStrOfYesterday;
+ (NSString *)completeDateStrOfToday;
+ (NSString *)completeDateStrOfTomorrow;
+ (NSString *)completeDatrSinceNow:(double)day;

+ (NSString *)completeWeekStrOfToday;

+ (BOOL)isWeekDay;
+ (BOOL)isWeekEnd;

+ (NSString *)dateStrWithFormat:(NSString *)format sinceNow:(double)day;

@end

NS_ASSUME_NONNULL_END
