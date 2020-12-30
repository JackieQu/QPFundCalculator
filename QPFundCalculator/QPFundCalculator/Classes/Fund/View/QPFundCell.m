//
//  QPFundCell.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import "QPFundCell.h"

@interface QPFundCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *fundNameField;
@property (nonatomic, strong) UITextField *fundCodeField;
@property (nonatomic, strong) UITextField *holdValueField;
@property (nonatomic, strong) UITextField *riseField;

@end

@implementation QPFundCell

- (UITextField *)fundNameField {
    if (!_fundNameField) {
        _fundNameField = [[UITextField alloc] initWithFrame:CGRectZero];
        _fundNameField.textAlignment = NSTextAlignmentLeft;
        _fundNameField.font = [UIFont systemFontOfSize:17];
        _fundNameField.enabled = NO;
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
        _fundCodeField.enabled = NO;
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
        _holdValueField.delegate = self;
    }
    return _holdValueField;
}

- (UITextField *)riseField {
    if (!_riseField) {
        _riseField = [[UITextField alloc] initWithFrame:CGRectZero];
        _riseField.layer.cornerRadius = 6;
        _riseField.layer.masksToBounds = YES;
        _riseField.backgroundColor = [UIColor redColor];
        _riseField.textColor = [UIColor whiteColor];
        _riseField.textAlignment = NSTextAlignmentCenter;
        _riseField.font = [UIFont systemFontOfSize:13];
        _riseField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _riseField.enabled = NO;
    }
    return _riseField;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.fundNameField];
        [self.contentView addSubview:self.fundCodeField];
        [self.contentView addSubview:self.holdValueField];
        [self.contentView addSubview:self.riseField];
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
    self.holdValueField.text = [NSString stringWithFormat:@"¥%.2lf",fund.holdValue];
    
    self.riseField.frame = cellFrame.riseFieldFrame;
    if (fund.rise > 0) {
        self.riseField.text = [NSString stringWithFormat:@"+%.2lf%%",fund.rise];
        self.riseField.backgroundColor = kRedColor;
    } else if (fund.rise == 0) {
        self.riseField.text = @"0.00%";
        self.riseField.backgroundColor = kLightGrayColor;
    } else {
        self.riseField.text = [NSString stringWithFormat:@"%.2lf%%",fund.rise];
        self.riseField.backgroundColor = kColorRGB(86, 190, 55);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.holdValueField]) {
        if (isNullStr(textField.text)) {
            textField.text = @"¥0.00";
        } else if (![textField.text containsString:@"¥"]) {
            textField.text = [@"¥" stringByAppendingString:textField.text];
        }
        NSString *holdValueStr = [textField.text substringFromIndex:1];
        self.cellFrame.fund.holdValue = [holdValueStr floatValue];
        if (self.endEditingBlock) {
            self.endEditingBlock(self.cellFrame.fund);
        }
    }
}

@end
