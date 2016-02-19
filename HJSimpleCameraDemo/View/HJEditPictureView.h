//
//  HJEditPictureView.h
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16/1/22.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HJDrawRectView;
@interface HJEditPictureView : UIView
@property (nonatomic ,strong)UIImageView *bgImgView;
@property (nonatomic ,strong)HJDrawRectView *drawRectView;
@property (nonatomic ,strong)UIImage *cutImage;
-(instancetype)initWithFrame:(CGRect)frame andImg:(UIImage *)image;
@end
