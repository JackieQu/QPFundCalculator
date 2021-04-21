//
//  QPFundHandler.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/25.
//

#import "QPFundHandler.h"
#import "NSDate+Format.h"

static NSString * kErrMsg = @"请求失败，请稍后再试...";

@implementation QPFundHandler

+ (BOOL)setUserDefaultFundDict:(NSMutableDictionary *)fundDict {
    [[NSUserDefaults standardUserDefaults] setObject:fundDict forKey:USER_FUND_DICT];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)setUserDefaultAmount:(CGFloat)amount rise:(CGFloat)rise {
    if ([NSDate isWeekDay]) {
        NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_FUND_RISE_RECORD];
        if (!dict || ![dict isKindOfClass:[NSMutableDictionary class]]) {
            dict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
        [dict setValue:@(rise) forKey:[NSDate dateStrOfToday]];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USER_FUND_RISE_RECORD];
    }
    [[NSUserDefaults standardUserDefaults] setFloat:amount forKey:USER_FUND_HOLD_AMOUNT];
    return [[NSUserDefaults standardUserDefaults] synchronize];;
}

+ (BOOL)setUserDefaultSourceFrom:(FundDataSource)sourceFrom {
    [[NSUserDefaults standardUserDefaults] setInteger:sourceFrom forKey:USER_FUND_SOURCE_FROM];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)setUserDefaultSortType:(FundDataSortType)sortType {
    [[NSUserDefaults standardUserDefaults] setInteger:sortType forKey:USER_FUND_SORT_TYPE];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableDictionary *)getUserDefaultFundDict {
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_FUND_DICT];
    if (![dict isKindOfClass:[NSMutableDictionary class]]) {
        dict = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    return dict;
}

+ (NSDictionary *)getUserDefaultAmountAndRise {
    CGFloat riseOfYesterday = 0, riseOfToday = 0, holdAmount = 0;
    holdAmount = [[NSUserDefaults standardUserDefaults] floatForKey:USER_FUND_HOLD_AMOUNT];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_FUND_RISE_RECORD];
    riseOfYesterday = [[dict valueForKey:[NSDate dateStrOfYesterday]] floatValue];
    riseOfToday = [[dict valueForKey:[NSDate dateStrOfToday]] floatValue];
    NSString *weekStr = [NSDate completeWeekStrOfToday];
    // 若当天为周日、周一，则昨日收益置空，避免接口缓存获取到数据
    if ([weekStr isEqualToString:SUNDAY] || [weekStr isEqualToString:MONDAY]) {
        riseOfYesterday = 0;
    }
    // 若当天为周末，则今日收益置空
    if ([NSDate isWeekEnd]) {
        riseOfToday = 0;
    }
    NSString *riseStrOfToday = [NSString stringWithFormat:@"¥%.2f", riseOfToday];
    NSString *riseStrOfYesterday = [NSString stringWithFormat:@"¥%.2f", riseOfYesterday];
    NSString *holdAmountStr = [NSString stringWithFormat:@"¥%.2f", holdAmount];
    return @{
        USER_FUND_RISE_AMOUNT_TODAY     : riseStrOfToday,
        USER_FUND_RISE_AMOUNT_YESTERDAY : riseStrOfYesterday,
        USER_FUND_HOLD_AMOUNT           : holdAmountStr,
    };
}

+ (FundDataSource)getUserDefaultSourceFrom {
    FundDataSource sourceFrom = [[NSUserDefaults standardUserDefaults] integerForKey:USER_FUND_SOURCE_FROM];
    if (!sourceFrom) {
        sourceFrom = FromTianTian;
    }
    return sourceFrom;
}

+ (FundDataSortType)getUserDefaultSortType {
    FundDataSortType sortType = [[NSUserDefaults standardUserDefaults] integerForKey:USER_FUND_SORT_TYPE];
    if (!sortType) {
        sortType = SortByRiseDown;
    }
    return sortType;
}

