//
//  BRVoicePlayTool.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/28.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRVoicePlayTool.h"
#import "EMCDDeviceManager.h"
#import "BRAttributedText.h"

/** 正在执行动画的ImageView */
static UIImageView *animatingImageView;

@implementation BRVoicePlayTool

#pragma mark - 播放语音
+ (void)playWithMessage:(EMMessage *)message msgLabel:(UILabel *)msgLabel {
    // 进入这个方法前，先把以前的播放动画移除
    // 移除ImageView动画
    [animatingImageView stopAnimating];
    [animatingImageView removeFromSuperview];
    
    msgLabel.attributedText = [BRAttributedText voiceAttrText:message isPlaying:YES];
    
    // 1.播放语音
    EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)message.body;
    // 1.1 本地语音文件路径
    NSString *voicePath = voiceBody.localPath;
    // 1.2 如果本地语音文件不存在，就使用服务的语音
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:voicePath]) {
        voicePath = voiceBody.remotePath;
    }
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:voicePath completion:^(NSError *error) {
        if (!error) {
            NSLog(@"语音播放完成！");
            // 移除ImageView动画
            [animatingImageView stopAnimating];
            [animatingImageView removeFromSuperview];
            
            msgLabel.attributedText = [BRAttributedText voiceAttrText:message isPlaying:NO];
        } else {
            NSLog(@"语音播放失败：%@", error);
        }
    }];
    
    // 2.添加播放动画
    // 2.1 创建一个imageView添加到label上
    UIImageView *imageView = [[UIImageView alloc]init];
    [msgLabel addSubview:imageView];
    // 2.2 给imageView添加动画图片
    if (message.direction == EMMessageDirectionReceive) { // 接收方（对方、左边的消息）
        imageView.frame = CGRectMake(0, 0, 20, 20);
        imageView.animationImages = @[[UIImage imageNamed:@"chat_receiver_audio_playing000"],
                                      [UIImage imageNamed:@"chat_receiver_audio_playing001"],
                                      [UIImage imageNamed:@"chat_receiver_audio_playing002"],
                                      [UIImage imageNamed:@"chat_receiver_audio_playing003"]];
    } else { // 发送方（自己、右边的消息）
        imageView.frame = CGRectMake(msgLabel.bounds.size.width - 20, 0, 20, 20);
        imageView.animationImages = @[[UIImage imageNamed:@"chat_sender_audio_playing_000"],
                                      [UIImage imageNamed:@"chat_sender_audio_playing_001"],
                                      [UIImage imageNamed:@"chat_sender_audio_playing_002"],
                                      [UIImage imageNamed:@"chat_sender_audio_playing_003"]];
    }
    // 动画时间
    imageView.animationDuration = 1.5;
    // 执行动画
    [imageView startAnimating];
    animatingImageView = imageView;
    
}


@end
