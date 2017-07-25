//
//  UIViewController+Alert.h
//  TestIMDemo
//
//  Created by 任波 on 2017/7/25.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)
/** 提示弹窗 */
- (void)showAlertWithTitle:(NSString *)title buttonTitle:(NSArray *)titleArr sureHandler:(void (^)())sureHandler cancelHandler:(void (^)())cancelHandler;

@end
