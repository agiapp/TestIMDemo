//
//  BRChatCell.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/25.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRChatCell.h"
#import "BRVoicePlayTool.h"
#import "BRAttributedText.h"
#import "UIImageView+WebCache.h"

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
        [BRVoicePlayTool playWithMessage:self.messageModel msgLabel:self.messageLabel];
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
            EMImageMessageBody *imageMsgBody = (EMImageMessageBody *)msgBody;
            [self showImage:imageMsgBody];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            // 音频消息
            EMVoiceMessageBody *voiceMsgBody = (EMVoiceMessageBody *)msgBody;
            self.messageLabel.attributedText = [BRAttributedText voiceAttrText:messageModel isPlaying:NO];
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            // 视频消息
            EMVideoMessageBody *videoMsgBody = (EMVideoMessageBody *)msgBody;
            self.messageLabel.text = @"【视频消息】";
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            // 位置消息
            EMLocationMessageBody *locationMsgBody = (EMLocationMessageBody *)msgBody;
            self.messageLabel.text = @"【位置消息】";
        }
            break;
        case EMMessageBodyTypeFile:
        {
            // 文件消息
            EMFileMessageBody *fileMsgBody = (EMFileMessageBody *)msgBody;
            self.messageLabel.text = @"【文件消息】";
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 显示图片
- (void)showImage:(EMImageMessageBody *)imageMsgBody {
    CGRect thumbFrame = (CGRect){0, 0, imageMsgBody.thumbnailSize};
    // 设置label的尺寸足够显示UIImageView
    // 图片附件
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc]init];
    imageAttachment.bounds = thumbFrame;
    NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    self.messageLabel.attributedText = attributedString;
    
    // 1. 在cell的Label上添加UIImageView
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = thumbFrame;
    imageView.backgroundColor = [UIColor redColor];
    [self.messageLabel addSubview:imageView];
    
    // 下载图片
    NSLog(@"缩略图remote路径：%@", imageMsgBody.thumbnailRemotePath);
    NSLog(@"缩略图local路径：%@", imageMsgBody.thumbnailLocalPath);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 如果本地图片存在，直接从本地显示图片
    if ([manager fileExistsAtPath:imageMsgBody.thumbnailLocalPath]) {
        [imageView sd_setImageWithURL:[NSURL fileURLWithPath:imageMsgBody.thumbnailLocalPath] placeholderImage:[UIImage imageNamed:@"default.png"]];
    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageMsgBody.thumbnailRemotePath] placeholderImage:[UIImage imageNamed:@"default.png"]];
    }
}

- (CGFloat)cellHeight {
    // 刷新布局，重新布局子控件
    [self layoutIfNeeded];
    return 15 + self.messageLabel.bounds.size.height + 15;
}

@end
