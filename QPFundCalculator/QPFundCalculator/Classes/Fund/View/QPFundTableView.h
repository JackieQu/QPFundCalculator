//
//  QPFundTableView.h
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "QPFundCellFrame.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellEndEditingBlock)(QPFundCellFrame *cellFrame, NSIndexPath *indexPath);
typedef void(^CellSelectBlock)(QPFundCellFrame *cellFrame, NSIndexPath *indexPath);
typedef void(^CellDeleteBlock)(QPFundCellFrame *cellFrame, NSIndexPath *indexPath);

@interface QPFundTableView : UITableView

@property (nonatomic, strong) NSMutableArray <QPFundCellFrame *> *fundDataList;

@property (nonatomic, copy) CellEndEditingBlock endEditingBlock;
@property (nonatomic, copy) CellSelectBlock selectBlock;
@property (nonatomic, copy) CellDeleteBlock deleteBlock;

@end

NS_ASSUME_NONNULL_END
