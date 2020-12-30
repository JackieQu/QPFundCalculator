//
//  QPFundListModel.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/25.
//

#import "QPFundListModel.h"

@implementation QPFundListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"datas"      : @[@"Datas", @"data"],
        @"totalCount" : @"TotalCount",
        @"errCode"    : @"ErrCode",
        @"errMsg"     : @"ErrMsg",
        @"expansion"  : @"Expansion",
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"datas" : @"QPFundModel"};
}

@end
