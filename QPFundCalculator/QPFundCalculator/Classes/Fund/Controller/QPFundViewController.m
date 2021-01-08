//
//  QPFundViewController.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import "QPFundViewController.h"
#import "QPFundTableView.h"
#import "QPFundHandler.h"
#import <MJRefresh.h>
#import "NSDate+Format.h"

@interface QPFundViewController ()

@property (nonatomic, strong) QPFundTableView *fundTableView;
@property (nonatomic, strong) NSMutableArray <QPFundCellFrame *> *fundDataList;
@property (nonatomic, strong) NSMutableDictionary *userFundDict;
@property (nonatomic, assign) FundDataSource sourceFrom;
@property (nonatomic, assign) FundDataSortType sortType;

@end

@implementation QPFundViewController

- (QPFundTableView *)fundTableView {
    if (!_fundTableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_NAV_HEIGHT);
        _fundTableView = [[QPFundTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _fundTableView.fundDataList = self.fundDataList;
        __weak typeof(self) weakSelf = self;
        _fundTableView.endEditingBlock = ^(QPFundCellFrame * _Nonnull cellFrame, NSIndexPath * _Nonnull indexPath) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.fundDataList replaceObjectAtIndex:indexPath.row withObject:cellFrame];
            [strongSelf updateUserFundDictWithHoldValue:@(cellFrame.fund.holdValue) code:cellFrame.fund.code];
        };
        _fundTableView.selectBlock = ^(QPFundCellFrame * _Nonnull cellFrame, NSIndexPath * _Nonnull indexPath) {
            DLog(@"%@-%@", cellFrame.fund.name, cellFrame.fund.pinyin);
        };
        _fundTableView.deleteBlock = ^(QPFundCellFrame * _Nonnull cellFrame, NSIndexPath * _Nonnull indexPath) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf deleteActionWithIndex:indexPath.row];
        };
        _fundTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _fundTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _fundTableView;
}

- (NSMutableArray<QPFundCellFrame *> *)fundDataList {
    if (!_fundDataList) {
        _fundDataList = [NSMutableArray array];
    }
    return _fundDataList;
}

- (NSMutableDictionary *)userFundDict {
    if (!_userFundDict) {
        _userFundDict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_FUND_DICT];
        if (![_userFundDict isKindOfClass:[NSMutableDictionary class]]) {
            _userFundDict = [NSMutableDictionary dictionaryWithDictionary:_userFundDict];
        }
        if (!_userFundDict) {
            _userFundDict = [NSMutableDictionary dictionary];
        }
    }
    return _userFundDict;
}

- (void)setSourceFrom:(FundDataSource)sourceFrom {
    _sourceFrom = sourceFrom;
    [QPFundHandler setFundSourceFrom:sourceFrom show:YES];
}

- (void)setSortType:(FundDataSortType)sortType {
    _sortType = sortType;
    [QPFundHandler setFundSortType:sortType show:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sourceFrom = [QPFundHandler getUserDefaultSourceFrom];
    self.sortType = [QPFundHandler getUserDefaultSortType];
    
    [self initUI];
    [self.fundTableView.mj_header beginRefreshing];
}

- (void)initUI {
    self.title = @"基金收益估算";
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"=" style:UIBarButtonItemStyleDone target:self action:@selector(sumAction:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"T/X" style:UIBarButtonItemStyleDone target:self action:@selector(changeAction)];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithTitle:@"↑/↓" style:UIBarButtonItemStyleDone target:self action:@selector(sortAction)];
    self.navigationItem.rightBarButtonItems = @[item1, item2, item3, item4];
    
    [self.view addSubview:self.fundTableView];
}

- (void)loadData {
    if (isNullDict(self.userFundDict)) {
        [self addAction];
        [self.fundTableView.mj_header endRefreshing];
        return;
    }
    
    NSString *allCodeStr = @"";
    for (NSString * code in self.userFundDict.allKeys) {
        allCodeStr = [allCodeStr stringByAppendingFormat:@"%@,", code];
    }
    [self getFundDetailWithCode:allCodeStr];
}

- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.fundTableView.mj_footer endRefreshingWithNoMoreData];
        });
    });
}

