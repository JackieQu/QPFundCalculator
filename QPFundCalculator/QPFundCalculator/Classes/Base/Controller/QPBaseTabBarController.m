//
//  QPBaseTabBarController.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/12.
//

#import "QPBaseTabBarController.h"
#import "QPBaseViewController.h"
#import "QPBaseNavController.h"
#import "QPBaseTabBarModel.h"

@interface QPBaseTabBarController ()

@end

@implementation QPBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QPBaseTabBarModel *tabBarModel = [QPBaseTabBarModel tabBarModel];
    NSMutableArray *vcArr = tabBarModel.availableVCArr;
    for (NSInteger i = 0; i < vcArr.count; i ++) {
        
        QPViewControllerModel *vcModel = vcArr[i];
        
        QPBaseViewController *vc = [[vcModel.cls alloc] init];
        vc.title = vcModel.vcTitle;
        
        QPBaseNavController *navVC = [[QPBaseNavController alloc] initWithRootViewController:vc];
        [vcArr replaceObjectAtIndex:i withObject:navVC];
    }
    self.viewControllers = vcArr;
    self.selectedIndex = tabBarModel.defaultIndex;
}

@end
