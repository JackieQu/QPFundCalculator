//
//  QPBaseTabBarModel.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

@class QPViewControllerModel;

#import "QPBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPBaseTabBarModel : QPBaseModel

@property (nonatomic, strong) NSArray <QPViewControllerModel *> *vcList;

@property (nonatomic, assign) NSInteger defaultIndex;

@property (nonatomic, strong) NSMutableArray <QPViewControllerModel *> *availableVCArr;

+ (instancetype)tabBarModel;

@end

@interface QPViewControllerModel : QPBaseModel

@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) NSString *vcName;
@property (nonatomic, strong) NSString *vcTitle;

@property (nonatomic, strong) Class cls;

@end

NS_ASSUME_NONNULL_END
