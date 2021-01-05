//
//  QPOptionModel.h
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/5.
//

#import "QPBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPOptionModel : QPBaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) NSInteger ID;

- (instancetype)initWithID:(NSInteger)ID code:(NSString *)code title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
