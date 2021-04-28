//
//  QPCycleScrollView.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/4/25.
//

#import "QPCycleScrollView.h"
#import <SDWebImage.h>

@interface QPCycleScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *leftImageView, *centerImageView, *rightImageView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation QPCycleScrollView

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, CGRectGetHeight(self.bounds));
        _leftImageView = [[UIImageView alloc] initWithFrame:frame];
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        CGRect frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, CGRectGetHeight(self.bounds));
        _centerImageView = [[UIImageView alloc] initWithFrame:frame];
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        CGRect frame = CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, CGRectGetHeight(self.bounds));
        _rightImageView = [[UIImageView alloc] initWithFrame:frame];
    }
    return _rightImageView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, 0);
        self.backgroundColor = kLightGrayColor;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.currentPage = YES;
        
        [self addSubview:self.leftImageView];
        [self addSubview:self.centerImageView];
        [self addSubview:self.rightImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self closeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self loadCycleData];
    
    [self openTimer];
}

- (void)loadCycleData {
 
    if (floor(self.contentOffset.x) > floor(self.bounds.size.width)) {
        _currentPage = (_currentPage + 1) % _totalPage;
    }
    
    if (floor(self.contentOffset.x) < floor(self.bounds.size.width)) {
        _currentPage = (_currentPage - 1 + _totalPage) % _totalPage;
    }
    
    [self loadImage];
    
    if (self.dataList.count <= 1) {
        [self setScrollEnabled:NO];
    }
}

- (void)loadImage {
    
    NSString *leftImgStr = self.dataList[(_currentPage - 1 + _totalPage) % _totalPage];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:leftImgStr ? leftImgStr : @""]];
    
    NSString *centerImgStr = self.dataList[_currentPage];
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:centerImgStr ? centerImgStr : @""]];
    
    NSString *rightImgStr = self.dataList[(_currentPage + 1) % _totalPage];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:rightImgStr ? rightImgStr : @""]];
    
    [self setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    
    if ([self.cycleDelegate respondsToSelector:@selector(cycleScrollView:currentPage:)]) {
        [self.cycleDelegate cycleScrollView:self currentPage:_currentPage];
    }
}

- (void)clickAction:(UITapGestureRecognizer *)tap {
    
    if ([self.cycleDelegate respondsToSelector:@selector(cycleScrollView:selectedIndex:)]) {
        [self.cycleDelegate cycleScrollView:self selectedIndex:_currentPage];
    }
}

- (void)timerFire {
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setContentOffset:CGPointMake(self.bounds.size.width * 2, 0)];
        self.currentPage = (self.currentPage + 1) % self.totalPage;
    } completion:^(BOOL finished) {
        [self loadImage];
    }];
}

- (void)openTimer {
    
    if (self.dataList.count <= 1) {
        return;
    }
    if (self.timer.isValid) {
        return;
    }
    [self.timer fire];
}

- (void)closeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

@end
