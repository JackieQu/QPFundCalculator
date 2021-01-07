//
//  QPModuleCell.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/7.
//

#import "QPModuleCell.h"

@interface QPModuleCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation QPModuleCell

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = kColorSameRGBA(0, 0.5);
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
        
        _titleLabel.layer.cornerRadius = SCALE(5);
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.clipsToBounds = YES;
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kMainColor;
        self.layer.cornerRadius = SCALE(10);
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.center = self.contentView.center;
}

- (void)setModule:(QPModuleModel *)module {
    _module = module;
    
    self.titleLabel.text = module.title;
    [self.titleLabel sizeToFit];
    self.titleLabel.width += SCALE(10);
    self.titleLabel.height += SCALE(10);
}

@end
