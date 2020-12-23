//
//  QPBaseTabBarModel.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#import "QPBaseTabBarModel.h"


@implementation QPBaseTabBarModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
        @"vcList" : @"QPViewControllerModel",
    };
}

+ (instancetype)tabBarModel {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QPBaseTabBar" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    QPBaseTabBarModel *tabBarModel = [QPBaseTabBarModel modelWithDict:dict];
    
    NSMutableArray *vcArr = [NSMutableArray array];
    NSArray *vcList = tabBarModel.vcList;
    for (QPViewControllerModel *vcModel in vcList) {
        Class cls = NSClassFromString(vcModel.vcName);
        if (vcModel.show && cls && !isNullStr(vcModel.vcTitle)) {
            vcModel.cls = cls;
            [vcArr addObject:vcModel];
        }
    }
    tabBarModel.availableVCArr = vcArr;
    if (tabBarModel.defaultIndex > vcArr.count - 1) {
        tabBarModel.defaultIndex = 0;
    }
    
    return tabBarModel;
}

@end

@implementation QPViewControllerModel

@end
