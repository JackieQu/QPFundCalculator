//
//  QPBaseViewController.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/12.
//

#import "QPBaseViewController.h"

@interface QPBaseViewController ()

@end

@implementation QPBaseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
//    [self initUI];
//    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DLogFunction;
}

- (void)dealloc {
    DLogFunction;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Methods

- (void)initUI {
    
}

- (void)loadData {
    
}

- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated {
    
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)pushVC:(UIViewController *)vc {
    
    [self pushVC:vc animated:YES];
}

- (void)popVCAnimated:(BOOL)animated {
    
    [self.navigationController popViewControllerAnimated:animated];
}

- (void)popVC {
    
    [self popVCAnimated:YES];
}

- (void)popToVC:(UIViewController *)vc animated:(BOOL)animated {
    
    [self.navigationController popToViewController:vc animated:animated];
}

- (void)popToVC:(UIViewController *)vc {
    
    [self popToVC:vc animated:YES];
}

- (void)presentVC:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion {
    
    [self presentViewController:vc animated:animated completion:completion];
}

- (void)presentVC:(UIViewController *)vc {
    
    [self presentVC:vc animated:YES completion:nil];
}

- (void)dismissVCAnimated:(BOOL)animated completion:(void (^)(void))completion {
    
    [self dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissVC {
    
    [self dismissVCAnimated:YES completion:nil];
}

@end
