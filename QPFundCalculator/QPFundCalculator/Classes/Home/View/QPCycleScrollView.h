//
//  QPCycleScrollView.h
//  QPFundCalculator
//
//  Created by JackieQu on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QPCycleScrollView;

@protocol QPCycleScrollViewDelegate <NSObject>

- (void)cycleScrollView:(QPCycleScrollView *)scrollView currentPage:(NSInteger)currentPage;

- (void)cycleScrollView:(QPCycleScrollView *)scrollView selectedIndex:(NSInteger)selectedIndex;

@end

@interface QPCycleScrollView : UIScrollView

@property (nonatomic, weak) id<QPCycleScrollViewDelegate> cycleDelegate;

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger totalPage;

- (void)loadCycleData;

- (void)openTimer;
- (void)closeTimer;

@end

NS_ASSUME_NONNULL_END
