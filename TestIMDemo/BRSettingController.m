//
//  BRSettingController.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/25.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRSettingController.h"

@interface BRSettingController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation BRSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = [NSString stringWithFormat:@"退出登录（%@）", [EMClient sharedClient].currentUsername];
    [self.logoutBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - 退出登录
- (IBAction)clickLogoutBtn:(id)sender {
    NSLog(@"退出登录");
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        if (!aError) {
            NSLog(@"退出登录成功！");
            self.view.window.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        } else {
            NSLog(@"退出登录失败：%@", aError);
        }
    }];
}

@end
