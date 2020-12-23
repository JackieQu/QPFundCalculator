//
//  UIView+Frame.m
//  QPTemplate
//
//  Created by JackieQu on 2020/12/12.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setOrigin:(CGPoint)origin {
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    
    return self.frame.origin;
}

- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX {
    
    self.center = CGPointMake(centerX, self.centerY);
}

- (CGFloat)centerX {
    
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    
    self.center = CGPointMake(self.centerX, centerY);
}

- (CGFloat)centerY {
    
    return self.center.y;
}

- (void)setX:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    
    return self.origin.x;
}

- (void)setY:(CGFloat)y {
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    
    return self.origin.y;
}

- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    
    return self.size.width;
}

- (void)setHeight:(CGFloat)height {
 
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    
    return self.size.height;
}

- (void)setTop:(CGFloat)top {
    
    [self setY:top];
}

- (CGFloat)top {
    
    return self.y;
}

- (void)setBottom:(CGFloat)bottom {
    
    [self setTop:bottom - self.height];
}

- (CGFloat)bottom {
    
    return self.top + self.height;
}

- (void)setLeft:(CGFloat)left {
    
    [self setX:left];
}

- (CGFloat)left {
    
    return self.x;
}

- (void)setRight:(CGFloat)right {
    
    [self setX:right - self.width];
}

- (CGFloat)right {
    
    return self.x + self.width;
}

@end
