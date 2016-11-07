//
//  CHImageLoader.m
//  Project
//
//  Created by Chausson on 16/7/4.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "CHImageLoader.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation CHImageLoader

+ (void)ch_setImageWithURL:(NSString *)url
                 imageView:(UIImageView *)view{
    
    if (url.length >0 ) {
        
        [view sd_setImageWithURL:[NSURL URLWithString:url]];
        
    }
}
+ (void)ch_setImageWithURL:(NSString *)url
                 imageView:(UIImageView *)view
          placeholderImage:(UIImage *)placeholder{
    if (url.length >0 ) {
        
        [view sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
        
    }
}
+ (void)ch_setImageWithURL:(NSString *)url
                 imageView:(UIImageView *)view
                 completed:(CHImageCompletionBlock)completedBlock{
    if (url.length >0 ) {
        
        [view sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(completedBlock){
                completedBlock(image,error,[imageURL absoluteString]);
            }

        }];
        
    }
}
+ (void)ch_setImageWithURL:(NSString *)url
                 imageView:(UIImageView *)view
          placeholderImage:(UIImage *)placeholder
                 completed:(CHImageCompletionBlock)completedBlock{
    if (url.length >0 ) {
        
        [view sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(completedBlock){
                completedBlock(image,error,[imageURL absoluteString]);
            }
            
        }];
        
    }

}
@end
@implementation UIImage (Blur)
+ (UIImage *)ch_ImageName:(NSString *)name isCache:(BOOL)cache{
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
- (UIImage*)ch_BlurredImage
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

@end
