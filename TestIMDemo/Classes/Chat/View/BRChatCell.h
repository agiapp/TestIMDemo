//
//  BRChatCell.h
//  TestIMDemo
//
//  Created by 任波 on 2017/7/25.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
/** 消息模型 */
@property (nonatomic, strong) EMMessage *messageModel;

/** 计算cell的高度 */
- (CGFloat)cellHeight;

@end
