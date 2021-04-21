//
//  QPTestViewController.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/4/21.
//

#import "QPTestViewController.h"
#import "QPNodeList.h"

@interface QPTestViewController ()

@end

@implementation QPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *(^viewBlock)(void) = ^() {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        view.backgroundColor = kMainColor;
        return view;
    };
    [self.view addSubview:viewBlock()];
    
    [self testFunc];
    [self nodeFunc];
}

- (void)nodeFunc {
    
    QPNodeList *nodeList = [[QPNodeList alloc] init];

    QPNode *node  = [QPNode nodeWithID:1001 name:@"A"];
    QPNode *node2 = [QPNode nodeWithID:1002 name:@"B"];
    QPNode *node3 = [QPNode nodeWithID:1003 name:@"C"];
    QPNode *node4 = [QPNode nodeWithID:1004 name:@"D"];
    QPNode *node5 = [QPNode nodeWithID:1005 name:@"E"];

    [nodeList appendNode:node];
    [nodeList appendNode:node2];
    [nodeList appendNode:node3];
    [nodeList appendNode:node4];
    [nodeList appendNode:node5];
    
//    [nodeList removeNodeAtIndex:2];

//    QPNode *nodeX = [[QPNode alloc] initWithID:1010 name:@"X"];
//    [nodeList insertNode:nodeX atIndex:4];
//    [nodeList removeNodeAtIndex:4];
    
//    DLog(@"%@", [nodeList searchNodeAtIndex:4].name);
    
    [nodeList reverse];
    [nodeList show];
}

- (void)testFunc {

    NSArray *arr = @[@22, @11, @54, @13, @888, @1, @10, @32, @21, @5];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:arr];
    
    [self quickSortWithArr:mutableArr leftIdx:0 rightIdx:mutableArr.count - 1];
    DLog(@"%@", mutableArr);
    
    NSInteger idx = [self searchIdxByHalfWithArr:mutableArr num:888];
    DLog(@"%ld", (long)idx);
}

- (void)quickSortWithArr:(NSMutableArray *)arr leftIdx:(NSInteger)leftIdx rightIdx:(NSInteger)rightIdx {
    
    if (leftIdx >= rightIdx) { return; }
    
    NSInteger pivot = [arr[leftIdx] integerValue];
    NSInteger i = leftIdx;
    NSInteger j = rightIdx;
    
    while (i != j) {
        while (i < j && pivot <= [arr[j] integerValue]) {
            j --;
        }
        while (i < j && pivot >= [arr[i] integerValue]) {
            i ++;
        }
        if (i < j) {
            [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    
    [arr exchangeObjectAtIndex:i withObjectAtIndex:leftIdx];
    
    [self quickSortWithArr:arr leftIdx:leftIdx rightIdx:i - 1];
    [self quickSortWithArr:arr leftIdx:i + 1 rightIdx:rightIdx];
}

- (NSInteger)searchIdxByHalfWithArr:(NSMutableArray *)arr num:(NSInteger)num {
    
    if (!arr.count || ![arr containsObject:@(num)]) {
        return -1;
    }
    
    NSInteger leftIdx = 0;
    NSInteger rightIdx = arr.count - 1;
    
    while (leftIdx <= rightIdx) {
//        NSInteger midIdx = (leftIdx + rightIdx) / 2;
        NSInteger midIdx = leftIdx + ((rightIdx - leftIdx) >> 1);
        NSInteger midNum = [arr[midIdx] integerValue];
        
        if (num == midNum) {
            return midIdx;
        } else if (num < midNum) {
            rightIdx = midIdx - 1;
        } else if (num > midNum) {
            leftIdx = midIdx + 1;
        }
    }
    return -1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
