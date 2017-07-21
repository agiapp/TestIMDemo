//
//  AppDelegate.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/20.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<EMClientDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.初始化环信SDK
    EMOptions *options = [EMOptions optionsWithAppkey:@"1179170720178073#testimdemo"]; // 注册的AppKey
    //options.apnsCertName = @"push_cer"; // 推送证书名（不需要加后缀）
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    // 2.设置自动登录
    // 设置EMClient的代理（添加回调监听代理），监听自动登录的状态
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    // 如果登录过，直接进入主界面
    if ([EMClient sharedClient].isAutoLogin) {
        // 进入主界面（拿到 Main.storyboard 箭头所指的控制器，即 tabBarController）
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    }
    
    return YES;
}

#pragma mark - EMClientDelegate  自动登录的回调（这个代理方法可以知道自动登录是否成功！）
- (void)autoLoginDidCompleteWithError:(EMError *)aError {
    if (!aError) {
        NSLog(@"自动登录成功！");
    } else {
        NSLog(@"自动登录失败：%@", aError);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
