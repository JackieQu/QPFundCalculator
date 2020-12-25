//
//  QPFundCellFrame.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPFundModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPFundCellFrame : NSObject

@property (nonatomic, strong) QPFundModel *fund;

@property (nonatomic, assign) CGRect nameFieldFrame;
@property (nonatomic, assign) CGRect codeFieldFrame;
@property (nonatomic, assign) CGRect holdValueFieldFrame;
@property (nonatomic, assign) CGRect riseFieldFrame;

@property (nonatomic, assign) CGFloat cellH;

- (instancetype)initWithFund:(QPFundModel *)fund;

@end

NS_ASSUME_NONNULL_END
