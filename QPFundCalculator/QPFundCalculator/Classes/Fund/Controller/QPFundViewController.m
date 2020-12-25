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

typedef NS_ENUM(NSInteger, FundDataSource) {
    FromTianTian,
    FromXiaoXiong,
};

static NSString *identifier = @"cellID";
static NSString *userFundDictKey = @"USER_FUND_DICT";

@interface QPFundViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *fundTableView;

@property (nonatomic, strong) NSMutableArray *fundDataList;

@property (nonatomic, strong) NSMutableDictionary *userFundDict;

@property (nonatomic, assign) FundDataSource sourceFrom;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sourceFrom = FromTianTian;
    
    [self initUI];
    [self loadData];
}

- (void)initUI {
    
    self.title = @"基金收益估算";
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"=" style:UIBarButtonItemStyleDone target:self action:@selector(sumAction)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"天/熊" style:UIBarButtonItemStyleDone target:self action:@selector(changeAction)];
    self.navigationItem.rightBarButtonItems = @[item1, item2, item3];
    
    [self.view addSubview:self.fundTableView];
}

- (void)loadData {
    
//    NSDictionary *userFundDict = @{
//        @"001548": @(5583.30),
//        @"001595": @(1290.46),
//        @"001632": @(50.01),
//        @"003096": @(5349.21),
//        @"006122": @(2899.55),
//        @"008115": @(683.26),
//        @"008282": @(4300),
//        @"008888": @(1500),
//        @"009777": @(474.22),
//        @"161024": @(2703.87),
//        @"161725": @(13.55),
//        @"161726": @(3138.12),
//        @"180031": @(2665.09),
//        @"260108": @(533.28),
//        @"320007": @(2233.6),
//        @"400015": @(4121.4),
//        @"501019": @(4590.2),
//    };

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

- (void)updateUserFundDictWithHoldValue:(NSObject *)holdValue code:(NSString *)code {
    
    [self.userFundDict setValue:holdValue forKey:code];
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
    for (QPFundCellFrame *cellFrame in self.fundDataList) {
        QPFundModel *fund = cellFrame.fund;
        sum += fund.holdValue * fund.rise;
    }
    sum /= 100;
    
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
            [self.fundTableView reloadData];
        });
    });
}

// 小熊同学接口逻辑
- (void)getXFundDetailWithCode:(NSString *)code {
    
    [QPFundHandler handleXFundDetailWithCode:code sucBlock:^(QPFundListModel * _Nonnull fundList) {
        NSArray *codeArr = [code componentsSeparatedByString:@","];
        for (QPFundModel *fund in fundList.datas) {
            fund.holdValue = [[self.userFundDict valueForKey:fund.code] floatValue];
            BOOL haveSame = [self haveAddSameFundWithNewFund:fund];
            if (!haveSame) {
                QPFundCellFrame *cellFrame = [[QPFundCellFrame alloc] initWithFund:fund];
                if (codeArr.count > 1) {
                    [self.fundDataList addObject:cellFrame];
                } else {
                    [self.fundDataList insertObject:cellFrame atIndex:0];
                }
            }
        }
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
    
    [self.view endEditing:YES];
    
    QPFundCellFrame *cellFrame = self.fundDataList[indexPath.row];
    DLog(@"%@", cellFrame.fund.name);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QPFundCellFrame *cellFrame = self.fundDataList[indexPath.row];
    return cellFrame.cellH;
}

@end
