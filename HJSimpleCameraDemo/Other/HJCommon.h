//
//  HJCommon.h
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16-1-24.
//  Copyright (c) 2016年 WHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJCommon : NSObject


+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize;

+ (void)drawALineWithFrame:(CGRect)frame andColor:(UIColor*)color inLayer:(CALayer*)parentLayer;

+ (void)saveImageToPhotoAlbum:(UIImage*)image;

@end
