//
//  QPCacheHelper.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

@class QPBaseModel;

#import "QPCacheHelper.h"
#import <MJExtension.h>

@implementation QPCacheHelper

+ (BOOL)saveObj:(id)obj withFileName:(NSString *)fileName {
 
    NSString *path = [self totalCacheFilePathWithFileName:fileName];
//    return [NSKeyedArchiver archiveRootObject:self toFile:path];
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[obj mj_JSONObject] requiringSecureCoding:NO error:&error];
    if (error) {
        return NO;
    }
    BOOL isSuccessful = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    return isSuccessful;
}

//+ (id)getObjWithFileName:(NSString *)fileName {
//
//    NSString * filePath = [self totalCacheFilePathWithFileName:fileName];
//    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//}

+ (NSDictionary *)getDictWithFileName:(NSString *)fileName {
    
    NSString *path = [self totalCacheFilePathWithFileName:fileName];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSError *error;
    id obj = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSDictionary class] fromData:data error:&error];
    if (error) {
        DLog(@"%@", error);
        return nil;
    } else {
        return (NSDictionary *)obj;
    }
}

+ (BOOL)removeObjWithFileName:(NSString *)fileName {
    
    NSString *path = [self totalCacheFilePathWithFileName:fileName];
    NSError *error;
    BOOL isSuccessful = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        DLog(@"%@", error);
    }
    return isSuccessful;
}

+ (NSString *)totalCacheFilePathWithFileName:(NSString *)fileName {
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",cachePath,fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            DLog(@"%@", error);
        }
    }
    filePath = [filePath stringByAppendingFormat:@".archive"];
    return filePath;
}

@end
