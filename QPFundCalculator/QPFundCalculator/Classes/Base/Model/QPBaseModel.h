//
//  QPBaseModel.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface QPBaseModel : NSObject

+ (instancetype)modelWithDict:(NSDictionary *)dict;

+ (NSDictionary *)dictWithModel:(id)model;

- (void)archive;
- (void)archiveWithUserID;
- (void)archiveWithUserIDAndAppendStr:(NSString *)appendStr;

/*
- (id)unarchive;
- (id)unarchiveWithUserID;
- (id)unarchiveWithUserIDAndAppendStr:(NSString *)appendStr;
 */
 
+ (instancetype)unarchive;
+ (instancetype)unarchiveWithUserID;
+ (instancetype)unarchiveWithUserIDAndAppendStr:(NSString *)appendStr;

- (void)remove;
- (void)removeWithUserID;
- (void)removeWithUserIDAndAppendStr:(NSString *)appendStr;

@end

NS_ASSUME_NONNULL_END
