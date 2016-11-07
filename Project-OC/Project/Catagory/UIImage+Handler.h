//
//  UIImage+Handler.h
//  Project
//
//  Created by Chausson on 16/8/11.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Handler)
+ (UIImage *)ch_imageName:(NSString *)name isCache:(BOOL)cache;

- (UIImage *)ch_blurredImage;
// 缩放图片大小
- (UIImage *)ch_scaleToSize:(CGSize)size;
@end
