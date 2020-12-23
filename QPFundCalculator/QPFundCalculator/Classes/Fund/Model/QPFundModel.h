//
//  QPFundModel.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/23.
//  Copyright © 2020 QPTemplate. All rights reserved.
//

#import "QPBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPFundModel : QPBaseModel

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) CGFloat holdValue;
@property (nonatomic, assign) CGFloat estimatedValue;

@end

NS_ASSUME_NONNULL_END
