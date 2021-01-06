//
//  QPOptionModel.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/5.
//

#import "QPOptionModel.h"

@implementation QPOptionModel

@synthesize selectedOption = _selectedOption;

- (void)setSelectedOption:(QPOptionModel *)selectedOption {
    _selectedOption = selectedOption;
    switch (selectedOption.type) {
        case OptionOfSourceFrom:
            [QPFundHandler setUserDefaultSourceFrom:selectedOption.ID];
            break;
        case OptionOfSortType:
            [QPFundHandler setUserDefaultSortType:selectedOption.ID];
            break;
        default:
            break;
    }
}

- (QPOptionModel *)selectedOption {
    if (!_selectedOption) {
        switch (self.type) {
            case OptionOfSourceFrom: {
                FundDataSource sourceFrom = [QPFundHandler getUserDefaultSourceFrom];
                _selectedOption = [QPOptionModel initWithID:sourceFrom type:OptionOfSourceFrom];
            }
                break;
            case OptionOfSortType: {
                FundDataSortType sortType = [QPFundHandler getUserDefaultSortType];
                _selectedOption = [QPOptionModel initWithID:sortType type:OptionOfSortType];
            }
                break;
            default:
                break;
        }
    }
    return _selectedOption;
}

+ (instancetype)initWithID:(NSInteger)ID type:(OptionType)type {
    
    NSString *title = @"";
    switch (type) {
        case OptionOfSourceFrom:
            title = [QPFundHandler setFundSourceFrom:ID show:NO];
            break;
        case OptionOfSortType:
            title = [QPFundHandler setFundSortType:ID show:NO];
            break;
        default:
            break;
    }
    return [[self alloc] initWithID:ID type:type title:title];
}

- (instancetype)initWithID:(NSInteger)ID type:(OptionType)type title:(NSString *)title {
    
    if (self = [super init]) {
        self.ID = ID;
        self.type = type;
        self.title = title;
        
        self.isSelected = [self checkIsSelected];
    }
    return self;
}

- (BOOL)checkIsSelected {
    switch (self.type) {
        case OptionOfSourceFrom: {
            return self.ID == [QPFundHandler getUserDefaultSourceFrom];
        }
            break;
        case OptionOfSortType: {
            return self.ID == [QPFundHandler getUserDefaultSortType];
        }
            break;
        default:
            break;
    }
    return NO;
}

@end
