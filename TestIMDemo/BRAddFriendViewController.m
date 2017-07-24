//
//  BRAddFriendViewController.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/24.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRAddFriendViewController.h"

@interface BRAddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BRAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 搜索按钮，添加朋友
- (IBAction)clickAddFriendBtn:(id)sender {
    NSString *friendName = self.textField.text;
    NSString *message = [NSString stringWithFormat:@"我是%@", [EMClient sharedClient].currentUsername];
    // 添加好友请求
    [[EMClient sharedClient].contactManager addContact:friendName message:message completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"邀请发送成功!");
        } else {
            NSLog(@"邀请发送失败：%@", aError);
        }
    }];
}


@end
