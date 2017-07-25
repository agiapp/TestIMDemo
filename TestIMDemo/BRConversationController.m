//
//  BRConversationController.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/21.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRConversationController.h"

@interface BRConversationController ()<EMClientDelegate, EMContactManagerDelegate>

@end

@implementation BRConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置代理(添加了代理，下面实现的对应代理方法都会被调用！)
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    // 注册好友回调
#warning 在哪个控制器里监听好友同意或拒绝的状态比较好？ 监听好友代理放在【会话】控制器里比较好，也可以放在AppDelegate里。会话控制器在程序一打开就被初始化，都可以保证随时监听，全局都可以收到回调消息。
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}

#pragma mark - EMClientDelegate
// 监听网络状态（类似于AFNetworking提供的监听网络状态），自动连接
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    if (aConnectionState == EMConnectionDisconnected) {
        NSLog(@"网络断开，未连接...");
        self.navigationItem.title = @"未连接";
    } else {
        NSLog(@"网络通了，已连接...");
        self.navigationItem.title = @"会话";
    }
}

#pragma mark - EMContactManagerDelegate 监听对方有没有接收到我的添加好友请求
// 对方同意我的加好友请求后，会执行这个回调
- (void)friendRequestDidApproveByUser:(NSString *)aUsername {
    NSLog(@"%@同意了我的添加好友请求", aUsername);
    // 。。。通知通讯录更新好友列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContactList" object:nil];
}

// 对方拒绝我的加好友请求后，会执行这个回调
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername {
    NSLog(@"%@拒绝了我的添加好友请求", aUsername);
}

// 接收到好友的添加请求
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage {
    NSLog(@"接收到好友的添加请求");
    NSString *title = [NSString stringWithFormat:@"%@请求添加你为好友，备注：%@", aUsername, aMessage];
    [self showAlertWithTitle:title buttonTitle:@[@"同意", @"拒绝"] sureHandler:^{
        NSLog(@"同意好友添加申请");
        [[EMClient sharedClient].contactManager approveFriendRequestFromUser:aUsername completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                NSLog(@"同意好友成功");
                 // 。。。通知通讯录更新好友列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContactList" object:nil];
            }
        }];
    } cancelHandler:^{
        NSLog(@"拒绝好友添加申请");
        [[EMClient sharedClient].contactManager declineFriendRequestFromUser:aUsername completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                NSLog(@"拒绝好友成功");
            }
        }];
    }];
}

// 监听自己被好友删除
- (void)friendshipDidRemoveByUser:(NSString *)aUsername {
    NSLog(@"%@把我删除了", aUsername);
    // 。。。通知通讯录更新好友列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContactList" object:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    return cell;
}

- (void)dealloc {
    // 移除代理（有添加就有移除）
    [[EMClient sharedClient] removeDelegate:self];
    // 移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
}

@end
