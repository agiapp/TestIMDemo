//
//  CALayer+LayerColor.m
//  TestIMDemo
//
//  Created by 任波 on 2017/7/26.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

@end
