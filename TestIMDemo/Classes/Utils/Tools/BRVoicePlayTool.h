//
//  BRVoicePlayTool.h
//  TestIMDemo
//
//  Created by 任波 on 2017/7/28.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRVoicePlayTool : NSObject
/** 播放语音 */
+ (void)playWithMessage:(EMMessage *)message msgLabel:(UILabel *)msgLabel;

@end
