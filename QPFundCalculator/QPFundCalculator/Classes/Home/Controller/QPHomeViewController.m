//
//  QPHomeViewController.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/23.
//

#import "QPHomeViewController.h"
#import "QPModuleCell.h"

@interface QPHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <QPModuleModel *> *dataList;

@end

@implementation QPHomeViewController

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
        layout.headerReferenceSize = CGSizeMake(0, 100);
        
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kWhiteColor;
        [_collectionView registerClass:[QPModuleCell class] forCellWithReuseIdentifier:@"cellID"];
    }
    return _collectionView;
}

- (NSMutableArray<QPModuleModel *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
        NSArray *arr = @[
            @{@"title": @"基金收益\n💰估算💰", @"targetVCName": @"QPFundViewController"},
            @{@"title": @"持有总额", @"targetVCName": @""},
            @{@"title": @"昨日收益", @"targetVCName": @""},
            @{@"title": @"今日收益", @"targetVCName": @""},
        ];
        for (NSDictionary *dict in arr) {
            QPModuleModel *module = [QPModuleModel modelWithDict:dict];
            [_dataList addObject:module];
        }
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
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
    if (module.targetVC) {
        [self pushVC:module.targetVC];
    }
}

@end
