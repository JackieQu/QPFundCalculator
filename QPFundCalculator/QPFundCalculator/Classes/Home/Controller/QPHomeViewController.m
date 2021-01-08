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
    
    #pragma mark - TODO
    CGFloat value = 0;
    NSString *weekStr = [NSDate completeWeekStrOfToday];
    if (![weekStr isEqualToString:@"Sunday"] && ![weekStr isEqualToString:@"Monday"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_FUND_RISE_RECORD];
        [[dict valueForKey:[NSDate dateStrOfToday]] floatValue];
    }
    DLog(@"%.2f", value);

    QPModuleModel *module = self.dataList[indexPath.row];
    if (module.targetClass) {
        UIViewController *targetVC = [[module.targetClass alloc] init];
        [self pushVC:targetVC];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerViewID" forIndexPath:indexPath];
        headerView.backgroundColor = kCyanColor;
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
