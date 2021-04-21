//
//  QPOptionMaskView.h
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/5.
//

#import <UIKit/UIKit.h>
#import "QPOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellSelectBlock)(QPOptionModel *option, NSIndexPath *indexPath);

@interface QPOptionMaskView : UIView

@property (nonatomic, strong) NSArray <QPOptionModel *> *optionDataList;

@property (nonatomic, copy) CellSelectBlock selectBlock;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
