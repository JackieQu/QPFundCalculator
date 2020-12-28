//
//  QPFundViewController.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import "QPFundViewController.h"
#import "QPFundCell.h"
#import "QPFundHandler.h"

static NSString *identifier = @"cellID";
static NSString *userFundDictKey = @"USER_FUND_DICT";

@interface QPFundViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *fundTableView;
@property (nonatomic, strong) NSMutableArray *fundDataList;
@property (nonatomic, strong) NSMutableDictionary *userFundDict;
@property (nonatomic, assign) FundDataSource sourceFrom;
@property (nonatomic, assign) FundDataSortType sortType;

@end

@implementation QPFundViewController

- (UITableView *)fundTableView {
    if (!_fundTableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_NAV_HEIGHT);
        _fundTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _fundTableView.delegate = self;
        _fundTableView.dataSource = self;
        [_fundTableView registerClass:[QPFundCell class] forCellReuseIdentifier:identifier];
    }
    return _fundTableView;
}

- (NSMutableArray *)fundDataList {
    if (!_fundDataList) {
        _fundDataList = [NSMutableArray array];
    }
    return _fundDataList;
}

- (NSMutableDictionary *)userFundDict {
    if (!_userFundDict) {
        _userFundDict = [[NSUserDefaults standardUserDefaults] objectForKey:userFundDictKey];
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
    [QPFundHandler showSetFundSoureFrom:sourceFrom];
}

- (void)setSortType:(FundDataSortType)sortType {
    _sortType = sortType;
    [QPFundHandler showSetFundSortType:sortType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sourceFrom = FromTianTian;
    self.sortType = SortByRiseDown;
    
    [self initUI];
    [self loadData];
}

- (void)initUI {
    
    self.title = @"基金收益估算";
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"=" style:UIBarButtonItemStyleDone target:self action:@selector(sumAction)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"天/熊" style:UIBarButtonItemStyleDone target:self action:@selector(changeAction)];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithTitle:@"↑↓" style:UIBarButtonItemStyleDone target:self action:@selector(sortAction)];
    self.navigationItem.rightBarButtonItems = @[item1, item2, item3, item4];
    
    [self.view addSubview:self.fundTableView];
}

- (void)loadData {

    if (isNullDict(self.userFundDict)) {
        [self addAction];
        return;
    }
    
    NSString *allCodeStr = @"";
    for (NSString * code in self.userFundDict.allKeys) {
        allCodeStr = [allCodeStr stringByAppendingFormat:@"%@,", code];
    }
    [self getFundDetailWithCode:allCodeStr];
}

- (void)updateUserFundDictWithHoldValue:(id)holdValue code:(NSString *)code {

    CGFloat holdValueFloat = [holdValue floatValue];
    if (holdValueFloat >= 0) {
        [self.userFundDict setValue:holdValue forKey:code];
    } else {
        [self.userFundDict removeObjectForKey:code];
    }

    [[NSUserDefaults standardUserDefaults] setObject:self.userFundDict forKey:userFundDictKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

// 计算预估收益
- (void)sumAction {
    CGFloat sum = 0;
    CGFloat totalAmount = 0;
    for (QPFundCellFrame *cellFrame in self.fundDataList) {
        QPFundModel *fund = cellFrame.fund;
        sum += fund.holdValue * fund.rise;
        totalAmount += fund.holdValue;
    }
    sum /= 100;
    DLog(@"持有总额：￥%.2lf", totalAmount);
    
    NSString *msg = [NSString stringWithFormat:@"￥%.2lf",sum];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"预计收益" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 变更数据来源
- (void)changeAction {
    
    if (self.sourceFrom == FromTianTian) {
        self.sourceFrom = FromXiaoXiong;
    } else if (self.sourceFrom == FromXiaoXiong) {
        self.sourceFrom = FromTianTian;
    }
    [self loadData];
}

// 变更排序类型
- (void)sortAction {
    
    self.sortType += 1;
    if (self.sortType > SortByNameDown) {
        self.sortType = SortByRiseUp;
    }
    self.fundDataList = [QPFundHandler getSortFundDataListWithSortType:self.sortType originalDataList:self.fundDataList];
    [self.fundTableView reloadData];
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
        [self.fundTableView reloadData];
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
            fund.holdValue = [[self.userFundDict valueForKey:fund.code] floatValue];
            BOOL haveSame = [self haveAddSameFundWithNewFund:fund];
            if (!haveSame) {
                QPFundCellFrame *cellFrame = [[QPFundCellFrame alloc] initWithFund:fund];
                [self.fundDataList insertObject:cellFrame atIndex:0];
            }
            dispatch_group_leave(group);
        } faiBlock:^(NSString * _Nonnull errMsg) {
            DLog(@"%@", errMsg);
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows.firstObject animated:YES];
            self.fundDataList = [QPFundHandler getSortFundDataListWithSortType:self.sortType originalDataList:self.fundDataList];
            [self.fundTableView reloadData];
        });
    });
}

// 小熊同学接口逻辑
- (void)getXFundDetailWithCode:(NSString *)code {
    
    [QPFundHandler handleXFundDetailWithCode:code sucBlock:^(QPFundListModel * _Nonnull fundList) {
        for (QPFundModel *fund in fundList.datas) {
            fund.holdValue = [[self.userFundDict valueForKey:fund.code] floatValue];
            BOOL haveSame = [self haveAddSameFundWithNewFund:fund];
            if (!haveSame) {
                QPFundCellFrame *cellFrame = [[QPFundCellFrame alloc] initWithFund:fund];
                [self.fundDataList insertObject:cellFrame atIndex:0];
            }
        }
        self.fundDataList = [QPFundHandler getSortFundDataListWithSortType:self.sortType originalDataList:self.fundDataList];
        [self.fundTableView reloadData];
    } faiBlock:^(NSString * _Nonnull errMsg) {
        DLog(@"%@", errMsg);
        [self.fundTableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fundDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QPFundCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QPFundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    QPFundCellFrame *cellFrame = self.fundDataList[indexPath.row];
    cell.cellFrame = cellFrame;
    __weak typeof(self) weakSelf = self;
    cell.endEditingBlock = ^(QPFundModel * _Nonnull fund) {
        __strong typeof(self) strongSelf = weakSelf;
        QPFundCellFrame *newCellFrame = [[QPFundCellFrame alloc] initWithFund:fund];
        [strongSelf.fundDataList replaceObjectAtIndex:indexPath.row withObject:newCellFrame];
        [strongSelf updateUserFundDictWithHoldValue:@(fund.holdValue) code:fund.code];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QPFundModel *fund = [self.fundDataList[indexPath.row] fund];
    DLog(@"%@-%@", fund.name, fund.pinyin);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QPFundCellFrame *cellFrame = self.fundDataList[indexPath.row];
    return cellFrame.cellH;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self deleteActionWithIndex:indexPath.row];
    }];
    action.backgroundColor = kRedColor;
    
    NSArray *actions = [NSArray arrayWithObjects:action, nil];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:actions];
    return config;
}

@end
