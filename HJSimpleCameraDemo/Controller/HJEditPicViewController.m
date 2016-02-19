//
//  PostViewController.m
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16-1-21.
//  Copyright (c) 2016年 WHJ. All rights reserved.
//

#import "HJEditPicViewController.h"
#import "HJEditPictureView.h"
#import "HJNSProblemDetailVC.h"
#import "HJDrawRectView.h"
@interface HJEditPicViewController ()

@end

@implementation HJEditPicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self createSubviews];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}


-(void)createSubviews{

    //确定按钮
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.confirmBtn setImage:[UIImage imagesNamedFromCustomBundle:@"cut_confirm"] forState:UIControlStateNormal];
     [self.confirmBtn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.frame = CGRectMake(0, ScreenHeight-72, 134/2.f, 134/2.f);
    self.confirmBtn.centerX = self.view.centerX;
    self.confirmBtn.layer.cornerRadius = self.confirmBtn.width/2.f;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.confirmBtn];
    self.confirmBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    //图片区域
    //修改图片方向
    UIImage *image = [UIImage imageWithCGImage:_postImage.CGImage scale:1 orientation:UIImageOrientationRight];
    self.editPicView = [[HJEditPictureView alloc]initWithFrame:CGRectMake(60/2.f, 30/2.f,ScreenWidth-60, ScreenHeight-self.confirmBtn.height-10-15) andImg:image];
    [self.view addSubview:_editPicView];
    
    //返回
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.backBtn setImage:[UIImage imagesNamedFromCustomBundle:@"cut_back"] forState:UIControlStateNormal];
    self.backBtn.frame = CGRectMake(ScreenWidth-40-20, 0, 80/2.f, 80/2.f);
    self.backBtn.centerY = self.confirmBtn.centerY;
    [self.backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.layer.cornerRadius = self.backBtn.width/2.f;
    self.backBtn.layer.masksToBounds = YES;
    self.backBtn.backgroundColor = [UIColor grayColor];
    self.backBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.backBtn.backgroundColor = [UIColor grayColor];
    self.backBtn.alpha = 0.4;
    [self.view addSubview:_backBtn];
    
    UIButton *gridBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gridBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [gridBtn setImage:[UIImage imagesNamedFromCustomBundle:@"camera_line"] forState:UIControlStateNormal];
    gridBtn.frame = CGRectMake(20, 0, 80/2.f, 80/2.f);
    gridBtn.centerY = self.confirmBtn.centerY;
    [gridBtn addTarget:self action:@selector(gridBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    gridBtn.layer.cornerRadius = self.backBtn.width/2.f;
    gridBtn.layer.masksToBounds = YES;
    gridBtn.backgroundColor = [UIColor grayColor];
    gridBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    gridBtn.backgroundColor = [UIColor grayColor];
    gridBtn.alpha = 0.4;
    gridBtn.selected = YES;
    [self.view addSubview:gridBtn];

}


- (void)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)gridBtnPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.editPicView.drawRectView.isDrawGridLine = sender.selected;
    
}


-(void)confirmBtnPressed:(UIButton *)sender{
    HJNSProblemDetailVC *problemDetailVC = [[HJNSProblemDetailVC alloc]init];
    problemDetailVC.postImage = self.editPicView.cutImage;
    [self.navigationController pushViewController:problemDetailVC animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
