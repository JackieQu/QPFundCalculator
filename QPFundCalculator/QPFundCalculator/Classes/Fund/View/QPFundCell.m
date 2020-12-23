//
//  QPFundCell.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import "QPFundCell.h"

@interface QPFundCell ()

@property (nonatomic, strong) UITextField *fundNameField;
@property (nonatomic, strong) UITextField *fundCodeField;
@property (nonatomic, strong) UITextField *holdValueField;
@property (nonatomic, strong) UITextField *estimatedValueField;

@end

@implementation QPFundCell

- (UITextField *)fundNameField {
    if (!_fundNameField) {
        _fundNameField = [[UITextField alloc] initWithFrame:CGRectZero];
        _fundNameField.textAlignment = NSTextAlignmentLeft;
        _fundNameField.font = [UIFont systemFontOfSize:17];
    }
    return _fundNameField;
}

- (UITextField *)fundCodeField {
    if (!_fundCodeField) {
        _fundCodeField = [[UITextField alloc] initWithFrame:CGRectZero];
        _fundCodeField.textColor = [UIColor lightGrayColor];
        _fundCodeField.textAlignment = NSTextAlignmentLeft;
        _fundCodeField.font = [UIFont systemFontOfSize:13];
        _fundCodeField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _fundCodeField;
}

- (UITextField *)holdValueField {
    if (!_holdValueField) {
        _holdValueField = [[UITextField alloc] initWithFrame:CGRectZero];
        _holdValueField.textColor = [UIColor orangeColor];
        _holdValueField.textAlignment = NSTextAlignmentRight;
        _holdValueField.font = [UIFont systemFontOfSize:13];
        _holdValueField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _holdValueField;
}

- (UITextField *)estimatedValueField {
    if (!_estimatedValueField) {
        _estimatedValueField = [[UITextField alloc] initWithFrame:CGRectZero];
        _estimatedValueField.layer.cornerRadius = 6;
        _estimatedValueField.layer.masksToBounds = YES;
        _estimatedValueField.backgroundColor = [UIColor redColor];
        _estimatedValueField.textColor = [UIColor whiteColor];
        _estimatedValueField.textAlignment = NSTextAlignmentCenter;
        _estimatedValueField.font = [UIFont systemFontOfSize:13];
        _estimatedValueField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _estimatedValueField;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.fundNameField];
        [self.contentView addSubview:self.fundCodeField];
        [self.contentView addSubview:self.holdValueField];
        [self.contentView addSubview:self.estimatedValueField];
    }
    return self;
}

- (void)setCellFrame:(QPFundCellFrame *)cellFrame {
    _cellFrame = cellFrame;
    
    QPFundModel * fund = cellFrame.fund;
    
    self.fundNameField.frame = cellFrame.nameFieldFrame;
    self.fundNameField.text = fund.name;
    
    self.fundCodeField.frame = cellFrame.codeFieldFrame;
    self.fundCodeField.text = fund.code;
    
    self.holdValueField.frame = cellFrame.holdValueFieldFrame;
    self.holdValueField.text = [NSString stringWithFormat:@"￥%.2lf",fund.holdValue];
    
    self.estimatedValueField.frame = cellFrame.estimatedValueFieldFrame;
    if (fund.estimatedValue >= 0) {
        self.estimatedValueField.text = [NSString stringWithFormat:@"+%.2lf%%",fund.estimatedValue];
        self.estimatedValueField.backgroundColor = [UIColor redColor];
    } else {
        self.estimatedValueField.text = [NSString stringWithFormat:@"%.2lf%%",fund.estimatedValue];
        self.estimatedValueField.backgroundColor = kColorRGB(86, 190, 55);
    }
}

@end
