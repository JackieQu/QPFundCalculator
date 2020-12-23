//
//  NSData+Hex.h
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Hex)

+ (NSData *)dataWithHexStr:(NSString *)hexStr;

- (NSString *)hexRepresentationWithSpaces:(BOOL)spaces capitals:(BOOL)capitals;

@end

NS_ASSUME_NONNULL_END
