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
    // 解析普通消息
    EMMessageBody *msgBody = messageModel.body;
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            // 文字消息
            EMTextMessageBody *textMsgBody = (EMTextMessageBody *)msgBody;
            self.messageLabel.text = textMsgBody.text;
        }
            break;
        case EMMessageBodyTypeImage:
        {
            // 图片消息
            EMImageMessageBody *body = (EMImageMessageBody *)msgBody;
            self.messageLabel.text = @"【图片消息】";
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            // 位置消息
            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
            self.messageLabel.text = @"【位置消息】";
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            // 音频sdk会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            self.messageLabel.text = @"【音频消息】";
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            // 视频消息
            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
            self.messageLabel.text = @"【视频消息】";
        }
            break;
        case EMMessageBodyTypeFile:
        {
            // 文件消息
            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
            self.messageLabel.text = @"【文件消息】";
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)cellHeight {
    // 刷新布局，重新布局子控件
    [self layoutIfNeeded];
    return 15 + self.messageLabel.bounds.size.height + 15;
}

@end
