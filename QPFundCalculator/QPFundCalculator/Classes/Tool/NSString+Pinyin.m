//
//  NSString+Pinyin.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/28.
//

#import "NSString+Pinyin.h"

typedef NS_ENUM(NSInteger, ReturnPinyinType) {
    ReturnAllPinyinWithSpace,
    ReturnAllPinyinWithoutSpace,
    ReturnFirstLetterWithSpace,
    ReturnFirstLetterWithoutSpace,
};

typedef NS_ENUM(NSInteger, ReturnCaseType) {
    ReturnUppercase,
    ReturnLowercase,
    ReturnCapitalized,
};

@implementation NSString (Pinyin)

+ (NSString *)pinyinWithString:(NSString *)string {
    
    return [self pinyinWithString:string pinyinType:ReturnAllPinyinWithoutSpace caseType:ReturnLowercase];
}

+ (NSString *)pinyinFirstLetterWithString:(NSString *)string {
    
    return [self pinyinWithString:string pinyinType:ReturnFirstLetterWithoutSpace caseType:ReturnUppercase];
}

+ (NSString *)pinyinWithString:(NSString *)string
                    pinyinType:(ReturnPinyinType)pinyinType
                      caseType:(ReturnCaseType)caseType {
    
    string = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    
    if (!isNullStr(string)) {
 
        NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, 0, kCFStringTransformStripDiacritics, NO);
 
        NSString *result = @"";
        switch (pinyinType) {
            case ReturnAllPinyinWithSpace:
                result = mutableString;
                break;
            case ReturnAllPinyinWithoutSpace:
                result = [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
                break;
            case ReturnFirstLetterWithSpace:
            case ReturnFirstLetterWithoutSpace: {
                NSString *tmpStr = pinyinType == ReturnFirstLetterWithSpace ? @" " : @"";
                NSArray *pinyinArr = [mutableString componentsSeparatedByString:@" "];
                for (NSInteger i = 0; i < pinyinArr.count; i ++) {
                    if (pinyinType == ReturnFirstLetterWithSpace) {
                        tmpStr = i > 0 ? @" " : @"";
                    }
                    NSString *pinyin = pinyinArr[i];
                    NSString *firstLetter = [pinyin substringToIndex:1];
                    result = [NSString stringWithFormat:@"%@%@%@",result,tmpStr,firstLetter];
                }
            }
                break;
            default:
                break;
        }
        
        switch (caseType) {
            case ReturnUppercase:
                return [result uppercaseString];
            case ReturnLowercase:
                return [result lowercaseString];
            case ReturnCapitalized:
                return [result capitalizedString];
            default:
                return [result uppercaseString];
        }
    }
    return [NSString string];
}

@end
