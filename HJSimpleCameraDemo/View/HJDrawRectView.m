//
//  HJEditPictureView.m
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16/1/21.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJDrawRectView.h"

@implementation HJDrawRectView{

//    CGFloat self.originX;
//    CGFloat originY;

    
    CGFloat sizeWidth;
    CGFloat sizeHeight;//获取截图区域
    CGFloat originX;
    CGFloat originY;
    
    CGPoint startPoint;
    CGPoint previousPoint;
    
    UIButton *topLeft;
    UIButton *bottomLeft;
    UIButton *topRight;
    UIButton *bottomRight;
    BOOL notFirstTime;
}



#define imgWidth 32
#define cornerOffset 8

-(instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        [self initZ];
    }
    return self;
}


-(void)initZ{
    self.backgroundColor = [UIColor clearColor];

    originX = 20;
    originY = 45;
    sizeWidth = self.width-2*originX;
    sizeHeight = self.height - 2*originY;
    
    _isDrawLine = YES;
    _isDrawGridLine = YES;
    
    _boxRect = CGRectMake(originX, originY, sizeWidth, sizeHeight);
  
    topLeft = [[UIButton alloc]init];//WithFrame:CGRectMake(originX-1,originY-1 , imgWidth, imgWidth)];
    [topLeft setImage:[UIImage imagesNamedFromCustomBundle:@"netScan_topLeft"] forState:UIControlStateNormal];
    [topLeft setImageEdgeInsets:UIEdgeInsetsMake(imgWidth, imgWidth, 0, 0)];
    topLeft.userInteractionEnabled = NO;
    [self addSubview:topLeft];
    
    topRight = [[UIButton alloc]init];
    [topRight setImage:[UIImage imagesNamedFromCustomBundle:@"netScan_topRight"] forState:UIControlStateNormal];
    [topRight setImageEdgeInsets:UIEdgeInsetsMake(imgWidth, 0, 0, imgWidth)];
    topRight.userInteractionEnabled = NO;

    [self addSubview:topRight];
    
    bottomLeft = [[UIButton alloc]init];
    [bottomLeft setImage:[UIImage imagesNamedFromCustomBundle:@"netScan_bottomLeft"] forState:UIControlStateNormal];
    [bottomLeft setImageEdgeInsets:UIEdgeInsetsMake(0, imgWidth, imgWidth, 0)];
    bottomLeft.userInteractionEnabled = NO;

    [self addSubview:bottomLeft];
    
    bottomRight = [[UIButton alloc]init];
    [bottomRight setImage:[UIImage imagesNamedFromCustomBundle:@"netScan_bottomRight"] forState:UIControlStateNormal];
    [bottomRight setImageEdgeInsets:UIEdgeInsetsMake(0, 0, imgWidth, imgWidth)];
    bottomRight.userInteractionEnabled = NO;

    [self addSubview:bottomRight];
    
    
    [self moveCornerImage];
}


//移动角的图片
-(void)moveCornerImage{

    topLeft.frame = CGRectMake(0,0 , 2*imgWidth, 2*imgWidth);
    topRight.frame = topLeft.bounds;
    bottomLeft.frame = topLeft.bounds;
    bottomRight.frame = topLeft.bounds;

    topLeft.center = CGPointMake(CGRectGetMinX(_boxRect)-cornerOffset, CGRectGetMinY(_boxRect)-cornerOffset);
    topRight.center = CGPointMake(CGRectGetMaxX(_boxRect)+cornerOffset, CGRectGetMinY(_boxRect)-cornerOffset);
    bottomLeft.center = CGPointMake(CGRectGetMinX(_boxRect)-cornerOffset, CGRectGetMaxY(_boxRect)+cornerOffset);
    bottomRight.center = CGPointMake(CGRectGetMaxX(_boxRect)+cornerOffset, CGRectGetMaxY(_boxRect)+cornerOffset);

}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] setFill];
    UIRectFill(self.bounds);
    //画边框
       if(_isDrawLine){
        [self drawBorderRect:context];
        //画九宫格
        if (_isDrawGridLine) {
           [self drawGride:context];
        }
    }
}



//** 画边框
-(void)drawBorderRect:(CGContextRef)context{
    
    CGContextClearRect(context, _boxRect);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetRGBStrokeColor(context,
                               0, 180/255.f, 89/255.f, 1.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_boxRect];
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}


//** 9宫格
-(void)drawGride:(CGContextRef)context{

    CGContextSetLineWidth(context, 0.5);
    CGContextSetRGBStrokeColor(context,
                               1, 1, 1, 1.0);
    for (int i = 0; i < 4; i++) {
        if (i == 0 || i == 1) {//画横线
            CGFloat SXStartX =originX+(i+1)*sizeWidth/3.f;
            CGFloat HXStartY = originY;
            CGContextMoveToPoint(context, SXStartX, HXStartY);
            CGContextAddLineToPoint(context, SXStartX, HXStartY+sizeHeight);
        } else {
            CGFloat SXStartX =originX;
            CGFloat HXStartY = originY+(i-1)*sizeHeight/3.f;
            CGContextMoveToPoint(context, SXStartX, HXStartY);
            CGContextAddLineToPoint(context, SXStartX+sizeWidth, HXStartY);
        }
    }
    CGContextStrokePath(context);

}

//调用getCutRect方法的时候会取消网格线
-(CGRect)getCutRect{
    _isDrawLine = NO;
    [self setNeedsDisplay];
    [self performSelector:@selector(setIsDrawLine:) withObject:@YES afterDelay:1];
    return _boxRect;
}


