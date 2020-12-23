//
//  QPCacheHelper.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QPCacheHelper : NSObject

+ (BOOL)saveObj:(id)obj withFileName:(NSString *)fileName;

//+ (id)getObjWithFileName:(NSString *)fileName;

+ (NSDictionary *)getDictWithFileName:(NSString *)fileName;

+ (BOOL)removeObjWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
