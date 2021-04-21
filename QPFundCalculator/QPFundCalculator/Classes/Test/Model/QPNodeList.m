//
//  QPNodeList.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/4/15.
//

#import "QPNodeList.h"

@implementation QPNode

- (instancetype)initWithID:(NSInteger)ID name:(NSString *)name {
    if (self = [super init]) {
        self.ID = ID;
        self.name = name;
    }
    return self;
}

+ (instancetype)nodeWithID:(NSInteger)ID name:(NSString *)name {
    return [[self alloc] initWithID:ID name:name];
}

@end

@interface QPNodeList ()

@property (atomic, strong) NSLock *mutexLock;

@end

@implementation QPNodeList

- (instancetype)init {
    if (self = [super init]) {
        self.head = nil;
        self.tail = nil;
    }
    return self;
}

- (void)appendNode:(QPNode *)node {
    
    if (node.unavailble) {
        return;
    }
    
    [self.mutexLock lock];
    
    if (!self.head) {
        self.head = node;
        self.tail = self.head;
    } else {
        self.tail.next = node;
        self.tail = node;
    }
    
    self.length += 1;
    node.unavailble = YES;
    
    [self.mutexLock unlock];
}

- (void)insertNode:(QPNode *)node atIndex:(NSInteger)index {
    
    if (index < 0 || index > self.length || node.unavailble) {
        return;
    }
    
    if (index == self.length) {
        
        [self appendNode:node];
        
    } else {
        
        [self.mutexLock lock];
        
        if (index == 0) {
            node.next = self.head;
            self.head = node;
        } else {
            QPNode *curNode = self.head;
            NSInteger i = 1;
            while (i < index) {
                i ++;
                curNode = curNode.next;
            }
            
            QPNode *tmpNode = curNode.next;
            curNode.next = node;
            node.next = tmpNode;
        }
        
        self.length += 1;
        node.unavailble = YES;
        
        [self.mutexLock unlock];
    }
}

- (void)removeNodeAtIndex:(NSInteger)index {
    
    if (index < 0 || index >= self.length) {
        return;
    }
    
    [self.mutexLock lock];
    
    QPNode *delNode;
    if (index == 0) {
        delNode = self.head;
        self.head = delNode.next;
        delNode.next = nil;
        delNode.unavailble = NO;
    } else {
        NSInteger i = 0;
        QPNode *tmpNode;
        delNode = self.head;
        while (i < index) {
            i ++;
            tmpNode = delNode;
            delNode = delNode.next;
        }
        tmpNode.next = delNode.next;
        if (!delNode.next) {
            self.tail = tmpNode;
        }
        delNode.next = nil;
    }
    
    self.length -= 1;
    delNode.unavailble = NO;
    
    [self.mutexLock unlock];
}

- (QPNode *)searchNodeAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.length) {
        return nil;
    }
    
    NSInteger i = 0;
    QPNode *curNode = self.head;
    while (i < index) {
        i ++;
        curNode = curNode.next;
    }
    return curNode;
}

- (void)reverse {
    if (!self.head) {
        return;
    }
    
    QPNode *preNode;
    QPNode *curNode = self.head;
    
    self.tail = curNode;
    
    while (curNode) {
        QPNode *nextNode = curNode.next;
        curNode.next = preNode;
        preNode = curNode;
        curNode = nextNode;
    }
    
    self.head = preNode;
}

- (void)show {
    
    DLog(@"%ld-%@-%@", (long)self.length, self.head.name, self.tail.name);
    
    QPNode *head = self.head;
    while (head) {
        DLog(@"%@-%ld-%@", head.name, (long)head.ID, head.next.name);
        head = head.next;
    }
}

@end
