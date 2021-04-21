//
//  QPModuleCell.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/7.
//

#import "QPModuleCell.h"

@interface QPModuleCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

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

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = kFontSizeAndWeight(20, UIFontWeightBold);
        _descLabel.textColor = kWhiteColor;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.numberOfLines = 1;
    }
    return _descLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kMainColor;
        self.layer.cornerRadius = SCALE(10);
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.center = self.contentView.center;
    
    self.descLabel.centerX = self.titleLabel.centerX;
    self.descLabel.top = self.titleLabel.bottom + SCALE(MARGIN);
}

- (void)setModule:(QPModuleModel *)module {
    _module = module;
    
    if (module.ID == 1002) {
        self.backgroundColor = kColorRGB(34, 123, 251);
    } else if (module.ID == 1003 || module.ID == 1004) {
        self.backgroundColor = [module.desc containsString:@"-"] ? kColorRGB(86, 190, 55) : kRedColor;
    } else {
        self.backgroundColor = kMainColor;
    }
    
    self.titleLabel.text = module.title;
    [self.titleLabel sizeToFit];
    self.titleLabel.width += SCALE(12);
    self.titleLabel.height += SCALE(12);
    
    self.descLabel.hidden = module.ID == 1001;
    if (module.isSecret) {
        self.descLabel.text = @"********";
    } else {
        self.descLabel.text = module.desc;
    }
    [self.descLabel sizeToFit];
}

@end