- (void)updateUserFundDictWithHoldValue:(id)holdValue code:(NSString *)code {
    CGFloat holdValueFloat = [holdValue floatValue];
    if (holdValueFloat >= 0) {
        [self.userFundDict setValue:holdValue forKey:code];
    } else {
        [self.userFundDict removeObjectForKey:code];
    }

    [[NSUserDefaults standardUserDefaults] setObject:self.userFundDict forKey:USER_FUND_DICT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 计算预估收益
- (void)sumAction:(UIBarButtonItem *)barBtnItem {
    CGFloat sum = 0, totalAmount = 0;
    for (QPFundCellFrame *cellFrame in self.fundDataList) {
        QPFundModel *fund = cellFrame.fund;
        sum += fund.holdValue * fund.rise;
        totalAmount += fund.holdValue;
    }
    sum /= 100;
    
    #pragma mark - TODO
    if ([NSDate isWeekDay]) {
        NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_FUND_RISE_RECORD];
        if (!dict || ![dict isKindOfClass:[NSMutableDictionary class]]) {
            dict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
        NSString *todayStr = [NSDate dateStrOfToday];
        [dict setValue:@(sum) forKey:[NSDate dateStrOfToday]];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USER_FUND_RISE_RECORD];
        [[NSUserDefaults standardUserDefaults] setFloat:sum forKey:USER_FUND_RISE_AMOUNT_TODAY];
    }
    [[NSUserDefaults standardUserDefaults] setFloat:totalAmount forKey:USER_FUND_HOLD_AMOUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (barBtnItem && [barBtnItem.title isEqualToString:@"="]) {
        NSString *msg = [NSString stringWithFormat:@"￥%.2lf",sum];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"预计收益" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

// 添加持有基金
- (void)addAction {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"添加持有基金" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入基金代码";
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入持有金额";
    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *code = alertVC.textFields.firstObject.text;
        NSString *value = alertVC.textFields.lastObject.text;
        [self updateUserFundDictWithHoldValue:value code:code];
        [self getFundDetailWithCode:code];
    }]];
    [alertVC.view layoutIfNeeded];
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 变更数据来源
- (void)changeAction {
    if (self.sourceFrom == FromTianTian) {
        self.sourceFrom = FromXiaoXiong;
    } else if (self.sourceFrom == FromXiaoXiong) {
        self.sourceFrom = FromTianTian;
    }
    [QPFundHandler setUserDefaultSourceFrom:self.sourceFrom];
    [self loadData];
}

// 变更排序类型
- (void)sortAction {
    self.sortType += 1;
    if (self.sortType > SortByNameDown) {
        self.sortType = SortByRiseUp;
    }
    [QPFundHandler setUserDefaultSortType:self.sortType];
    self.fundDataList = [QPFundHandler getSortFundDataListWithSortType:self.sortType originalDataList:self.fundDataList];
    self.fundTableView.fundDataList = self.fundDataList;
}

// 删除持有基金
- (void)deleteActionWithIndex:(NSInteger)index {
    if (index < 0 || index >= self.fundDataList.count) { return; }
    
    QPFundCellFrame *cellFrame = self.fundDataList[index];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"是否删除基金" message:cellFrame.fund.name preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateUserFundDictWithHoldValue:@(-1) code:cellFrame.fund.code];
        [self.fundDataList removeObjectAtIndex:index];
        self.fundTableView.fundDataList = self.fundDataList;
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 获取基金详情，判断不同数据来源
- (void)getFundDetailWithCode:(NSString *)code {
    if (isNullStr(code)) { return; }
    
    NSArray *codeArr = [code componentsSeparatedByString:@","];
    if (codeArr.count > 1) {
        [self.fundDataList removeAllObjects];
    }
    
    if (self.sourceFrom == FromTianTian) {
        [self getTFundDetailWithCode:code];
    } else if (self.sourceFrom == FromXiaoXiong) {
        [self getXFundDetailWithCode:code];
    }
}

// 天天基金接口逻辑
- (void)getTFundDetailWithCode:(NSString *)code {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.firstObject animated:YES];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSArray *codeArr = [code componentsSeparatedByString:@","];
    for (NSString *code in codeArr) {
        if (isNullStr(code)) { continue; }
        dispatch_group_enter(group);
        [QPFundHandler handleFundDetailWithCode:code sucBlock:^(QPFundModel * _Nonnull fund) {
            [self addFundModel:fund];
            dispatch_group_leave(group);
        } faiBlock:^(NSString * _Nonnull errMsg) {
            DLog(@"%@", errMsg);
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows.firstObject animated:YES];
            [self resetFundDataList];
        });
    });
}

// 小熊同学接口逻辑
- (void)getXFundDetailWithCode:(NSString *)code {
    [QPFundHandler handleXFundDetailWithCode:code sucBlock:^(QPFundListModel * _Nonnull fundList) {
        for (QPFundModel *fund in fundList.datas) {
            [self addFundModel:fund];
        }
        [self resetFundDataList];
    } faiBlock:^(NSString * _Nonnull errMsg) {
        DLog(@"%@", errMsg);
    }];
}

// 是否添加过相同的基金，有则在原位置更新
- (BOOL)haveAddSameFundWithNewFund:(QPFundModel *)newFund {
    BOOL haveSameObj = NO;
    for (NSInteger i = 0; i < self.fundDataList.count; i ++) {
        QPFundCellFrame *cellFrame = self.fundDataList[i];
        QPFundModel *fund = cellFrame.fund;
        if ([fund.code isEqualToString:newFund.code]) {
            haveSameObj = YES;
            cellFrame.fund = newFund;
            [self.fundDataList replaceObjectAtIndex:i withObject:cellFrame];
            break;
        }
    }
    return haveSameObj;
}

// 添加基金模型
- (void)addFundModel:(QPFundModel *)fund {
    fund.holdValue = [[self.userFundDict valueForKey:fund.code] floatValue];
    BOOL haveSame = [self haveAddSameFundWithNewFund:fund];
    if (!haveSame) {
        QPFundCellFrame *cellFrame = [[QPFundCellFrame alloc] initWithFund:fund];
        [self.fundDataList addObject:cellFrame];
    }
}

// 重设数据，刷新列表
- (void)resetFundDataList {
    self.fundDataList = [QPFundHandler getSortFundDataListWithSortType:self.sortType originalDataList:self.fundDataList];
    [self sumAction:nil];
    
    self.fundTableView.fundDataList = self.fundDataList;
    [self.fundTableView.mj_header endRefreshing];
    [self.fundTableView.mj_footer resetNoMoreData];
}

@end
