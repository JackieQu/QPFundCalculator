//
//  QPProfileViewController.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/23.
//

#import "QPProfileViewController.h"
#import "QPFundHandler.h"
#import "QPOptionMaskView.h"
#import "QPOptionModel.h"

@interface QPProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation QPProfileViewController

- (UIView *)headerView {
    if (!_headerView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16);
        _headerView = [[UIView alloc] initWithFrame:frame];
        _headerView.backgroundColor = kMainColor;
        
        CGRect imgViewFrame = CGRectMake(SCALE(MARGIN), (_headerView.height - SCALE(120)) / 2, SCALE(100), SCALE(120));
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgViewFrame];
        imgView.image = [UIImage imageNamed:@"rich_icon"];
        [_headerView addSubview:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"何以解忧\n        唯有暴富";
        label.font = kFontSizeAndWeight(30, UIFontWeightBold);
        label.textColor = kWhiteColor;
        label.numberOfLines = 0;
        [label sizeToFit];
        label.origin = CGPointMake(_headerView.width - label.width - SCALE(MARGIN), imgView.centerY);
        [_headerView addSubview:label];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_NAV_HEIGHT);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (NSArray *)dataList {
    if (!_dataList) {
        QPOptionModel *option1 = [[QPOptionModel alloc] initWithID:1 code:@"sourceFrom" title:@"默认数据来源"];
        QPOptionModel *option2 = [[QPOptionModel alloc] initWithID:2 code:@"sortType" title:@"默认排序类型"];
        _dataList = @[option1, option2];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    QPOptionModel *option = self.dataList[indexPath.row];
    cell.textLabel.text = option.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    #pragma mark - TODO
    NSMutableArray *optionDataList = [NSMutableArray array];
    QPOptionModel *option = self.dataList[indexPath.row];
    if ([option.code isEqualToString:@"sourceFrom"]) {
        for (FundDataSource sourceFrom = FromTianTian; sourceFrom <= FromXiaoXiong; sourceFrom ++) {
            QPOptionModel *option = [[QPOptionModel alloc] initWithID:sourceFrom
                                                                 code:@"sourceFrom"
                                                                title:[QPFundHandler setFundSourceFrom:sourceFrom show:NO]];
            [optionDataList addObject:option];
        }
    } else if ([option.code isEqualToString:@"sortType"]) {
        for (FundDataSortType sortType = SortByRiseUp; sortType <= SortByNameDown; sortType ++) {
            QPOptionModel *option = [[QPOptionModel alloc] initWithID:sortType
                                                                 code:@"sortType"
                                                                title:[QPFundHandler setFundSortType:sortType show:NO]];
            [optionDataList addObject:option];
        }
    }
    
    QPOptionMaskView *optionMaskView = [[QPOptionMaskView alloc] init];
    optionMaskView.optionDataList = optionDataList;
    optionMaskView.selectBlock = ^(QPOptionModel * _Nonnull option, NSIndexPath * _Nonnull indexPath) {
        DLog(@"%@", option);
    };
    [optionMaskView show];
}

@end
