//
//  QPFundCell.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPFundCellFrame.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellDidEndEditingBlock)(QPFundModel *fund);

@interface QPFundCell : UITableViewCell

@property (nonatomic, strong) QPFundCellFrame * cellFrame;

@property (nonatomic, copy) CellDidEndEditingBlock endEditingBlock;

@end

NS_ASSUME_NONNULL_END
