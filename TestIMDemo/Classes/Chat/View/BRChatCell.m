//
//  BRChatCell.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/25.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRChatCell.h"

@implementation BRChatCell

- (void)setMessageModel:(EMMessage *)messageModel {
    _messageModel = messageModel;
    // 获取消息体
    id msgBody = messageModel.body;
    if ([msgBody isKindOfClass:[EMTextMessageBody class]]) { // 文本消息
        EMTextMessageBody *textMsgBody = msgBody;
        self.messageLabel.text = textMsgBody.text;
    } else {
        self.messageLabel.text = @"未知消息类型";
    }
}

- (CGFloat)cellHeight {
    // 刷新布局，重新布局子控件
    [self layoutIfNeeded];
    return 15 + self.messageLabel.bounds.size.height + 15;
}

@end
