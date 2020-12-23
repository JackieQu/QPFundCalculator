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
    
    CGFloat holdValueFieldX = CGRectGetMaxY(_codeFieldFrame) + kMargin;
    CGFloat holdValueFieldY = codeFieldY;
    CGFloat holdValueFieldW = nameFieldW - codeFieldW - kMargin;
    CGFloat holdValueFieldH = codeFieldH;
    _holdValueFieldFrame = CGRectMake(holdValueFieldX, holdValueFieldY, holdValueFieldW, holdValueFieldH);
    
    _cellH = CGRectGetMaxY(_codeFieldFrame) + kMargin / 2;
    
    CGFloat estimatedValueFieldW = SCREEN_WIDTH - nameFieldW - kMargin * 3;
    CGFloat estimatedValueFieldH = 24;
    CGFloat estimatedValueFieldX = CGRectGetMaxX(_nameFieldFrame) + kMargin;
    CGFloat estimatedValueFieldY = (_cellH - estimatedValueFieldH) / 2;
    _estimatedValueFieldFrame = CGRectMake(estimatedValueFieldX, estimatedValueFieldY, estimatedValueFieldW, estimatedValueFieldH);
}

@end