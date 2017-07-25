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

@end

@implementation BRChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听键盘的弹出(显示)，更改toolBar底部的约束（将工具条往上移，防止被键盘挡住）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowToAction:) name:UIKeyboardWillShowNotification object:nil];
    
    // 监听键盘的退出(隐藏)，工具条恢复原位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideToAction:) name:UIKeyboardWillHideNotification object:nil];
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
        // 立即刷新布局
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"leftCell";
    BRChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.messageLabel.text = @"sdbjhjasajcjcjcbjadbcjacjacacddas czaixnianxxnainxi";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
