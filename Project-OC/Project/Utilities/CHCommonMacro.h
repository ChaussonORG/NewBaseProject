//
//  CHCommonMacro.h
//  Shipping
//
//  Created by Chausson on 16/5/23.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef CHCommonMacro_h
#define CHCommonMacro_h

/* 动态计算字体宽高的宏 */
#define CH_TRANSFORM_TEXTSIZE(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
/* 计算文字高度宽度 */
#define CHSCREEN_IPHONE_4 [UIScreen mainScreen].bouxnds.size.width == 480
#define CHSCREEN_IPHONE_5 [UIScreen mainScreen].bounds.size.width == 568
#define CHSCREEN_IPHONE_6 [UIScreen mainScreen].bounds.size.width == 667
#define CHSCREEN_IPHONE_6PLUS [UIScreen mainScreen].bounds.size.width == 736
#define CHSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define CHSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/* 传入64位颜色值转换成UIColor */
#define KUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/* 快速获取xib 
 @param 类的名称
 */
#define NibInitWithName(name) [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([STBottomBackView class]) owner:nil options:nil][0]
/* 废弃初始化方法 ,使用自定义初始化方法*/
#define CH_DEPRECATED_INIT \
- (instancetype)init __attribute__((unavailable("init方法不可用，请用自定义初始化方法")));\
+ (instancetype)new __attribute__((unavailable("new方法不可用，请用自定义初始化方法")));\
- (instancetype)copy __attribute__((unavailable("copy方法不可用，请用自定义初始化方法")));\

#define __WEAK_SELF_CHSLIDE     __weak typeof(self) weakSelf = self;
#define __STRONG_SELF_CHSLIDE   __strong typeof(weakSelf) strongSelf = weakSelf;
#endif /* CHCommonMacro_h */