+ (NSString *)showFundSourceFrom:(FundDataSource)sourceFrom debug:(BOOL)debug {
    
    NSString *sourceStr = @"";
    switch (sourceFrom) {
        case FromTianTian:
            sourceStr = @"天天基金";
            break;
        case FromXiaoXiong:
            sourceStr = @"小熊同学";
            break;
        default:
            break;
    }
    if (debug) {
        DLog(@"接口数据来自%@", sourceStr);
    }
    return sourceStr;
}

+ (NSString *)showFundSortType:(FundDataSortType)sortType debug:(BOOL)debug {
    
    NSString *typeStr = @"";
    switch (sortType) {
        case SortByRiseUp:
            typeStr = @"涨幅升序";
            break;
        case SortByRiseDown:
            typeStr = @"涨幅降序";
            break;
        case SortByNetValueUp:
            typeStr = @"净值升序";
            break;
        case SortByNetValueDown:
            typeStr = @"净值降序";
            break;
        case SortByEstimatedValueUp:
            typeStr = @"估值升序";
            break;
        case SortByEstimatedValueDown:
            typeStr = @"估值降序";
            break;
        case SortByHoldValueUp:
            typeStr = @"持有升序";
            break;
        case SortByHoldValueDown:
            typeStr = @"持有降序";
            break;
        case SortByCodeUp:
            typeStr = @"基金代码升序";
            break;
        case SortByCodeDown:
            typeStr = @"基金代码降序";
            break;
        case SortByNameUp:
            typeStr = @"名称拼音升序";
            break;
        case SortByNameDown:
            typeStr = @"名称拼音降序";
            break;
        default:
            break;
    }
    if (debug) {
        DLog(@"按%@排序", typeStr);
    }
    return typeStr;
}

+ (NSMutableArray<QPFundCellFrame *> *)getSortFundDataListWithSortType:(FundDataSortType)sortType
                                                      originalDataList:(NSMutableArray<QPFundCellFrame *> *)originalDataList {
    
    NSArray *sortDataList = [originalDataList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        QPFundModel *fund1 = [(QPFundCellFrame *)obj1 fund];
        QPFundModel *fund2 = [(QPFundCellFrame *)obj2 fund];
        switch (sortType) {
            case SortByRiseUp:
                return fund1.rise > fund2.rise;
            case SortByRiseDown:
                return fund1.rise < fund2.rise;
            case SortByNetValueUp:
                return fund1.netValue > fund2.netValue;
            case SortByNetValueDown:
                return fund1.netValue < fund2.netValue;
            case SortByEstimatedValueUp:
                return fund1.estimatedValue > fund2.estimatedValue;
            case SortByEstimatedValueDown:
                return fund1.estimatedValue < fund2.estimatedValue;
            case SortByHoldValueUp:
                return fund1.holdValue > fund2.holdValue;
            case SortByHoldValueDown:
                return fund1.holdValue < fund2.holdValue;
            case SortByCodeUp:
                return [fund1.code localizedCompare:fund2.code];
            case SortByCodeDown:
                return [fund2.code localizedCompare:fund1.code];
            case SortByNameUp:
                return [fund1.pinyin localizedCompare:fund2.pinyin];
            case SortByNameDown:
                return [fund2.pinyin localizedCompare:fund1.pinyin];
            default:
                return fund1.rise > fund2.rise;
        }
        return fund1.rise > fund2.rise;
    }];
    originalDataList = [NSMutableArray arrayWithArray:sortDataList];
    return originalDataList;
}

#pragma mark - 天天基金

