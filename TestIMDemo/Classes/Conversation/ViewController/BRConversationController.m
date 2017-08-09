//
//  BRConversationController.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/21.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRConversationController.h"
#import "BRChatViewController.h"

@interface BRConversationController ()<EMClientDelegate, EMContactManagerDelegate, EMChatManagerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation BRConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置代理(添加了代理，下面实现的对应代理方法都会被调用！)
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    // 注册好友回调
#warning 在哪个控制器里监听好友同意或拒绝的状态比较好？ 监听好友代理放在【会话】控制器里比较好，也可以放在AppDelegate里。会话控制器在程序一打开就被初始化，都可以保证随时监听，全局都可以收到回调消息。
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    [self loadData];
}

- (void)loadData {
    // 获取所有历史会话记录，如果内存中不存在会从DB中加载
    NSArray *dataArr = [[EMClient sharedClient].chatManager getAllConversations];
    [self.dataArr addObjectsFromArray:dataArr];
    [self.tableView reloadData];
    // 显示总的未读数
    [self showTabBarBadge];
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

#pragma mark - EMChatManagerDelegate 会话列表发生变化(多了一条会话记录)
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    NSLog(@"会话列表发生变化");
    [self.dataArr removeAllObjects];
    for (EMConversation *conversationModel in aConversationList) {
        [self.dataArr addObject:conversationModel];
    }
    [self.tableView reloadData];
    // 显示总的未读数
    [self showTabBarBadge];
}

// 收到消息(这里应该是要监听 消息未读数发生改变时，执行的回调)
- (void)messagesDidReceive:(NSArray *)aMessages {
    NSLog(@"收到新消息，刷新消息未读数");
    // 更新表格
    [self.tableView reloadData];
    // 显示总的未读数
    [self showTabBarBadge];
}

#pragma mark - 显示总的未读数
- (void)showTabBarBadge {
    // 遍历所有的会话记录，将未读取的消息进行累加
    NSInteger totalUnreadCount = 0;
    for (EMConversation *conversationModel in self.dataArr) {
        totalUnreadCount += conversationModel.unreadMessagesCount;
    }
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", totalUnreadCount];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    EMConversation *conversationModel = self.dataArr[indexPath.row];
    EMMessage *msgModel = conversationModel.latestMessage;
    if (msgModel.direction == EMMessageDirectionReceive) {
        cell.textLabel.text = msgModel.from;
    } else {
        cell.textLabel.text = msgModel.to;
    }
    EMMessageBody *msgBody = msgModel.body;
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            EMTextMessageBody *textMsgBody = (EMTextMessageBody *)msgBody;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ --- 未读数：%d", textMsgBody.text, conversationModel.unreadMessagesCount];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            EMVoiceMessageBody *voiceMsgBody = (EMVoiceMessageBody *)msgBody;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ --- 未读数：%d", voiceMsgBody.displayName, conversationModel.unreadMessagesCount];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            EMImageMessageBody *imageMsgBody = (EMImageMessageBody *)msgBody;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ --- 未读数：%d", imageMsgBody.displayName, conversationModel.unreadMessagesCount];
        }
            break;
        
        default:
            cell.detailTextLabel.text = @"未知的消息类型";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取 Main.storyboard 中 聊天界面控制器
    BRChatViewController *chatVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"chatPageID"];
    EMConversation *conversationModel = self.dataArr[indexPath.row];
    EMMessage *msgModel = conversationModel.latestMessage;
    if (msgModel.direction == EMMessageDirectionReceive) {
        chatVC.contactUsername = msgModel.from;
    } else {
        chatVC.contactUsername = msgModel.to;
    }
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

- (void)dealloc {
    // 移除代理（有添加就有移除）
    [[EMClient sharedClient] removeDelegate:self];
    // 移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

@end
