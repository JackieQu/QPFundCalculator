//
//  QPFundHandler.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/25.
//

#import "QPFundHandler.h"

static NSString * kErrMsg = @"请求失败，请稍后再试...";

@implementation QPFundHandler

+ (void)showSetFundSoureFrom:(FundDataSource)sourceFrom {
    
    switch (sourceFrom) {
        case FromTianTian:
            DLog(@"接口数据来自天天基金");
            break;
        case FromXiaoXiong:
            DLog(@"接口数据来自小熊同学");
            break;
        default:
            break;
    }
}

+ (void)showSetFundSortType:(FundDataSortType)sortType {
    
    switch (sortType) {
        case SortByRiseUp:
            DLog(@"按涨幅升序排序");
            break;
        case SortByRiseDown:
            DLog(@"按涨幅降序排序");
            break;
        case SortByNetValueUp:
            DLog(@"按净值升序排序");
            break;
        case SortByNetValueDown:
            DLog(@"按净值降序排序");
            break;
        case SortByEstimatedValueUp:
            DLog(@"按估值升序排序");
            break;
        case SortByEstimatedValueDown:
            DLog(@"按估值降序排序");
            break;
        case SortByHoldValueUp:
            DLog(@"按持有升序排序");
            break;
        case SortByHoldValueDown:
            DLog(@"按持有降序排序");
            break;
        case SortByCodeUp:
            DLog(@"按基金代码升序排序");
            break;
        case SortByCodeDown:
            DLog(@"按基金代码降序排序");
            break;
        case SortByNameUp:
            DLog(@"按名称拼音升序排序");
            break;
        case SortByNameDown:
            DLog(@"按名称拼音降序排序");
            break;
        default:
            break;
    }
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
                if (faiBlock) { faiBlock(kErrMsg); }
            }
        } else {
            if (faiBlock) { faiBlock(kErrMsg); }
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@", error);
        if (faiBlock) { faiBlock(kErrMsg); }
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
                if (faiBlock) { faiBlock(kErrMsg); }
            }
        } else {
            if (faiBlock) { faiBlock(kErrMsg); }
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@", error);
        if (faiBlock) { faiBlock(kErrMsg); }
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
            if (faiBlock) { faiBlock(fundList.errMsg); }
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@", error);
        if (faiBlock) { faiBlock(kErrMsg); }
    }];
}

#pragma mark - 小熊同学

+ (void)handleXFundDetailWithCode:(NSString *)code
                         sucBlock:(FundListHandleSucBlock)sucBlock
                         faiBlock:(FundHandleFaiBlock)faiBlock {
    
    [[QPHTTPManager sharedManager] requestWithMethod:GET path:API_XFUND_DETAIL(code) params:nil prepare:^{
        DLog(@"请求小熊同学基金详情");
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.firstObject animated:YES];
    } success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows.firstObject animated:YES];
        QPFundListModel *fundList = [QPFundListModel modelWithDict:responseObject];
        if (fundList.code == 200) {
            if (sucBlock) {
                sucBlock(fundList);
            }
        } else {
            if (faiBlock) { faiBlock(fundList.message); }
        }
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows.firstObject animated:YES];
        if (faiBlock) { faiBlock(kErrMsg); }
    }];
}

@end
