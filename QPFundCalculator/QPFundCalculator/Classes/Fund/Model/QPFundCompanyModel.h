//
//  QPFundCompanyModel.h
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/24.
//

#import "QPBaseModel.h"

@class QPFundCompanyItem;

NS_ASSUME_NONNULL_BEGIN

@interface QPFundCompanyModel : QPBaseModel

@property (nonatomic, strong) NSMutableArray *op;

@end

@interface QPFundCompanyItem : QPBaseModel

@property (nonatomic, strong) NSArray *info;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *name;

- (instancetype)initWithInfo:(NSArray *)info;

@end

NS_ASSUME_NONNULL_END
