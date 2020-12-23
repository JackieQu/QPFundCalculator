//
//  QPBaseViewController.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QPBaseViewController : UIViewController

- (void)initUI;
- (void)loadData;

- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated;
- (void)pushVC:(UIViewController *)vc;

- (void)popVCAnimated:(BOOL)animated;
- (void)popVC;

- (void)popToVC:(UIViewController *)vc animated:(BOOL)animated;
- (void)popToVC:(UIViewController *)vc;

- (void)presentVC:(UIViewController *)vc animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
- (void)presentVC:(UIViewController *)vc;

- (void)dismissVCAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;
- (void)dismissVC;

@end

NS_ASSUME_NONNULL_END
