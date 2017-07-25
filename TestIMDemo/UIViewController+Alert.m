//
//  UIViewController+Alert.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/25.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)
#pragma mark - 提示弹窗
- (void)showAlertWithTitle:(NSString *)title buttonTitle:(NSArray *)titleArr sureHandler:(void (^)())sureHandler cancelHandler:(void (^)())cancelHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:titleArr[0] style:UIAlertActionStyleDefault handler:sureHandler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:titleArr[1] style:UIAlertActionStyleDefault handler:cancelHandler];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
