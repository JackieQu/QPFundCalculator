//
//  QPHTTPManager.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HTTPRequestMethod) {
    GET,
    POST,
    PUT,
    PATCH,
    DELETE
};

typedef void(^PrepareBlock)(void);
typedef void(^SuccessBlock)(NSURLSessionTask * _Nonnull task, id _Nullable responseObject);
typedef void(^FailureBlock)(NSURLSessionTask * _Nullable task, NSError *error);

@interface QPHTTPManager : NSObject

+ (QPHTTPManager *)sharedManager;

- (void)requestWithMethod:(HTTPRequestMethod)method
                     path:(NSString *)path
                   params:(NSDictionary * _Nullable)params
                  prepare:(PrepareBlock)prepare
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
