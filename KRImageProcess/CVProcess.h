//
//  CVProcess.h
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/11/11.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <opencv2/opencv.hpp>

using namespace cv;


@interface CVProcess : NSObject

+(NSBitmapImageRep*) cvimage:(Mat)image GaussianFilter:(int)blur;
+(NSBitmapImageRep*) cvimage:(Mat)image BilateralFilter:(int)blur;
+(NSBitmapImageRep*) cvimageMedianFilter:(Mat)image;

+(NSBitmapImageRep*) cvimage:(Mat)src_img warpPerspective:(BOOL)restore;
+(void) skinColorDetection:(IplImage*)image;
+(void) houghTransform:(IplImage*)image efImage:(IplImage *)effect;
+(void) rgbToYCbCr:(IplImage *) image;
@end
