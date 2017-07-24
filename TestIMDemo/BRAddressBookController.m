//
//  BRAddressBookController.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/24.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BRAddressBookController.h"

@interface BRAddressBookController ()
@property (nonatomic, strong) NSArray *contactArr;

@end

@implementation BRAddressBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

// 获取好友列表的数据
- (void)loadData {
//    // 方法1：从本地数据库获取所有的好友（通常是没有网络的情况下用这个）
//    self.contactArr = [[EMClient sharedClient].contactManager getContacts];
//    [self.tableView reloadData];
    
    // 方法2：从服务器获取所有的好友  <异步方法>
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            NSLog(@"获取好友列表成功：%@", aList);
            self.contactArr = aList;
            [self.tableView reloadData];
        } else {
            NSLog(@"获取好友失败：%@", aError);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"AddressBookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
    cell.textLabel.text = self.contactArr[indexPath.row];
    
    return cell;
}

- (NSArray *)contactArr {
    if (!_contactArr) {
        _contactArr = [NSArray array];
    }
    return _contactArr;
}

@end