+ (void)handleFundCompanyWithSucBlock:(CompanyListHandleSucBlock)sucBlock
                             faiBlock:(FundHandleFaiBlock)faiBlock {
    
    [[QPHTTPManager sharedManager] requestWithMethod:GET path:API_FUND_JZGS params:nil prepare:^{
        DLog(@"请求基金公司");
        [QPHTTPManager sharedManager].responseType = HTTP;
    } success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *tmp = @"var gs={op:";
        if (!isNullStr(str) && str.length >= tmp.length) {
            str = [@"{\"op\":" stringByAppendingString:[str substringFromIndex:tmp.length]];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            if (!err) {
                QPFundCompanyModel *company = [QPFundCompanyModel modelWithDict:dict];
                if (sucBlock) { sucBlock(company.op); }
            } else {
                DLog(@"%@", err);
                if (faiBlock) { faiBlock(kErrMsg, err); }
            }
        } else {
            if (faiBlock) { faiBlock(kErrMsg, [NSError errorWithDomain:@"数据格式变更" code:10001 userInfo:nil]); }
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@", error);
        if (faiBlock) { faiBlock(kErrMsg, error); }
    }];
}

+ (void)handleFundValuationListWithSucBlock:(FundListHandleSucBlock)sucBlock
                                   faiBlock:(FundHandleFaiBlock)faiBlock {
    
    [[QPHTTPManager sharedManager] requestWithMethod:GET path:API_FUND_VALUATION_LIST params:nil prepare:^{
        DLog(@"请求基金估值列表");
    } success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        QPFundListModel * fundList = [QPFundListModel modelWithDict:responseObject];
        if (!fundList.errCode) {
            if (sucBlock) {
                sucBlock(fundList);
            }
        } else {
            if (faiBlock) { faiBlock(fundList.errMsg, [NSError errorWithDomain:@"数据格式变更" code:10001 userInfo:nil]); }
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@", error);
        if (faiBlock) { faiBlock(kErrMsg, error); }
    }];
}

+ (void)handleFundDetailWithCode:(NSString *)code
                        sucBlock:(FundHandleSucBlock)sucBlock
                        faiBlock:(FundHandleFaiBlock)faiBlock {
    
    [[QPHTTPManager sharedManager] requestWithMethod:GET path:API_FUND_DETAIL(code) params:nil prepare:^{
//        DLog(@"请求基金详情");
        [QPHTTPManager sharedManager].responseType = HTTP;
    } success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *preStr = @"jsonpgz(";
        NSString *sufStr = @");";
        NSInteger minLen = preStr.length + sufStr.length;
        if (!isNullStr(str) && str.length >= minLen) {
            str = [str substringWithRange:NSMakeRange(preStr.length, str.length - minLen)];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            if (!err) {
                QPFundModel *fund = [QPFundModel modelWithDict:dict];
                if (sucBlock) { sucBlock(fund); }
            } else {
                DLog(@"%@", err);
                if (faiBlock) { faiBlock(kErrMsg, err); }
            }
        } else {
            if (faiBlock) { faiBlock(kErrMsg, [NSError errorWithDomain:@"数据格式变更" code:10001 userInfo:nil]); }
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@", error);
        if (faiBlock) { faiBlock(kErrMsg, error); }
    } noAlert:YES];
}

#pragma mark - 小熊同学

+ (void)handleXFundDetailWithCode:(NSString *)code
                         sucBlock:(FundListHandleSucBlock)sucBlock
                         faiBlock:(FundHandleFaiBlock)faiBlock {
    
    [[QPHTTPManager sharedManager] requestWithMethod:GET path:API_XFUND_DETAIL(code) params:nil prepare:^{
//        DLog(@"请求小熊同学基金详情");
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.firstObject animated:YES];
    } success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows.firstObject animated:YES];
        QPFundListModel *fundList = [QPFundListModel modelWithDict:responseObject];
        if (fundList.code == 200) {
            if (sucBlock) {
                sucBlock(fundList);
            }
        } else {
            if (faiBlock) { faiBlock(fundList.message, [NSError errorWithDomain:@"数据格式变更" code:10001 userInfo:nil]); }
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows.firstObject animated:YES];
        if (faiBlock) { faiBlock(kErrMsg, error); }
    }];
}

@end
