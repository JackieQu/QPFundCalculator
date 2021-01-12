//
//  QPFundHandler.h
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import "QPFundCompanyModel.h"
#import "QPFundListModel.h"
#import "QPFundModel.h"
#import "QPFundCellFrame.h"
#import <MBProgressHUD.h>

#define USER_FUND_DICT                  @"USER_FUND_DICT"
#define USER_FUND_SOURCE_FROM           @"USER_FUND_SOURCE_FROM"
#define USER_FUND_SORT_TYPE             @"USER_FUND_SORT_TYPE"

#define USER_FUND_RISE_AMOUNT_TODAY     @"USER_FUND_RISE_AMOUNT_TODAY"
#define USER_FUND_RISE_AMOUNT_YESTERDAY @"USER_FUND_RISE_AMOUNT_YESTERDAY"
#define USER_FUND_RISE_RECORD           @"USER_FUND_RISE_RECORD"
#define USER_FUND_HOLD_AMOUNT           @"USER_FUND_HOLD_AMOUNT"
#define USER_FUND_INFO_HIDE             @"USER_FUND_INFO_HIDE"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompanyListHandleSucBlock)(NSArray <QPFundCompanyModel *> *companys);
typedef void(^FundListHandleSucBlock)(QPFundListModel *fundList);
typedef void(^FundHandleSucBlock)(QPFundModel *fund);
typedef void(^FundHandleFaiBlock)(NSString *errMsg, NSError *err);

@interface QPFundHandler : NSObject

+ (BOOL)setUserDefaultFundDict:(NSMutableDictionary *)fundDict;
+ (BOOL)setUserDefaultAmount:(CGFloat)amount rise:(CGFloat)rise;
+ (BOOL)setUserDefaultSourceFrom:(FundDataSource)sourceFrom;
+ (BOOL)setUserDefaultSortType:(FundDataSortType)sortType;

+ (NSMutableDictionary *)getUserDefaultFundDict;
+ (NSDictionary *)getUserDefaultAmountAndRise;
+ (FundDataSource)getUserDefaultSourceFrom;
+ (FundDataSortType)getUserDefaultSortType;

+ (NSString *)showFundSourceFrom:(FundDataSource)sourceFrom debug:(BOOL)debug;
+ (NSString *)showFundSortType:(FundDataSortType)sortType debug:(BOOL)debug;

+ (NSMutableArray <QPFundCellFrame *> *)getSortFundDataListWithSortType:(FundDataSortType)sortType
                                                       originalDataList:(NSMutableArray <QPFundCellFrame *> *)originalDataList;

// 天天基金

+ (void)handleFundCompanyWithSucBlock:(CompanyListHandleSucBlock)sucBlock
                             faiBlock:(FundHandleFaiBlock)faiBlock;


+ (void)handleFundValuationListWithSucBlock:(FundListHandleSucBlock)sucBlock
                                   faiBlock:(FundHandleFaiBlock)faiBlock;

/// 获取基金详情
/// @param code 基金代码，只能传一个
+ (void)handleFundDetailWithCode:(NSString *)code
                        sucBlock:(FundHandleSucBlock)sucBlock
                        faiBlock:(FundHandleFaiBlock)faiBlock;

// 小熊同学

/// 获取基金详情
/// @param code 基金代码，可以传多个，逗号连接
+ (void)handleXFundDetailWithCode:(NSString *)code
                         sucBlock:(FundListHandleSucBlock)sucBlock
                         faiBlock:(FundHandleFaiBlock)faiBlock;

@end

NS_ASSUME_NONNULL_END
