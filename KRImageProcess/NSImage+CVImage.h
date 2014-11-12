//
//  NSImage+CVImage.h
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/11/12.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <opencv2/opencv.hpp>



@interface NSImage (CVImage)

-(cv::Mat) cvImageMat;
+(NSImage*) opencvImageToNSImage:(IplImage *)img;

@end
