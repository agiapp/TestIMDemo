//
//  BRChatCell.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/25.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRChatCell.h"

@implementation BRChatCell

- (CGFloat)cellHeight {
    // 刷新布局，重新布局子控件
    [self layoutIfNeeded];
    return 15 + self.messageLabel.bounds.size.height + 15;
}

@end
