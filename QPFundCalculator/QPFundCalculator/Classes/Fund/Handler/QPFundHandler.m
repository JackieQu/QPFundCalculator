//
//  QPFundHandler.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/25.
//

#import "QPFundHandler.h"

static NSString * kErrMsg = @"请求失败，请稍后再试...";

@implementation QPFundHandler

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
