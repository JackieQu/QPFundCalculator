//
//  QPModuleModel.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/7.
//

#import "QPModuleModel.h"

@implementation QPModuleModel

- (void)setTargetVCName:(NSString *)targetVCName {
    _targetVCName = targetVCName;
    
    if (!isNullStr(targetVCName)) {
        Class cls = NSClassFromString(targetVCName);
        if (cls && [cls isSubclassOfClass:[UIViewController class]]) {
            self.targetClass = cls;
        }
    }
}

@end
