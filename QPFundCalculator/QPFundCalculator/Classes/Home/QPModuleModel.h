//
//  QPModuleModel.h
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/7.
//

#import "QPBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPModuleModel : QPBaseModel

@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) NSString *targetVCName;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
