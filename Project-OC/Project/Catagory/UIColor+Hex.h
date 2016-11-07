//
//  UIColor+Hex.h
//  PhotoBook
//
//  Created by artisan on 15-1-8.
//  Copyright (c) 2015年 Logictech . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString: (NSString *)color;
+ (UIColor *)colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;
@end
