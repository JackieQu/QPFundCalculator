//
//  QPFundHandler.h
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import "QPFundModel.h"
#import "QPFundListModel.h"
#import "QPFundCompanyModel.h"
#import "QPFundCellFrame.h"
#import <MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompanyListHandleSucBlock)(NSArray <QPFundCompanyModel *> *companys);
typedef void(^FundHandleSucBlock)(QPFundModel *fund);
typedef void(^FundListHandleSucBlock)(QPFundListModel *fundList);
typedef void(^FundHandleFaiBlock)(NSString *errMsg);

@interface QPFundHandler : NSObject

+ (void)showSetFundSoureFrom:(FundDataSource)sourceFrom;
+ (void)showSetFundSortType:(FundDataSortType)sortType;
+ (NSMutableArray <QPFundCellFrame *> *)getSortFundDataListWithSortType:(FundDataSortType)sortType
                                                       originalDataList:(NSMutableArray <QPFundCellFrame *> *)originalDataList;

// 天天基金

+ (void)handleFundCompanyWithSucBlock:(CompanyListHandleSucBlock)sucBlock
                             faiBlock:(FundHandleFaiBlock)faiBlock;

/// 获取基金详情
/// @param code 基金代码，只能传一个
+ (void)handleFundDetailWithCode:(NSString *)code
                        sucBlock:(FundHandleSucBlock)sucBlock
                        faiBlock:(FundHandleFaiBlock)faiBlock;

+ (void)handleFundValuationListWithSucBlock:(FundListHandleSucBlock)sucBlock
                                   faiBlock:(FundHandleFaiBlock)faiBlock;

// 小熊同学

/// 获取基金详情
/// @param code 基金代码，可以传多个，逗号连接
+ (void)handleXFundDetailWithCode:(NSString *)code
                         sucBlock:(FundListHandleSucBlock)sucBlock
                         faiBlock:(FundHandleFaiBlock)faiBlock;

@end

NS_ASSUME_NONNULL_END
