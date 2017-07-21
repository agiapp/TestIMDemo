//
//  BRLoginViewController.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/20.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRLoginViewController.h"

@interface BRLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end

@implementation BRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 登录
- (IBAction)clickLoginBtn:(id)sender {
    NSString *username = self.usernameTF.text;
    NSString *password = self.pwdTF.text;
    if (username.length == 0 || password.length == 0) {
        NSLog(@"请输入用户名或密码");
        return;
    }
    
//    // 判断是否设置了自动登录
//    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//    if (!isAutoLogin) {
//        
//    }
    
    // 异步登录方法
    [[EMClient sharedClient] loginWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"登录成功：%@", aUsername);
            NSLog(@"沙盒路径：%@", NSHomeDirectory());
            // 开启自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            // 进入主界面（拿到 Main.storyboard 箭头所指的控制器，即 tabBarController）
            self.view.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        } else {
            NSLog(@"登录失败：%@", aError);
        }
    }];
}

#pragma mark - 注册
- (IBAction)clickRegisterBtn:(id)sender {
    NSString *username = self.usernameTF.text;
    NSString *password = self.pwdTF.text;
    if (username.length == 0 || password.length == 0) {
        NSLog(@"请输入用户名或密码");
        return;
    }
    // 异步注册方法
    [[EMClient sharedClient] registerWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"注册成功：%@", aUsername);
        } else {
            NSLog(@"注册失败：%@", aError);
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
