//
//  UIColor+Random.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/12.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)randomColor {
    
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [self randomColorWithR:r g:g b:b a:10];
}

+ (UIColor *)randomAlphaColor {
    
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    NSInteger a = arc4random() % 10;
    return [self randomColorWithR:r g:g b:b a:a];
}

+ (UIColor *)randomColorWithR:(CGFloat)r
                            g:(CGFloat)g
                            b:(CGFloat)b
                            a:(CGFloat)a {
 
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 10.0f];
}

@end
