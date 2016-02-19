//
//  SCCaptureCameraController.m
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16-1-16.
//  Copyright (c) 2016年 WHJ. All rights reserved.
//

#import "HJCaptureCameraController.h"
#import "HJCommon.h"
#import "HJEditPictureView.h"
#import "HJEditPicViewController.h"


#define SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE      0   //对焦框是否一直闪到对焦完成

#define SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA   1   //没有拍照功能的设备，是否给一张默认图片体验一下

//对焦
#define ADJUSTINT_FOCUS @"adjustingFocus"
#define LOW_ALPHA   0.7f
#define HIGH_ALPHA  1.0f


@interface HJCaptureCameraController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    int alphaTimes;
    CGPoint currTouchPoint;
}

@property (nonatomic, strong) HJCaptureSessionManager *captureManager;

@property (nonatomic, strong) NSMutableSet *cameraBtnSet;

//对焦
@property (nonatomic, strong) UIImageView *focusImageView;

@property (nonatomic, strong) UILabel *tipLabel;//提示信息

@end

@implementation HJCaptureCameraController

#pragma mark -------------life cycle---------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        alphaTimes = -1;
        currTouchPoint = CGPointZero;
        
        _cameraBtnSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    //session manager
    HJCaptureSessionManager *manager = [[HJCaptureSessionManager alloc] init];
    
    //AvcaptureManager
    if (CGRectEqualToRect(_previewRect, CGRectZero)) {
        self.previewRect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    [manager configureWithParentLayer:self.view previewRect:_previewRect];
    self.captureManager = manager;
    //设置默认闪光灯模式
    [self setDefaultFlashMode:AVCaptureFlashModeOff];
    //添加菜单按钮
    [self addMenuViewButtons];
    
    [self addFocusView];
    //显示网格线
    [_captureManager switchGrid:YES];
    
    [_captureManager.session startRunning];
    
    
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"该设备不支持相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
#endif
    //一秒后旋转 button 和 label
    [self performSelector:@selector(changeOrientation) withObject:nil afterDelay:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device removeObserver:self forKeyPath:ADJUSTINT_FOCUS context:nil];
    }
#endif
    
    self.captureManager = nil;
}



//拍照菜单栏上的按钮
- (void)addMenuViewButtons {

    
    //拍照按钮
    CGFloat cameraBtnLength = 134/2.f;
    UIButton *takePicBtn = [self buildButton:CGRectMake((ScreenWidth - cameraBtnLength) / 2,ScreenHeight- 30/2.f-cameraBtnLength , cameraBtnLength, cameraBtnLength)
                                normalImgStr:@"netScan_camera"
                             highlightImgStr:@"netScan_camera"
                              selectedImgStr:@"netScan_camera"
                                      action:@selector(takePictureBtnPressed:)
                                  parentView:self.view];
    takePicBtn.backgroundColor = [UIColor greenColor];
    takePicBtn.showsTouchWhenHighlighted = NO;
    takePicBtn.alpha = 1;

    //闪光灯按钮
    [self buildButton:CGRectMake(20, 20, 40, 40)
                              normalImgStr:@"netScan_light_off"
                           highlightImgStr:@""
                            selectedImgStr:@""
                                action:NSSelectorFromString(@"flashBtnPressed:")
                                parentView:self.view];
    
    //相册
    [self buildButton:CGRectMake(20,ScreenHeight-58/2.f-40, 40, 40)
                              normalImgStr:@"netScan_album"
                           highlightImgStr:@"netScan_album"
                            selectedImgStr:@"netScan_album"
                                    action:NSSelectorFromString(@"albumBtnPressed:")
                                parentView:self.view];

    //关闭
   [self buildButton:CGRectMake(ScreenWidth-20-40,ScreenHeight-58/2.f-40, 40, 40)
                                  normalImgStr:@"netScan_close"
                               highlightImgStr:@"netScan_close"
                                selectedImgStr:@"netScan_close"
                                        action:NSSelectorFromString(@"dismissBtnPressed:")
                                    parentView:self.view];
    //网格线按钮
  [self buildButton:CGRectMake(ScreenWidth-20-40, 20, 40, 40)
                                normalImgStr:@"camera_line"
                                highlightImgStr:@"camera_line"
                                selectedImgStr:@"camera_line"
                                action:NSSelectorFromString(@"switchGridBtnPressed:")
                                parentView:self.view].selected = YES;

   
                    
    //提示信息
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.tipLabel.center = self.view.center;
    [self.view addSubview:self.tipLabel];
    self.tipLabel.numberOfLines = 2;
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = [UIFont systemFontOfSize:15];
    self.tipLabel.text = @"横屏拍摄\n文字尽量与参考线平行";
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_tipLabel.text];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    [paraStyle setLineSpacing:6];
    paraStyle.alignment = NSTextAlignmentCenter;
    [attStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0,[_tipLabel.text length])];
    _tipLabel.attributedText = attStr;

}

- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
                  action:(SEL)action
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imagesNamedFromCustomBundle:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imagesNamedFromCustomBundle:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imagesNamedFromCustomBundle:selectedImgStr] forState:UIControlStateSelected];
    }
    
   
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    //样式设置
    btn.layer.cornerRadius = btn.width/2.f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.3;
    btn.showsTouchWhenHighlighted = YES;
    [parentView addSubview:btn];
    [_cameraBtnSet addObject:btn];
    return btn;
}

//对焦的框
- (void)addFocusView {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imagesNamedFromCustomBundle:@"touch_focus_x.png"]];
    imgView.alpha = 0;
    [self.view addSubview:imgView];
    self.focusImageView = imgView;
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
#endif
}

//设置默认闪光模式
-(void)setDefaultFlashMode:(AVCaptureFlashMode)flashMode{

    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (!captureDeviceClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasFlash]) {
        device.flashMode = flashMode;
    }
}

//

#pragma mark -------------touch to focus---------------
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
//监听对焦是否完成了
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        //        WLog(@"Is adjusting focus? %@", isAdjustingFocus ? @"YES" : @"NO" );
        //        WLog(@"Change dictionary: %@", change);
        if (!isAdjustingFocus) {
            alphaTimes = -1;
        }
    }
}

- (void)showFocusInPoint:(CGPoint)touchPoint {
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        int alphaNum = (alphaTimes % 2 == 0 ? HIGH_ALPHA : LOW_ALPHA);
        self.focusImageView.alpha = alphaNum;
        alphaTimes++;
        
    } completion:^(BOOL finished) {
        
        if (alphaTimes != -1) {
            [self showFocusInPoint:currTouchPoint];
        } else {
            self.focusImageView.alpha = 0.0f;
        }
    }];
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //    [super touchesBegan:touches withEvent:event];
    
    alphaTimes = -1;
    
    UITouch *touch = [touches anyObject];
    currTouchPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(_captureManager.previewLayer.bounds, currTouchPoint) == NO) {
        return;
    }
    
    [_captureManager focusInPoint:currTouchPoint];
    
    //对焦框
    [_focusImageView setCenter:currTouchPoint];
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        _focusImageView.alpha = HIGH_ALPHA;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusInPoint:currTouchPoint];
    }];
#else
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}

#pragma mark -------------targer actions---------------
//拍照页面，拍照按钮
- (void)takePictureBtnPressed:(UIButton*)sender {
#if SWITCH_SHOW_DEFAULT_IMAGE_FOR_NONE_CAMERA
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"该设备不支持相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
        return;
    }
#endif
    
    sender.userInteractionEnabled = NO;
    //loading框
    __block UIActivityIndicatorView *actiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actiView.center = self.view.center;
    [actiView startAnimating];
    [self.view addSubview:actiView];
    
    [_captureManager takePicture:^(UIImage *stillImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [HJCommon saveImageToPhotoAlbum:stillImage];//存至本机
        });
        
        [actiView stopAnimating];
        [actiView removeFromSuperview];
        actiView = nil;
        
        double delayInSeconds = 2.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            sender.userInteractionEnabled = YES;
        });
        
    //跳转图片编辑页面
    HJEditPicViewController *con = [[HJEditPicViewController alloc] init];
    con.postImage = stillImage;
    [self.navigationController pushViewController:con animated:YES];
    }];
}


//点击相册按钮
-(void)albumBtnPressed:(id)sender{
    UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imgPickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPickerVC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imgPickerVC.sourceType];
    }
    
    imgPickerVC.delegate = self;
    imgPickerVC.allowsEditing = NO;
    [self presentViewController:imgPickerVC animated:YES completion:nil];
}


-(void)switchGridBtnPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    [_captureManager switchGrid:sender.selected];
}

//拍照页面，"X"按钮
- (void)dismissBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//拍照页面，闪光灯按钮
- (void)flashBtnPressed:(UIButton*)sender {
    [_captureManager switchFlashMode:sender];
}



/**
 *  改变方向
 */
- (void)changeOrientation{
    
    if (!_cameraBtnSet || _cameraBtnSet.count <= 0) {
        return;
    }
    [_cameraBtnSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UIButton *btn = ([obj isKindOfClass:[UIButton class]] ? (UIButton*)obj : nil);
        if (!btn) {
            *stop = YES;
            return ;
        }
        
        btn.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _tipLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
        [UIView animateWithDuration:0.3f animations:^{
            btn.transform = transform;
            _tipLabel.transform = transform;
        }];
    }];
}


- (BOOL)shouldAutorotate
{

    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}


#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
 
    
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //获取图片后的操作
    HJEditPicViewController *editVC = [[HJEditPicViewController alloc]init];
    editVC.postImage = image;
    [self.navigationController pushViewController:editVC animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}
@end
