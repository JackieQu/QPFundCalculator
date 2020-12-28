//
//  NSString+Pinyin.h
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Pinyin)

+ (NSString *)pinyinWithString:(NSString *)string;

+ (NSString *)pinyinFirstLetterWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
