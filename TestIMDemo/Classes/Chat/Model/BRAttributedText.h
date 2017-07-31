//
//  BRAttributedText.h
//  TestIMDemo
//
//  Created by 任波 on 2017/7/31.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRAttributedText : NSObject
/** 返回语音的富文本 */
+ (NSAttributedString *)voiceAttrText:(EMMessage *)message isPlaying:(BOOL)isPlaying;

@end
