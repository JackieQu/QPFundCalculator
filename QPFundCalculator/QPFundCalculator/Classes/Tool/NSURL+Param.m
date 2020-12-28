//
//  NSURL+Param.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/28.
//

#import "NSURL+Param.h"

@implementation NSURL (Param)

- (NSMutableDictionary *)parameterDict {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSArray *queryComponents = [self.query componentsSeparatedByString:@"&"];
    for (NSString *queryComponent in queryComponents) {
        NSString *key = [queryComponent componentsSeparatedByString:@"="].firstObject;
        if (isNullStr(key)) {
            continue;
        }
        NSString *value = @"";
        if (queryComponent.length >= key.length + 1) {
            value = [queryComponent substringFromIndex:(key.length + 1)];
            if ([self isCorrectTypeWithValue:value]) {
                value = [value stringByRemovingPercentEncoding];
            }
        }
        [paramDict setValue:value forKey:key];
    }
    return paramDict;
}

- (NSString *)valueForParameter:(NSString *)parameterKey {
    
    return [[self parameterDict] valueForKey:parameterKey];
}

- (NSMutableDictionary *)totalParameterDictWithBody:(id)body {
    
    NSDictionary *dict = (NSDictionary *)body;
    NSMutableDictionary *params = [self parameterDict];
    [params setValuesForKeysWithDictionary:dict];
    return params;
}

- (NSString *)totalURLStrWithParameterDict:(NSDictionary *)parameterDict {
    
    NSMutableDictionary *params = [self parameterDict];
    [params setValuesForKeysWithDictionary:parameterDict];
    NSArray *keysArray = [params allKeys];
    NSArray *sortedArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *urlStr = [self.absoluteString componentsSeparatedByString:@"?"].firstObject;
    NSString *sepStr = @"?";
    for (NSString *key in sortedArray) {
        NSString *value = [params valueForKey:key];
        if ([self isCorrectTypeWithValue:value]) {
            value = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        }
        urlStr = [urlStr stringByAppendingFormat:@"%@%@=%@", sepStr, key, value];
        sepStr = @"&";
    }
    return urlStr;
}

- (BOOL)isCorrectTypeWithValue:(NSString *)value {
    
    return  ![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] &&
            ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] &&
            ![value isKindOfClass:NSClassFromString(@"__NSArrayM")] &&
            value.length;
}

@end
