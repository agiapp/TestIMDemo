//
//  BRChatViewController.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/25.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRChatViewController.h"
#import "BRChatCell.h"

@interface BRChatViewController ()<UITableViewDataSource, UITableViewDelegate>
/** 输入toolBar底部的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomLayoutConstraint;
// 用这个cell对象来计算cell的高度
@property (nonatomic, strong) BRChatCell *chatCellTool;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation BRChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听键盘的弹出(显示)，更改toolBar底部的约束（将工具条往上移，防止被键盘挡住）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowToAction:) name:UIKeyboardWillShowNotification object:nil];
    
    // 监听键盘的退出(隐藏)，工具条恢复原位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideToAction:) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadData];
}

- (void)loadData {
    self.dataArr = @[@"监听键盘的弹出显示，更改toolBar底部的约束将工具条往上移，防止被键盘挡住", @"监听键盘的弹出显示，更改toolBar底部的约束将工具条往上移，防止被键盘挡住 监听键盘的弹出显示，更改toolBar底部的约束将工具条往上移，防止被键盘挡住", @"监听键盘的弹出显示", @"你好啊", @"监听键盘的弹出显示，更改toolBar底部的约束将工具条往上移，防止被键盘挡住监听键盘的弹出显示，更改toolBar底部的约束将工具条往上移，防止被键盘挡住,监听键盘的弹出显示，更改toolBar底部的约束将工具条往上移，防止被键盘挡住", @"监听键盘的弹出显示，更改toolBar底部的约束将工具条往上移，防止被键盘挡住"];
}

#pragma mark - 键盘显示时会触发的方法
- (void)keyboardWillShowToAction:(NSNotification *)sender {
    // 1.获取键盘的高度
    // 1.1 获取键盘弹出结束时的位置
    CGRect endFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = endFrame.size.height;
    // 2.更改工具条底部的约束
    self.toolBarBottomLayoutConstraint.constant = keyboardHeight;
    // 添加动画：保证键盘的弹出和工具条的上移 同步
    [UIView animateWithDuration:0.2 animations:^{
        // 刷新布局，重新布局子控件
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 键盘隐藏时会触发的方法
- (void)keyboardWillHideToAction:(NSNotification *)sender {
    // 工具条恢复原位
    self.toolBarBottomLayoutConstraint.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = nil;
    if (indexPath.row % 2 == 0) {
        cellID = @"rightCell";
    } else {
        cellID = @"leftCell";
    }
    BRChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.messageLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击tableView隐藏键盘
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 随便获取一个cell对象（目的是拿到一个模块装入数据，计算出高度）
    self.chatCellTool = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
    // 给label赋值
    self.chatCellTool.messageLabel.text = self.dataArr[indexPath.row];
    return [self.chatCellTool cellHeight];
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
