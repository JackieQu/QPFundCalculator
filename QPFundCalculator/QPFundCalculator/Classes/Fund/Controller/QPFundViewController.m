//
//  QPFundViewController.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import "QPFundViewController.h"
#import "QPFundCell.h"
#import "QPFundModel.h"
#import "QPFundCellFrame.h"

static NSString *identifier = @"cellID";

@interface QPFundViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * fundTableView;

@property (nonatomic, strong) NSMutableArray * fundDataList;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self loadData];
}

- (void)initUI {
    
    self.title = @"基金收益估算";
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"=" style:UIBarButtonItemStyleDone target:self action:@selector(sumAction)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItems = @[item1, item2];
    
    [self.view addSubview:self.fundTableView];
}

- (void)loadData {
    
    NSArray *arr = @[
        @{@"code": @"001548", @"name": @"天弘上证50指数A", @"holdValue": @(5583.30), @"estimatedValue": @(0.65)},
        @{@"code": @"001595", @"name": @"天弘中证银行ETF联接C", @"holdValue": @(1290.46), @"estimatedValue": @(0.19)},
        @{@"code": @"001632", @"name": @"天弘中证食品饮料指数C", @"holdValue": @(50.01), @"estimatedValue": @(-0.06)},
        @{@"code": @"003096", @"name": @"中欧医疗健康混合C", @"holdValue": @(5349.21), @"estimatedValue": @(0.26)},
        @{@"code": @"006122", @"name": @"华安低碳生活混合", @"holdValue": @(2899.55), @"estimatedValue": @(1.53)},
        @{@"code": @"008115", @"name": @"天弘中证红利低波动100指数C", @"holdValue": @(683.26), @"estimatedValue": @(0.21)},
        @{@"code": @"008282", @"name": @"国泰CES半导体芯片行业ETF联接C", @"holdValue": @(4300), @"estimatedValue": @(2.42)},
        @{@"code": @"008888", @"name": @"华夏国证半导体芯片ETF联接C", @"holdValue": @(1500), @"estimatedValue": @(3.02)},
        @{@"code": @"009777", @"name": @"中欧阿尔法混合C", @"holdValue": @(474.22), @"estimatedValue": @(0.96)},
        @{@"code": @"161024", @"name": @"富国中证军工指数分级", @"holdValue": @(2703.87), @"estimatedValue": @(5.12)},
        @{@"code": @"161725", @"name": @"招商中证白酒指数分级", @"holdValue": @(13.55), @"estimatedValue": @(-0.59)},
        @{@"code": @"161726", @"name": @"招商国证生物医药指数", @"holdValue": @(3138.12), @"estimatedValue": @(-0.16)},
        @{@"code": @"180031", @"name": @"银华中小盘精选混合", @"holdValue": @(2665.09), @"estimatedValue": @(1.3)},//
        @{@"code": @"260108", @"name": @"景顺长城新兴成长混合", @"holdValue": @(533.28), @"estimatedValue": @(0.48)},
        @{@"code": @"320007", @"name": @"诺安成长混合", @"holdValue": @(2233.6), @"estimatedValue": @(2.74)},
        @{@"code": @"400015", @"name": @"东方新能源汽车主题混合", @"holdValue": @(4121.4), @"estimatedValue": @(1.27)},
        @{@"code": @"501019", @"name": @"国泰国证航天军工指数", @"holdValue": @(4590.2), @"estimatedValue": @(4.61)},
    ];
    for (NSDictionary *dict in arr) {
        QPFundModel *fund = [QPFundModel modelWithDict:dict];
        QPFundCellFrame *cellFrame = [[QPFundCellFrame alloc] initWithFund:fund];
        [self.fundDataList addObject:cellFrame];
    }

    [self.fundTableView reloadData];
}

- (void)addAction {
    QPFundModel *fund = [[QPFundModel alloc] init];
    QPFundCellFrame *cellFrame = [[QPFundCellFrame alloc] initWithFund:fund];
    [self.fundDataList insertObject:cellFrame atIndex:0];
    [self.fundTableView reloadData];
}

- (void)sumAction {
    CGFloat sum = 0;
    for (QPFundCellFrame *cellFrame in self.fundDataList) {
        QPFundModel *fund = cellFrame.fund;
        sum += fund.holdValue * fund.estimatedValue;
    }
    sum /= 100;
    
    NSString *msg = [NSString stringWithFormat:@"￥%.2lf",sum];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"预计收益" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QPFundCellFrame *cellFrame = self.fundDataList[indexPath.row];
    return cellFrame.cellH;
}

@end
