//
//  QPFundCellFrame.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import "QPFundCellFrame.h"

@implementation QPFundCellFrame

- (instancetype)initWithFund:(QPFundModel *)fund {
    
    if (self = [super init]) {
        self.fund = fund;
    }
    return self;
}

- (void)setFund:(QPFundModel *)fund {
    _fund = fund;
    
    CGFloat kMargin = 10;
    
    CGFloat nameFieldY = kMargin / 2;
    CGFloat nameFieldW = SCREEN_WIDTH * 3 / 4;
    CGFloat nameFieldH = 30;
    _nameFieldFrame = CGRectMake(kMargin, nameFieldY, nameFieldW, nameFieldH);
    
    CGFloat codeFieldY = CGRectGetMaxY(_nameFieldFrame) + kMargin / 2;
    CGFloat codeFieldW = 100;
    CGFloat codeFieldH = 15;
    _codeFieldFrame = CGRectMake(kMargin, codeFieldY, codeFieldW, codeFieldH);
    
    CGFloat holdValueFieldW = nameFieldW / 3;
    CGFloat holdValueFieldH = codeFieldH;
    CGFloat holdValueFieldX = CGRectGetMaxX(_nameFieldFrame) - holdValueFieldW;
    CGFloat holdValueFieldY = codeFieldY;
    _holdValueFieldFrame = CGRectMake(holdValueFieldX, holdValueFieldY, holdValueFieldW, holdValueFieldH);
    
    _cellH = CGRectGetMaxY(_codeFieldFrame) + kMargin / 2;
    
    CGFloat riseFieldW = SCREEN_WIDTH - nameFieldW - kMargin * 3;
    CGFloat riseFieldH = 24;
    CGFloat riseFieldX = CGRectGetMaxX(_nameFieldFrame) + kMargin;
    CGFloat riseFieldY = (_cellH - riseFieldH) / 2;
    _riseFieldFrame = CGRectMake(riseFieldX, riseFieldY, riseFieldW, riseFieldH);
}

@end

