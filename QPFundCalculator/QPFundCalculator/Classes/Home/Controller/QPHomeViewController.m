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

@interface QPHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <QPModuleModel *> *dataList;

@end

@implementation QPHomeViewController

#pragma mark - TODO
- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, SCALE(100), SCALE(40));
        _btn.backgroundColor = kMainColor;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
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
        self.btn.center = headerView.center;
        [headerView addSubview:self.btn];
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

@end
