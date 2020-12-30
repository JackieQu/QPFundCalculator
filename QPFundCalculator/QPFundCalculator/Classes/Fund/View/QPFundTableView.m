//
//  QPFundTableView.m
//  QPFundCalculator
//
//  Created by JackieQu on 2020/12/29.
//

#import "QPFundTableView.h"
#import "QPFundCell.h"

static NSString *identifier = @"cellID";

@interface QPFundTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation QPFundTableView

- (void)setFundDataList:(NSMutableArray<QPFundCellFrame *> *)fundDataList {
    _fundDataList = fundDataList;
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[QPFundCell class] forCellReuseIdentifier:identifier];
        
    }
    return self;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fundDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QPFundCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QPFundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    QPFundCellFrame *cellFrame = self.fundDataList[indexPath.row];
    cell.cellFrame = cellFrame;
    __weak typeof(self) weakSelf = self;
    cell.endEditingBlock = ^(QPFundModel * _Nonnull fund) {
        __strong typeof(self) strongSelf = weakSelf;
        
        if (strongSelf.endEditingBlock) {
            QPFundCellFrame *newCellFrame = [[QPFundCellFrame alloc] initWithFund:fund];
            strongSelf.endEditingBlock(newCellFrame, indexPath);
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.selectBlock) {
        self.selectBlock(self.fundDataList[indexPath.row], indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QPFundCellFrame *cellFrame = self.fundDataList[indexPath.row];
    return cellFrame.cellH;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        if (self.deleteBlock) {
            self.deleteBlock(self.fundDataList[indexPath.row], indexPath);
        }
    }];
    action.backgroundColor = kRedColor;
    
    NSArray *actions = [NSArray arrayWithObjects:action, nil];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:actions];
    return config;
}

@end
