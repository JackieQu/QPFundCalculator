//
//  QPNodeList.h
//  QPFundCalculator
//
//  Created by JackieQu on 2021/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QPNode : NSObject

@property (nonatomic, assign) BOOL unavailble;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong, nullable) QPNode *next;

- (instancetype)initWithID:(NSInteger)ID name:(NSString *)name;
+ (instancetype)nodeWithID:(NSInteger)ID name:(NSString *)name;

@end

@interface QPNodeList : NSObject

@property (nonatomic, strong, nullable) QPNode *head;
@property (nonatomic, strong, nullable) QPNode *tail;
@property (nonatomic, assign) NSInteger length;

- (void)appendNode:(QPNode *)node;
- (void)insertNode:(QPNode *)node atIndex:(NSInteger)index;
- (void)removeNodeAtIndex:(NSInteger)index;
- (QPNode *)searchNodeAtIndex:(NSInteger)index;
- (void)reverse;
- (void)show;

@end

NS_ASSUME_NONNULL_END
