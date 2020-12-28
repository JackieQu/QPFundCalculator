//
//  NSURL+Param.h
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (Param)

- (NSMutableDictionary *)parameterDict;

- (NSString *)valueForParameter:(NSString *)parameterKey;

- (NSMutableDictionary *)totalParameterDictWithBody:(id)body;

- (NSString *)totalURLStrWithParameterDict:(NSDictionary *)parameterDict;

@end

NS_ASSUME_NONNULL_END
