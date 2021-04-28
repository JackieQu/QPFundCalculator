//
//  QPHomeViewController.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/23.
//

#import "QPHomeViewController.h"
#import "QPModuleCell.h"
#import "NSDate+Format.h"
#import "QPFundHandler.h"
#import "QPCycleScrollView.h"

@interface QPHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QPCycleScrollViewDelegate>

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <QPModuleModel *> *dataList;
@property (nonatomic, strong) QPCycleScrollView *scrollView;

@end

@implementation QPHomeViewController

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, SCALE(60), SCALE(44));
//        _btn.backgroundColor = kWhiteColor;
        _btn.layer.cornerRadius = SCALE(10);
        _btn.layer.masksToBounds = YES;
        _btn.clipsToBounds = YES;
        [_btn setTitle:@"👀" forState:UIControlStateNormal];
        [_btn setTitle:@"🙈" forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        BOOL hide = [[NSUserDefaults standardUserDefaults] boolForKey:USER_FUND_INFO_HIDE];
        _btn.selected = hide;
    }
    return _btn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        NSInteger num = 2;
        CGFloat itemW = (SCREEN_WIDTH - SCALE(MARGIN) * (num + 1)) / num;
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.minimumLineSpacing = SCALE(MARGIN);
        layout.minimumInteritemSpacing = SCALE(MARGIN);
        layout.sectionInset = UIEdgeInsetsMake(SCALE(MARGIN), SCALE(MARGIN), SCALE(MARGIN), SCALE(MARGIN));
        layout.scrollDirection = UICollectionViewScrollPositionCenteredVertically;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH * 9 / 16, SCREEN_WIDTH);
        
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kWhiteColor;
        [_collectionView registerClass:[QPModuleCell class] forCellWithReuseIdentifier:@"cellID"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewID"];
    }
    return _collectionView;
}

- (NSMutableArray<QPModuleModel *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
        [self updateDataList];
    }
    return _dataList;
}

- (NSMutableArray<QPModuleModel *> *)updateDataList {
    NSDictionary *dict = [QPFundHandler getUserDefaultAmountAndRise];
    BOOL hide = [[NSUserDefaults standardUserDefaults] boolForKey:USER_FUND_INFO_HIDE];
    NSArray *arr = @[
        @{@"ID": @(1001), @"title": @"基金收益\n💰估算💰", @"targetVCName": @"QPFundViewController", @"desc": @"", @"isSecret": @(hide)},
        @{@"ID": @(1002), @"title": @"持有总额", @"targetVCName": @"", @"desc": dict[USER_FUND_HOLD_AMOUNT], @"isSecret": @(hide)},
        @{@"ID": @(1003), @"title": @"昨日收益", @"targetVCName": @"", @"desc": dict[USER_FUND_RISE_AMOUNT_YESTERDAY], @"isSecret": @(hide)},
        @{@"ID": @(1004), @"title": @"今日收益", @"targetVCName": @"", @"desc": dict[USER_FUND_RISE_AMOUNT_TODAY], @"isSecret": @(hide)},
    ];
    [_dataList removeAllObjects];
    for (NSDictionary *dict in arr) {
        QPModuleModel *module = [QPModuleModel modelWithDict:dict];
        [_dataList addObject:module];
    }
    return _dataList;
}

- (QPCycleScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[QPCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16)];
        _scrollView.cycleDelegate = self;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];

    [self.view addSubview:self.collectionView];
    
    self.scrollView.dataList = @[
        @"https://cn.bing.com/th?id=OHR.AdelieDiving_ZH-CN8185853655_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp",
        @"https://cn.bing.com/th?id=OHR.ChollaGarden_ZH-CN8015525891_UHD.jpg&rf=LaDigue_UHD.jpg&pid=hp&w=3840&h=2160&rs=1&c=4",
        @"https://cn.bing.com/th?id=OHR.MossyCanyon_ZH-CN7931722740_UHD.jpg&rf=LaDigue_UHD.jpg&pid=hp&w=3840&h=2160&rs=1&c=4",
    ];
    self.scrollView.totalPage = self.scrollView.dataList.count;
    [self.scrollView loadCycleData];
    [self.scrollView openTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.dataList = [self updateDataList];
    [self.collectionView reloadData];
}

- (void)clickAction:(UIButton *)button {
    button.selected = !button.selected;
    
    BOOL hide = [[NSUserDefaults standardUserDefaults] boolForKey:USER_FUND_INFO_HIDE];
    [[NSUserDefaults standardUserDefaults] setBool:!hide forKey:USER_FUND_INFO_HIDE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    for (QPModuleModel *module in self.dataList) {
        module.isSecret = !hide;
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QPModuleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    QPModuleModel *module = self.dataList[indexPath.row];
    cell.module = module;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    QPModuleModel *module = self.dataList[indexPath.row];
    if (module.targetClass) {
        UIViewController *targetVC = [[module.targetClass alloc] init];
        [self pushVC:targetVC];
    } else {
        DLog(@"别点了别点了");
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerViewID" forIndexPath:indexPath];
        headerView.backgroundColor = kColorRGB(34, 123, 251);
//        self.btn.center = headerView.center;
//        [headerView addSubview:self.btn];
        [headerView addSubview:self.scrollView];
        return headerView;
    }
    return nil;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//
//    if (section == 0) {
//        return CGSizeMake(SCREEN_WIDTH * 9 / 16, SCREEN_WIDTH);
//    }
//    return CGSizeZero;
//}

#pragma mark - QPCycleScrollViewDelegate

- (void)cycleScrollView:(QPCycleScrollView *)scrollView currentPage:(NSInteger)currentPage {
//    DLog(@"%ld", (long)currentPage);
}

- (void)cycleScrollView:(QPCycleScrollView *)scrollView selectedIndex:(NSInteger)selectedIndex {
    DLog(@"别点了别点了 - %ld", (long)selectedIndex);
}

@end
