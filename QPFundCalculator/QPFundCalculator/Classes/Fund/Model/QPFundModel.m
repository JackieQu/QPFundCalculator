//
//  QPFundModel.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import "QPFundModel.h"
#import "NSString+Pinyin.h"

@implementation QPFundModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
        @"code"               : @[@"code", @"fundcode", @"FCODE"],
        @"name"               : @[@"name", @"SHORTNAME"],
        // 单位净值
        @"netValue"           : @[@"netValue", @"dwjz", @"netWorth"],
        // 估市值
        @"estimatedValue"     : @[@"estimatedValue", @"gsz", @"GSZ", @"expectWorth"],
        // 估值涨跌值
        @"estimatedRiseValue" : @[@"estimatedRiseValue", @"dayGrowth"],
        // 估市值涨落比
        @"rise"               : @[@"rise", @"gszzl", @"GSZZL", @"expectGrowth"],
        // 估值时间
        @"estimatedTime"      : @[@"estimatedTime", @"gztime", @"GZTIME", @"expectWorthDate"],
        // 基准日期
        @"referenceDate"      : @[@"referenceDate", @"jzrq", @"netWorthDate"],
        // ？
        @"buy"                : @"BUY",
        @"isBuy"              : @"ISBUY",
        @"listTexch"          : @"LISTTEXCH",
        @"isListTarde"        : @"ISLISTTRADE",
    };
}

- (NSString *)pinyin {
    
    if (!_pinyin) {
        _pinyin = [NSString pinyinFirstLetterWithString:self.name];
    }
    return _pinyin;
}

@end
