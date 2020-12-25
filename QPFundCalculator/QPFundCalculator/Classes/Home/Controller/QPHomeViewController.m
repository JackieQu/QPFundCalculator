//
//  QPHomeViewController.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/23.
//

#import "QPHomeViewController.h"
#import "QPFundViewController.h"

@interface QPHomeViewController ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation QPHomeViewController

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, SCALE(120), SCALE(40));
        _btn.center = CGPointMake(SCREEN_WIDTH / 2, CONTENT_HEIGHT / 2);
        _btn.layer.cornerRadius = SCALE(10);
        _btn.layer.masksToBounds = YES;
        _btn.backgroundColor = kMainColor;
        [_btn setTitle:@"基金收益估算" forState:UIControlStateNormal];
        [_btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.btn];
}

- (void)clickAction:(UIButton *)btn {
    
//    [self getServerAddress];
//    [self getPublicKey];

    QPFundViewController *fundVC = [[QPFundViewController alloc] init];
    [self pushVC:fundVC];
}

/*
- (void)getServerAddress {
    
    [[QPHTTPManager sharedManager] requestWithMethod:GET path:API_GET_URL params:nil prepare:^{
        DLog(@"请求服务器地址");
    } success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@", error);
    }];
}

- (void)getPublicKey {
    
    NSDictionary *params = @{@"method": @"pubkey"};
    [[QPHTTPManager sharedManager] requestWithMethod:GET path:SERVER_PATH params:params prepare:^{
        DLog(@"请求公钥信息");
    } success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@", error);
    }];
}
 */
 
@end
