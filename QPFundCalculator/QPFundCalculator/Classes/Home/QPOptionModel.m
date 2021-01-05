//
//  QPOptionModel.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/5.
//

#import "QPOptionModel.h"

@implementation QPOptionModel

- (instancetype)initWithID:(NSInteger)ID code:(NSString *)code title:(NSString *)title {
    
    if (self = [super init]) {
        self.ID = ID;
        self.code = code;
        self.title = title;
    }
    return self;
}

@end
