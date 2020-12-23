//
//  NSData+Hex.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/13.
//

#import "NSData+Hex.h"

@implementation NSData (Hex)

+ (NSData *)dataWithHexStr:(NSString *)hexStr {
    
    if (isNullStr(hexStr)) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    
    NSRange range;
    if (hexStr.length % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    
    for (NSInteger i = range.location; i < hexStr.length; i += 2) {
        unsigned int tmpInt;
        NSString *tmpStr = [hexStr substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:tmpStr];
        [scanner scanHexInt:&tmpInt];
        NSData *data = [[NSData alloc] initWithBytes:&tmpInt length:1];
        [hexData appendData:data];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

- (NSString *)hexRepresentationWithSpaces:(BOOL)spaces capitals:(BOOL)capitals {
    
    const unsigned char *bytes = (const unsigned char *)[self bytes];
    NSUInteger nbBytes = [self length];
    // If spaces is true, insert a space every this many input bytes (twice this many output characters).
    static const NSUInteger spaceEveryThisManyBytes = 4UL;
    // If spaces is true, insert a line-break instead of a space every this many spaces.
    static const NSUInteger lineBreakEveryThisManySpaces = 4UL;
    const NSUInteger lineBreakEveryThisManyBytes = spaceEveryThisManyBytes * lineBreakEveryThisManySpaces;
    NSUInteger strLen = 2 * nbBytes + (spaces ? nbBytes / spaceEveryThisManyBytes : 0);

    NSMutableString *hex = [[NSMutableString alloc] initWithCapacity:strLen];

    for (NSUInteger i = 0; i < nbBytes; ) {
        if (capitals) {
            [hex appendFormat:@"%02X", bytes[i]];
        } else {
            [hex appendFormat:@"%02x", bytes[i]];
        }
        // We need to increment here so that the every-n-bytes computations are right.
        ++i;

        if (spaces) {
            if (i % lineBreakEveryThisManyBytes == 0) {
                [hex appendString:@"\n"];
            } else if (i % spaceEveryThisManyBytes == 0) {
                [hex appendString:@" "];
            }
        }
    }
    return hex;
}


@end
