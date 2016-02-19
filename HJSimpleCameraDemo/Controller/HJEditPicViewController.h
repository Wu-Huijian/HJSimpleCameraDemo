//
//  PostViewController.h
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16-1-21.
//  Copyright (c) 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HJEditPictureView;

@interface HJEditPicViewController : UIViewController

@property (nonatomic, strong) UIImage *postImage;
@property (nonatomic ,strong)HJEditPictureView *editPicView;

@property (nonatomic ,strong)UIButton *confirmBtn;
@property (nonatomic ,strong)UIButton *backBtn;
@property (nonatomic ,strong)UIImage *currentImage;
@end
