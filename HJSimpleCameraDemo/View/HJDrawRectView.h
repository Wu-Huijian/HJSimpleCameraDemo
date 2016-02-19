//
//  HJEditPictureView.h
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16/1/21.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 拖动位置 **/
typedef NS_ENUM(NSUInteger,DragPosition){
    //拖动角
    DragPosition_topLeft = 0,
    DragPosition_topRight,
    DragPosition_bottomLeft,
    DragPosition_bottomRight,
    //拖动线
    DragPosition_topBorder,
    DragPosition_leftBorder,
    DragPosition_bottomBorder,
    DragPosition_rightBorder,
    //中间
    DragPosition_inner
};


@interface HJDrawRectView : UIView


@property (nonatomic ,assign)DragPosition dragPosition;

@property (nonatomic ,assign)CGRect boxRect;

@property (nonatomic ,assign)BOOL isDrawLine;

@property (nonatomic ,assign)BOOL isDrawGridLine;

@property (nonatomic ,strong)UIImage *cutImage;


-(CGRect)getCutRect;
@end
