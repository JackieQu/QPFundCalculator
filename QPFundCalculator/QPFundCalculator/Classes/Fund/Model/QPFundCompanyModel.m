//
//  QPFundCompanyModel.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/24.
//

#import "QPFundCompanyModel.h"

@implementation QPFundCompanyModel

- (void)setOp:(NSMutableArray *)op {
    _op = op;
    
    for (NSInteger i = 0; i < op.count; i ++) {
        QPFundCompanyItem *item = [[QPFundCompanyItem alloc] initWithInfo:op[i]];
        [_op replaceObjectAtIndex:i withObject:item];
    }
}

@end

@implementation QPFundCompanyItem

- (instancetype)initWithInfo:(NSArray *)info {
    
    if (self = [super init]) {
        if ([info isKindOfClass:[NSArray class]]) {
            self.info = info;
            if (self.info.count >= 2) {
                self.code = [NSString stringWithFormat:@"%@", self.info[0]];
                self.name = self.info[1];
            }
        }
    }
    return self;
}

@end
