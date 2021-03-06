//
//  QPHTTPManager.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#import "QPHTTPManager.h"
#import "QPAPIConfig.h"
#import "NSURL+Param.h"

@interface QPHTTPManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) UIAlertController *alertVC;

@end

@implementation QPHTTPManager

- (void)setResponseType:(ResponseSerializerType)responseType {
    _responseType = responseType;
    
    switch (responseType) {
        case HTTP:
            self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case JSON:
            self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        default:
            break;
    }
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/javascript", @"application/x-javascript",  @"text/json", @"text/javascript", @"text/html", @"text/plain", @"image/gif", @"image/jpg", @"image/png", nil];
}

- (UIAlertController *)alertVC {
    if (!_alertVC) {
        _alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接异常，请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [_alertVC addAction:action];
    }
    return _alertVC;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:config];
        
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.requestSerializer.timeoutInterval = 30.f;
        [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded; application/json; application/javascript; application/x-javascript; charset=utf-8;" forHTTPHeaderField:@"Content-Type"];
        
        self.responseType = JSON;
        
        self.manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        self.manager.securityPolicy.allowInvalidCertificates = YES;
        self.manager.securityPolicy.validatesDomainName = NO;
        
        [self startMonitoring];
    }
    return self;
}

- (void)startMonitoring {
 
    self.isReachable = YES;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.isReachable = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.isReachable = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.isReachable = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.isReachable = YES;
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (QPHTTPManager *)sharedManager {
    
    static QPHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)requestWithMethod:(HTTPRequestMethod)method path:(NSString *)path params:(NSDictionary *)params prepare:(PrepareBlock)prepare success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [self requestWithMethod:method path:path params:params prepare:prepare success:success failure:failure noAlert:NO];
}

- (void)requestWithMethod:(HTTPRequestMethod)method path:(NSString *)path params:(NSDictionary *)params prepare:(PrepareBlock)prepare success:(SuccessBlock)success failure:(FailureBlock)failure noAlert:(BOOL)noAlert {
    
//    if (self.isReachable) {
        
        self.responseType = JSON;
        
        if (prepare) {
            prepare();
        }
        
        NSString *urlStr = path;
        if (![path containsString:@"http://"] && ![path containsString:@"https://"]) {
            urlStr = [SERVER_HOST stringByAppendingString:path];
        }
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        DLog(@"%@", [[NSURL URLWithString:urlStr] totalURLStrWithParameterDict:params])
        
        switch (method) {
            case GET:
                [self.manager GET:urlStr parameters:params headers:nil progress:nil success:success failure:failure];
                break;
            case POST:
                [self.manager POST:urlStr parameters:params headers:nil progress:nil success:success failure:failure];
                break;
            case PUT:
                [self.manager PUT:urlStr parameters:params headers:nil success:success failure:failure];
                break;
            case PATCH:
                [self.manager PATCH:urlStr parameters:params headers:nil success:success failure:failure];
                break;
            case DELETE:
                [self.manager DELETE:urlStr parameters:params headers:nil success:success failure:failure];
                break;
            default:
                break;
        }
        
//    } else {
//
//        if (failure) {
//            NSError *error = [NSError errorWithDomain:@"isNotReachable" code:1000 userInfo:nil];
//            UIViewController *rootVC = [[[UIApplication sharedApplication] windows].firstObject rootViewController];
//            if (noAlert ||
//                ![[NSThread currentThread] isMainThread] ||
//                rootVC.presentedViewController) {
//                failure(nil, error);
//                return;
//            }
//
//            [rootVC presentViewController:self.alertVC animated:YES completion:^{
//                failure(nil, error);
//            }];
//        }
//    }
}

@end
