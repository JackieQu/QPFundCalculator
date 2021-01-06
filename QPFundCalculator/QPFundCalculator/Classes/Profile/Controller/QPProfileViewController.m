//
//  QPProfileViewController.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/23.
//

#import "QPProfileViewController.h"
#import "QPOptionMaskView.h"

@interface QPProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <QPOptionModel *> *dataList;

@property (nonatomic, strong) QPOptionMaskView *optionMaskView;
@property (nonatomic, strong) NSMutableArray <QPOptionModel *> *optionArrOfSourceFrom;
@property (nonatomic, strong) NSMutableArray <QPOptionModel *> *optionArrOfSortType;

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
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALE(60) * self.dataList.count + self.headerView.height);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (NSArray<QPOptionModel *> *)dataList {
    if (!_dataList) {
        QPOptionModel *option1 = [[QPOptionModel alloc] initWithID:1 type:OptionOfSourceFrom title:@"默认数据来源"];
        QPOptionModel *option2 = [[QPOptionModel alloc] initWithID:2 type:OptionOfSortType title:@"默认排序类型"];
        _dataList = @[option1, option2];
    }
    return _dataList;
}

- (QPOptionMaskView *)optionMaskView {
    if (!_optionMaskView) {
        _optionMaskView = [[QPOptionMaskView alloc] init];
        __weak typeof(self) weakSelf = self;
        _optionMaskView.selectBlock = ^(QPOptionModel * _Nonnull option, NSIndexPath * _Nonnull indexPath) {
            __strong typeof(self) strongSelf = weakSelf;
            NSInteger idx = option.type == OptionOfSortType ? 1 : 0;
            strongSelf.dataList[idx].selectedOption = option;
            [strongSelf.tableView reloadData];
        };
    }
    return _optionMaskView;
}

- (NSMutableArray<QPOptionModel *> *)optionArrOfSourceFrom {
    if (!_optionArrOfSourceFrom) {
        QPOptionModel *option1 = [QPOptionModel initWithID:FromTianTian type:OptionOfSourceFrom];
        QPOptionModel *option2 = [QPOptionModel initWithID:FromXiaoXiong type:OptionOfSourceFrom];
        _optionArrOfSourceFrom = [NSMutableArray arrayWithArray:@[option1, option2]];
    }
    return _optionArrOfSourceFrom;
}

- (NSMutableArray<QPOptionModel *> *)optionArrOfSortType {
    if (!_optionArrOfSortType) {
        _optionArrOfSortType = [NSMutableArray array];
        for (FundDataSortType sortType = SortByRiseUp; sortType <= SortByNameDown; sortType ++) {
            QPOptionModel *option = [QPOptionModel initWithID:sortType type:OptionOfSortType];
            [_optionArrOfSortType addObject:option];
        }
    }
    return _optionArrOfSortType;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateDataAndUI];
}

- (void)initUI {
    self.view.backgroundColor = kColorSameRGBA(255, 0.9);
    [self.view addSubview:self.tableView];
}

- (void)updateDataAndUI {
    
    if ([self.view.subviews containsObject:self.tableView]) {
    
        FundDataSource sourceFrom = [QPFundHandler getUserDefaultSourceFrom];
        self.dataList.firstObject.selectedOption = [QPOptionModel initWithID:sourceFrom type:OptionOfSourceFrom];
        FundDataSortType sortType = [QPFundHandler getUserDefaultSortType];
        self.dataList.lastObject.selectedOption = [QPOptionModel initWithID:sortType type:OptionOfSortType];
        
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    QPOptionModel *option = self.dataList[indexPath.row];
    cell.textLabel.text = option.title;
    cell.detailTextLabel.text = option.selectedOption.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QPOptionModel *option = self.dataList[indexPath.row];
    if (option.type == OptionOfSourceFrom) {
        self.optionMaskView.optionDataList = self.optionArrOfSourceFrom;
    } else if (option.type == OptionOfSortType) {
        self.optionMaskView.optionDataList = self.optionArrOfSortType;
    }
    [self.optionMaskView show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALE(60);
}

@end
