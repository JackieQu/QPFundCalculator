//
//  QPOptionMaskView.m
//  QPFundCalculator
//
//  Created by JackieQu on 2021/1/5.
//

#import "QPOptionMaskView.h"

@interface QPOptionMaskView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *optionTableView;

@end

@implementation QPOptionMaskView

- (UITableView *)optionTableView {
    if (!_optionTableView) {
        _optionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _optionTableView.delegate = self;
        _optionTableView.dataSource = self;
        _optionTableView.layer.cornerRadius = SCALE(10);
        _optionTableView.layer.masksToBounds = YES;
        _optionTableView.clipsToBounds = YES;
    }
    return _optionTableView;
}

- (void)setOptionDataList:(NSArray<QPOptionModel *> *)optionDataList {
    _optionDataList = optionDataList;
    
    CGFloat maxH = SCALE(360);
    CGFloat height = SCALE(60) * optionDataList.count;
    if (height > maxH) {
        height = maxH;
    }
    self.optionTableView.frame = CGRectMake(0, 0, self.width * 3 / 4, height);
    self.optionTableView.centerX = self.centerX;
    [self.optionTableView reloadData];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.optionTableView.centerY = self.centerY;
    }];
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = kColorSameRGBA(0, 0.5);
        [self addSubview:self.optionTableView];
    }
    return self;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    QPOptionModel *option = self.optionDataList[indexPath.row];
    cell.textLabel.text = option.title;
    cell.textLabel.textColor = option.isSelected ? kWhiteColor : kBlackColor;
    cell.backgroundColor = option.isSelected ? kMainColor : kWhiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    QPOptionModel *selectedOption = self.optionDataList[indexPath.row];
    for (QPOptionModel *option in self.optionDataList) {
        option.isSelected = option.ID == selectedOption.ID;
    }
    
    if (self.selectBlock) {
        QPOptionModel *option = self.optionDataList[indexPath.row];
        self.selectBlock(option, indexPath);
    }
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALE(60);
}

@end
