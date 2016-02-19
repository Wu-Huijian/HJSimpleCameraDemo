//
//  ViewController.m
//  HJSimpleCameraDemo
//
//  Created by WHJ on 16/1/27.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "ViewController.h"
#import "HJCaptureCameraController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //打开相机按钮
    UIButton *openCameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [openCameraBtn setTitle:@"Open Camera" forState:UIControlStateNormal];
    [openCameraBtn addTarget:self action:@selector(openCameraBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    openCameraBtn.backgroundColor = [UIColor greenColor];
    openCameraBtn.center = self.view.center;
    openCameraBtn.layer.cornerRadius = openCameraBtn.width/2.f;
    openCameraBtn.layer.borderWidth = 2.f;
    openCameraBtn.layer.borderColor = [UIColor grayColor].CGColor;
    openCameraBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:openCameraBtn];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - Taget Action
-(void)openCameraBtnPressed:(id)sender{
    //打开相机
    HJCaptureCameraController *captureCameraVC = [[HJCaptureCameraController alloc]init];
    [self.navigationController pushViewController:captureCameraVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
