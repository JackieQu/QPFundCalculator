//
//  QPFundListModel.h
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/25.
//

#import "QPBaseModel.h"
#import "QPFundModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPFundListModel : QPBaseModel

@property (nonatomic, strong) NSArray <QPFundModel *> *datas;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger errCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) NSString *expansion;

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *meta;

@end

NS_ASSUME_NONNULL_END

/* 天天基金
 {
     Datas =     (
                 {
             BUY = 1;
             FCODE = 165520;
             GSZ = "1.3023";
             GSZZL = "5.11";
             GZTIME = "2020-12-25";
             ISBUY = 1;
             ISLISTTRADE = 0;
             LISTTEXCH = "";
             SHORTNAME = "\U4fe1\U8bda\U4e2d\U8bc1800\U6709\U8272\U6307\U6570\U5206\U7ea7";
         },
     );
     ErrCode = 0;
     ErrMsg = "<null>";
     Expansion = "<null>";
     TotalCount = 9992;
 }
 */

/*  小熊同学
 {
     code = 200;
     data =     (
                 {
             code = 161725;
             dayGrowth = "-1.91";
             expectGrowth = "-0.07";
             expectWorth = "1.321";
             expectWorthDate = "2020-12-25 13:45:00";
             lastMonthGrowth = "9.62";
             lastSixMonthsGrowth = "71.83";
             lastThreeMonthsGrowth = "39.86";
             lastWeekGrowth = "0.0227";
             lastYearGrowth = "105.79";
             name = "\U62db\U5546\U4e2d\U8bc1\U767d\U9152\U6307\U6570\U5206\U7ea7";
             netWorth = "1.3219";
             netWorthDate = "2020-12-24";
         }
     );
     message = "\U64cd\U4f5c\U6210\U529f";
     meta = 161725;
 }
 */
