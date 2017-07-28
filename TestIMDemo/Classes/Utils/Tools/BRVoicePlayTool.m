//
//  BRVoicePlayTool.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/28.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRVoicePlayTool.h"
#import "EMCDDeviceManager.h"

@implementation BRVoicePlayTool
#pragma mark - 播放语音
+ (void)playWithMessage:(EMMessage *)message {
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
        } else {
            NSLog(@"语音播放失败：%@", error);
        }
    }];
    
    // 2.添加动画
    
}

@end