//是否画线
-(void)setIsDrawLine:(BOOL)isDrawLine{
    _isDrawLine = isDrawLine;
    if (_isDrawLine) {
        topLeft.hidden = NO;
        topRight.hidden = NO;
        bottomRight.hidden = NO;
        bottomLeft.hidden = NO;
    }else{
        topLeft.hidden = YES;
        topRight.hidden = YES;
        bottomRight.hidden = YES;
        bottomLeft.hidden = YES;
    }
    [self setNeedsDisplay];
}


-(void)setIsDrawGridLine:(BOOL)isDrawGridLine{
    _isDrawGridLine = isDrawGridLine;
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    startPoint = [touch locationInView:self];
    notFirstTime = NO;

}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat offset = 5;
    if(!notFirstTime){
            if (CGRectContainsPoint(topLeft.frame, startPoint)) {
                _dragPosition = DragPosition_topLeft;
                notFirstTime = YES;
            }else if (CGRectContainsPoint(topRight.frame, startPoint)){
                _dragPosition = DragPosition_topRight;
                notFirstTime = YES;
            }else if (CGRectContainsPoint(bottomLeft.frame, startPoint)){
                _dragPosition = DragPosition_bottomLeft;
                notFirstTime = YES;
            }else if (CGRectContainsPoint(bottomRight.frame, startPoint)){
                _dragPosition = DragPosition_bottomRight;
                notFirstTime = YES;
            }else if(CGRectContainsPoint(CGRectMake(originX, originY-offset, sizeWidth, 2*offset), startPoint)){
                
                _dragPosition = DragPosition_topBorder;
                notFirstTime = YES;

            }else if(CGRectContainsPoint(CGRectMake(originX-offset, originY, 2*offset,sizeHeight), startPoint)){
                _dragPosition = DragPosition_leftBorder;
                notFirstTime = YES;

            }else if(CGRectContainsPoint(CGRectMake(originX, originY+sizeHeight-offset, sizeWidth, 2*offset), startPoint)){
                _dragPosition = DragPosition_bottomBorder;
                notFirstTime = YES;
                
            }else if(CGRectContainsPoint(CGRectMake(originX+sizeWidth-offset, originY, 2*offset,sizeHeight), startPoint)){
                _dragPosition = DragPosition_rightBorder;
                notFirstTime = YES;

            }else if (CGRectContainsPoint(_boxRect, startPoint)){
                _dragPosition = DragPosition_inner;
                notFirstTime = YES;
            }
    }else{
        
        switch (_dragPosition) {
            case DragPosition_topLeft:
                originX = point.x;
                originY = point.y;
                sizeWidth = CGRectGetMaxX(_boxRect)-originX;
                sizeHeight = CGRectGetMaxY(_boxRect)-originY;
                break;
            case DragPosition_topRight:
                originY = point.y;
                sizeWidth = point.x-originX;
                sizeHeight = CGRectGetMaxY(_boxRect)-point.y;
                break;
            case DragPosition_bottomLeft:
                originX = point.x;
                sizeWidth = CGRectGetMaxX(_boxRect)-originX;
                sizeHeight = point.y-CGRectGetMinY(_boxRect);
                break;
            case DragPosition_bottomRight:
                sizeWidth = point.x - originX;
                sizeHeight = point.y - originY;
                break;
            case DragPosition_topBorder:
                originY = point.y;
                sizeHeight = CGRectGetMaxY(_boxRect)-originY;
                break;
            case DragPosition_leftBorder:
                originX = point.x;
                sizeWidth = CGRectGetMaxX(_boxRect)-point.x;
                break;
            case DragPosition_bottomBorder:
                sizeHeight = point.y-CGRectGetMinY(_boxRect);
                break;
            case DragPosition_rightBorder:
                sizeWidth = point.x - originX;
                break;
            case DragPosition_inner:
                originX = originX+point.x-previousPoint.x;
                if((originX+sizeWidth)>self.width){
                    originX = self.width - sizeWidth;
                }
                originY = originY+point.y-previousPoint.y;
                if((originY+sizeHeight)>self.height){
                    originY =self.height - sizeHeight;
                }

                break;
            default:
                break;
        }
        
        
        /** 临界值判断 **/
        [self criticalValue];
        
        //刷新界面
        [self refreshUI];
        
    }

    previousPoint = point;
}

-(void)refreshUI{
    _boxRect = CGRectMake(originX, originY, sizeWidth, sizeHeight);
    [self moveCornerImage];
    [self setNeedsDisplay];
}

//临界值判断
-(void)criticalValue{
    /** 最小值判断 **/
    if (sizeWidth>=2*imgWidth && sizeHeight<=2*imgWidth) {
        sizeHeight = 2*imgWidth;
        originY = _boxRect.origin.y;
    }else if (sizeWidth<=2*imgWidth && sizeHeight>=2*imgWidth){
        sizeWidth = 2*imgWidth;
        originX = _boxRect.origin.x;
    }else if (sizeWidth<=2*imgWidth && sizeHeight<=2*imgWidth ){
        sizeWidth = 2*imgWidth;
        sizeHeight = 2*imgWidth;
        originX = _boxRect.origin.x;
        originY = _boxRect.origin.y;
    }else{
        
    }
    
    //最大值判断
    if(originX<=0){
        originX = 0;
    }
    
    if(originY<=0){
        originY = 0;
    }
    
    if((originX+sizeWidth)>=self.width){
        sizeWidth = self.width-originX;
    
    }
    
    if((originY+sizeHeight)>=self.height){
        sizeHeight = self.height-originY;
    }

}



@end
