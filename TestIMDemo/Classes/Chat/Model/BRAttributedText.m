//
//  BRAttributedText.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/31.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRAttributedText.h"

@implementation BRAttributedText
#pragma mark - 返回语音的富文本
+ (NSAttributedString *)voiceAttrText:(EMMessage *)message isPlaying:(BOOL)isPlaying {
    EMVoiceMessageBody *voiceMsgBody = (EMVoiceMessageBody *)message.body;
    int duration = voiceMsgBody.duration;
    // 空格个数，控制语音消息的显示长度
    NSString *spacingText = @"";
    NSInteger length = MIN(duration, 50) / 2;
    for (NSInteger i = 0; i < length; i++) {
        spacingText = [spacingText stringByAppendingString:@" "];
    }
    
    // 1.创建一个可变的富文本
    NSMutableAttributedString *voiceAttr = [[NSMutableAttributedString alloc]init];
    if (message.direction == EMMessageDirectionReceive) {
        // 接收方（左边）：富文本 = 图片 + 时间
        // 创建图片附件
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
        if (!isPlaying) {
            imageAttachment.image = [UIImage imageNamed:@"chat_receiver_audio_playing_full"];
        }
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
        if (!isPlaying) {
            imageAttachment.image = [UIImage imageNamed:@"chat_sender_audio_playing_full"];
        }
        imageAttachment.bounds = CGRectMake(0, -6, 20, 20);
        // 2.2 创建图片富文本
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [voiceAttr appendAttributedString:imageAttr];
    }
    
    return [voiceAttr copy];
}

@end
