//
//  NSDate+BRAdd.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/28.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "NSDate+BRAdd.h"

@implementation NSDate (BRAdd)
#pragma mark - 获取系统当前的时间戳，即当前时间距1970的秒数（以毫秒为单位）
+ (NSString *)currentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    /** 当前时间距1970的秒数。*1000 是精确到毫秒，不乘就是精确到秒 */
    NSTimeInterval interval = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];
    
    return timeString;
}

#pragma mark - 获取当前的时间
+ (NSString *)currentDateString {
    return [self currentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - 按指定格式获取当前的时间
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr {
    // 获取系统当前时间
    NSDate *currentDate = [NSDate date];
    // 用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    formatter.dateFormat = formatterStr;
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    // 输出currentDateStr
    return currentDateStr;
}

#pragma mark - 获取聊天消息时间
+ (NSString *)chatTime:(long long)timestamp {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 1.获取当前时间的年、月、日
    NSDate *currentData = [NSDate date];
    NSDateComponents *currentComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentData];
    NSInteger currentYear = currentComponents.year;
    NSInteger currentMonth = currentComponents.month;
    NSInteger currentDay = currentComponents.day;
    
    // 2.获取消息发送时间的年、月、日
    NSDate *msgData = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    NSDateComponents *msgComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:msgData];
    NSInteger msgYear = msgComponents.year;
    NSInteger msgMonth = msgComponents.month;
    NSInteger msgDay = msgComponents.day;
    // 格式化
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) { //今天
        formatter.dateFormat = @"  HH:mm  ";
    } else if (currentYear == msgYear && currentMonth == msgMonth && (currentDay - 1) == msgDay) { //昨天
        formatter.dateFormat = @"  昨天 HH:mm  ";
    } else { //昨天以前
        formatter.dateFormat = @"  yyyy年M月dd日 HH:mm  ";
    }
    
    return [formatter stringFromDate:msgData];
}

@end
