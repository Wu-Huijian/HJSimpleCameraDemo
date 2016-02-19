//
//  HJEditPictureView.m
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16/1/22.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJEditPictureView.h"
#import "HJDrawRectView.h"
@implementation HJEditPictureView


-(instancetype)initWithFrame:(CGRect)frame andImg:(UIImage *)image{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        self.bgImgView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.bgImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.bgImgView];
        self.bgImgView.image = image;
        self.bgImgView.clipsToBounds = YES;
        
        self.drawRectView = [[HJDrawRectView alloc]initWithFrame:self.bounds];
        [self addSubview:self.drawRectView];
    }
    return self;
}


-(UIImage *)cutImage{
    CGRect rect = [self.drawRectView getCutRect];//这里可以设置想要截图的区域
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bgImgView.width, self.bgImgView.height), YES, 1);     //设置截屏大小
    [self.bgImgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    //这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    _cutImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    return _cutImage;
}


@end
