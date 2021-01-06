//
//  QPFundModel.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import "QPBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FundDataSource) {
    FromTianTian = 8001,
    FromXiaoXiong,
};

typedef NS_ENUM(NSInteger, FundDataSortType) {
    SortByRiseUp = 6001,
    SortByRiseDown,
    SortByNetValueUp,
    SortByNetValueDown,
    SortByEstimatedValueUp,
    SortByEstimatedValueDown,
    SortByHoldValueUp,
    SortByHoldValueDown,
    SortByCodeUp,
    SortByCodeDown,
    SortByNameUp,
    SortByNameDown,
};

@interface QPFundModel : QPBaseModel

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, assign) CGFloat holdValue;            // 持有值
@property (nonatomic, assign) CGFloat netValue;             // 净值
@property (nonatomic, assign) CGFloat estimatedValue;       // 估值
@property (nonatomic, assign) CGFloat estimatedRiseValue;   // 估值涨跌值
@property (nonatomic, assign) CGFloat rise;                 // 涨幅
@property (nonatomic, strong) NSString *estimatedTime;      // 估值时间
@property (nonatomic, strong) NSString *referenceDate;      // 基准日期

// 天天基金接口
@property (nonatomic, assign) BOOL buy;                     // 是否可以买入？
@property (nonatomic, strong) NSString *isBuy;              // 买入类型？
@property (nonatomic, strong) NSString *listTexch;          // 列表推荐？
@property (nonatomic, strong) NSString *isListTrade;        // ?

// 小熊同学接口
@property (nonatomic, assign) CGFloat lastWeekGrowth;
@property (nonatomic, assign) CGFloat lastMonthGrowth;
@property (nonatomic, assign) CGFloat lastThreeMonthsGrowth;
@property (nonatomic, assign) CGFloat lastSixMonthsGrowth;
@property (nonatomic, assign) CGFloat lastYearGrowth;

@end

NS_ASSUME_NONNULL_END
