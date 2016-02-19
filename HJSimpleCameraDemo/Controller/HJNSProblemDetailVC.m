//
//  HJNetScanViewController.m
//  DailyScan
//
//  Created by WHJ on 16/1/26.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJNSProblemDetailVC.h"

@interface HJNSProblemDetailVC (){
    UIImageView *headImgView;

}

@end

@implementation HJNSProblemDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化配置
    [self initConfig];
    
    headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 200)];
    headImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:headImgView];
    
    //修改图片方向
    UIImage *image = [UIImage imageWithCGImage:_postImage.CGImage scale:1 orientation:UIImageOrientationLeft];
    headImgView.image = image;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

//初始化配置
-(void)initConfig{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
