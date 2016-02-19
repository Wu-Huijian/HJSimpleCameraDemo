//
//  HJDefines
//  HJCaptureCameraDemo
//
//  Created by WHJ on 16-1-25.
//  Copyright (c) 2016年 WHJ. All rights reserved.
//

#ifndef HJCaptureCameraDemo_HJDefines_h
#define HJCaptureCameraDemo_HJDefines_h

/**
 *  相机：SCCaptureCamera needs four frameworks:
 *  1、CoreMedia.framework
 *  2、QuartzCore.framework
 *  3、AVFoundation.framework
 *  4、ImmageIO.framework
 *
 */


// Debug Logging
#if 1 // Set to 1 to enable debug logging
#define WLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define WLog(x, ...)
#endif



#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#endif
