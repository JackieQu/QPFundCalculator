//
//  QPAPIConfig.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#ifndef QPAPIConfig_h
#define QPAPIConfig_h

/*
#define SERVER_HOST                 @"http://newsedit.try.fzyun.cn/"
#define SERVER_PATH                 @"newMobile/syn.do"

#define API_GET_URL                 @"getUrl"
#define API_GET_PUBLIC_KEY          @"?method=pubkey"
 */
 
// 天天基金
#define API_FUND_JZGS               @"http://fund.eastmoney.com/js/jjjz_gs.js" // 基金净值估算？公司？
#define API_FUND_DETAIL(code)       [NSString stringWithFormat:@"http://fundgz.1234567.com.cn/js/%@.js", code]
#define API_FUND_VALUATION_LIST      @"https://fundmobapi.eastmoney.com/FundMApi/FundValuationList.ashx?fundtype=0&SortColumn=GSZZL&Sort=desc&pageIndex=1&pagesize=30&deviceid=Wap&plat=Wap&product=EFund&version=2.0.0&Uid=&_=1608778739686"

// 小熊同学
#define SERVER_HOST                 @"https://api.doctorxiong.club"

#define API_XFUND_DETAIL(code)      [NSString stringWithFormat:@"/v1/fund?code=%@", code]


#endif /* QPAPIConfig_h */
