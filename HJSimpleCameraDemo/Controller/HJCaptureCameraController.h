//
//  SCCaptureCameraController.h
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16-1-16.
//  Copyright (c) 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCaptureSessionManager.h"

@interface HJCaptureCameraController : UIViewController

@property (nonatomic, assign) CGRect previewRect;
@property (nonatomic, assign) BOOL isStatusBarHiddenBeforeShowCamera;


@end
