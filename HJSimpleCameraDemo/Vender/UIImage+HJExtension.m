//
//  UIImage+UIImage_HJExtension.m
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16/1/27.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "UIImage+HJExtension.h"

@implementation UIImage (HJExtension)
+(UIImage*) imagesNamedFromCustomBundle:(NSString *)name
{
    NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"whj.bundle/images"];
    NSString *image_path = [main_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:image_path];
}
@end
