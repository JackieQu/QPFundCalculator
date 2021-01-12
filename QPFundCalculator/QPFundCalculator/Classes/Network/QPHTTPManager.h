//
//  QPHTTPManager.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HTTPRequestMethod) {
    GET,
    POST,
    PUT,
    PATCH,
    DELETE
};

typedef NS_ENUM(NSInteger, ResponseSerializerType) {
    HTTP,
    JSON,
//    XMLParser,
//    XMLDocument,
//    PropertyList,
//    Image,
//    Compound,
};

typedef void(^PrepareBlock)(void);
typedef void(^SuccessBlock)(NSURLSessionTask * _Nonnull task, id _Nullable responseObject);
typedef void(^FailureBlock)(NSURLSessionTask * _Nullable task, NSError *error);

@interface QPHTTPManager : NSObject

@property (nonatomic, assign) ResponseSerializerType responseType;

@property (nonatomic, assign) BOOL isReachable;

+ (QPHTTPManager *)sharedManager;

- (void)requestWithMethod:(HTTPRequestMethod)method
                     path:(NSString *)path
                   params:(NSDictionary * _Nullable)params
                  prepare:(PrepareBlock)prepare
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
