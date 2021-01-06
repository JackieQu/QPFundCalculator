//
//  QPOptionModel.h
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/5.
//

#import "QPBaseModel.h"
#import "QPFundHandler.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OptionType) {
    OptionOfSourceFrom,
    OptionOfSortType,
};

@interface QPOptionModel : QPBaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) OptionType type;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) QPOptionModel *selectedOption;

+ (instancetype)initWithID:(NSInteger)ID type:(OptionType)type;
- (instancetype)initWithID:(NSInteger)ID type:(OptionType)type title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
