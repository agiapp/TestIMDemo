//
//  BRChatCell.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/25.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRChatCell.h"
#import "BRVoicePlayTool.h"

@implementation BRChatCell

#pragma mark - 在此方法中做一些初始化操作
- (void)awakeFromNib {
    [super awakeFromNib];
    // 给label添加tap手势
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapMessageLabel:)];
    [self.messageLabel addGestureRecognizer:myTap];
}

#pragma mark - label的点击事件
- (void)didTapMessageLabel:(UITapGestureRecognizer *)sender {
    EMMessageBody *voiceBody = self.messageModel.body;
    if (voiceBody.type == EMMessageBodyTypeVoice) {
        NSLog(@"播放语音");
        [BRVoicePlayTool playWithMessage:self.messageModel];
    }
}

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
            // 音频消息
            EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)msgBody;
            self.messageLabel.attributedText = [self voiceAttrText:voiceBody.duration];
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

#pragma mark - 返回语音的富文本
- (NSAttributedString *)voiceAttrText:(int)duration {
    // 空格个数，控制语音消息的显示长度
    NSString *spacingText = @"";
    NSInteger length = MIN(duration, 50) / 2;
    for (NSInteger i = 0; i < length; i++) {
        spacingText = [spacingText stringByAppendingString:@" "];
    }
    
    // 1.创建一个可变的富文本
    NSMutableAttributedString *voiceAttr = [[NSMutableAttributedString alloc]init];
    if ([self.reuseIdentifier isEqualToString:@"leftCell"]) {
        // 接收方（左边）：富文本 = 图片 + 时间
        // 创建图片附件
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        imageAttachment.image = [UIImage imageNamed:@"chat_receiver_audio_playing_full"];
        // y 为负数，把文字往上调
        imageAttachment.bounds = CGRectMake(0, -6, 20, 20);
        // 1.1 创建图片富文本
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [voiceAttr appendAttributedString:imageAttr];
        
        // 1.2 创建时间富文本
        NSString *timeStr = [NSString stringWithFormat:@"%@ %d'", spacingText, duration];
        NSMutableAttributedString *timeAttr = [[NSMutableAttributedString alloc]initWithString:timeStr];
        //富文本样式
        [timeAttr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, timeStr.length)];
        [timeAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, timeStr.length)];
        
        [voiceAttr appendAttributedString:timeAttr];
        
    } else {
        // 发送方（右边）：富文本 = 时间 + 图片
        // 2.1 创建时间富文本
        NSString *timeStr = [NSString stringWithFormat:@"%d' %@", duration, spacingText];
        NSMutableAttributedString *timeAttr = [[NSMutableAttributedString alloc]initWithString:timeStr];
        [timeAttr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, timeStr.length)];
        [timeAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, timeStr.length)];
        [voiceAttr appendAttributedString:timeAttr];
        // 创建图片附件
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        imageAttachment.image = [UIImage imageNamed:@"chat_sender_audio_playing_full"];
        imageAttachment.bounds = CGRectMake(0, -6, 20, 20);
        // 2.2 创建图片富文本
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [voiceAttr appendAttributedString:imageAttr];
    }
    
    return [voiceAttr copy];
}

- (CGFloat)cellHeight {
    // 刷新布局，重新布局子控件
    [self layoutIfNeeded];
    return 15 + self.messageLabel.bounds.size.height + 15;
}

@end
