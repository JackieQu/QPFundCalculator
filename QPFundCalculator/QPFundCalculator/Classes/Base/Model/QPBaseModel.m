//
//  QPBaseModel.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#import "QPBaseModel.h"
#import "QPCacheHelper.h"

@interface QPBaseModel () <NSCoding, NSSecureCoding>

@property (nonatomic, strong) NSString *fileName;

@end

@implementation QPBaseModel

- (NSString *)fileName {
    
    if (!_fileName) {
        _fileName = [self.class description];
    }
    return _fileName;
}

- (NSString *)fileNameWithUserID {
    
    NSUInteger userID = 0;
    return [NSString stringWithFormat:@"%@_%ld", self.fileName, (long)userID];
}

- (NSString *)fileNameWithUserIDAndAppendStr:(NSString *)appendStr {
    
    return [NSString stringWithFormat:@"%@_%@", self.fileNameWithUserID, appendStr];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
        @"ID"       : @"id",
        @"desc"     : @"description",
        @"isNew"    : @"new",
    };
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return [self mj_objectWithKeyValues:dict];
    }
    return [[self alloc] init];
}

+ (NSDictionary *)dictWithModel:(id)model {
    
    return [model mj_keyValues];
}

MJExtensionCodingImplementation

+ (BOOL)supportsSecureCoding {
    
    return YES;
}

- (void)archive {
    
    [QPCacheHelper saveObj:self withFileName:self.fileName];
}

- (void)archiveWithUserID {
    
    [QPCacheHelper saveObj:self withFileName:self.fileNameWithUserID];
}

- (void)archiveWithUserIDAndAppendStr:(NSString *)appendStr {
    
    [QPCacheHelper saveObj:self withFileName:[self fileNameWithUserIDAndAppendStr:appendStr]];
}

/*
- (id)unarchive {
    return [QPCacheHelper getObjWithFileName:self.fileName];
}

- (id)unarchiveWithUserID {
    return [QPCacheHelper getObjWithFileName:self.fileNameWithUserID];
}

- (id)unarchiveWithUserIDAndAppendStr:(NSString *)appendStr {
    return [QPCacheHelper getObjWithFileName:[self fileNameWithUserIDAndAppendStr:appendStr]];
}
 */

+ (instancetype)unarchive {
    
    NSString * fileName = [self.class description];
    NSDictionary * dict = [QPCacheHelper getDictWithFileName:fileName];
    return [self mj_objectWithKeyValues:dict];
}

+ (instancetype)unarchiveWithUserID {
    
    NSUInteger userID = 0;
    NSString * fileName = [NSString stringWithFormat:@"%@_%ld", [self.class description], (long)userID];
    NSDictionary * dict = [QPCacheHelper getDictWithFileName:fileName];
    return [self mj_objectWithKeyValues:dict];
}

+ (instancetype)unarchiveWithUserIDAndAppendStr:(NSString *)appendStr {
    
    NSUInteger userID = 0;
    NSString * fileName = [NSString stringWithFormat:@"%@_%ld_%@", [self.class description], (long)userID, appendStr];
    NSDictionary * dict = [QPCacheHelper getDictWithFileName:fileName];
    return [self mj_objectWithKeyValues:dict];
}

- (void)remove {
    
    [QPCacheHelper removeObjWithFileName:self.fileName];
}

- (void)removeWithUserID {
    
    [QPCacheHelper removeObjWithFileName:self.fileNameWithUserID];
}

- (void)removeWithUserIDAndAppendStr:(NSString *)appendStr {
    
    [QPCacheHelper removeObjWithFileName:[self fileNameWithUserIDAndAppendStr:appendStr]];
}

@end
