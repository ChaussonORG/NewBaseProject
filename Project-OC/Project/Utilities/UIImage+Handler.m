//
//  UIImage+Handler.m
//  Project
//
//  Created by Chausson on 16/8/11.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "UIImage+Handler.h"

@implementation UIImage (Handler)

+ (UIImage *)ch_imageName:(NSString *)name isCache:(BOOL)cache{
    if (cache) {
        if (![UIImage imageNamed:name]) {
            NSLog(@"%s %d ImageName: %@ Not Found In Bundle",__PRETTY_FUNCTION__,__LINE__,name);
        }
        return [UIImage imageNamed:name];
    }else{
        NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        NSData *data = [NSData dataWithContentsOfFile:file];
        if (file.length > 0 && data) {
            return [UIImage imageWithData:data];
        }else{
            NSLog(@"%s %d ImageName: %@ Not Found In Bundle ,default support png Type and Only just support png for now",__PRETTY_FUNCTION__,__LINE__,name);
            return nil;
            
        }
        
    }
}
- (UIImage *)ch_blurredImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}
- (UIImage *)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
