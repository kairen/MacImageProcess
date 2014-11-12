//
//  CVProcess.m
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/11/11.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import "CVProcess.h"

int avg_cb = 120;//YCbCr顏色空間膚色cb的平均值
int avg_cr = 155;//YCbCr顏色空間膚色cr的平均值
int skinRange = 22;//YCbCr顏色空間膚色的範圍

@implementation CVProcess

+(void) houghTransform:(IplImage*)image efImage:(IplImage *)effect {
    IplImage *pDstImg = cvCreateImage( cvGetSize(image), 8, 1 );
    CvMemStorage* storage = cvCreateMemStorage(0);
    CvSeq* lines = 0;
    
    cvCanny( image, pDstImg, 50, 150, 3 );
    cvCvtColor( pDstImg, effect, CV_GRAY2BGR );
    
    lines = cvHoughLines2( pDstImg, storage, CV_HOUGH_PROBABILISTIC,
                          1, CV_PI/180, 50, 50, 10 );
    
    for(int i = 0; i < lines->total; i++ ) {
        CvPoint* line = (CvPoint*)cvGetSeqElem(lines, i);
        cvLine( effect, line[0], line[1], CV_RGB(255,0,0), 3, CV_AA, 0 );
    }
}

+(void) rgbToYCbCr:(IplImage *) image {
    CvScalar scalarImg;
    double cb, cr, y;
    for( int i = 0; i < image->height; i++ ) {
        for( int j = 0; j < image->width; j++ ) {
            scalarImg = cvGet2D(image, i, j);//從影像中取RGB值
            y =  (16 + scalarImg.val[2]*0.257 + scalarImg.val[1]*0.504
                  + scalarImg.val[0]*0.098);
            cb = (128 - scalarImg.val[2]*0.148 - scalarImg.val[1]*0.291
                  + scalarImg.val[0]*0.439);
            cr = (128 + scalarImg.val[2]*0.439 - scalarImg.val[1]*0.368
                  - scalarImg.val[0]*0.071);
            cvSet2D(image, i, j, cvScalar( y, cr, cb));
        }
    }
}

+(void) skinColorDetection:(IplImage*)image {
    CvScalar scalarImg;
    double cb, cr;
    for(int i = 0; i < image->height; i++ ) {
        for( int j = 0; j < image->width; j++ ) {
            scalarImg = cvGet2D(image, i, j);
            cr = scalarImg.val[1];
            cb = scalarImg.val[2];
            if((cb > avg_cb-skinRange && cb < avg_cb+skinRange) &&
               (cr > avg_cr-skinRange && cr < avg_cr+skinRange))
                cvSet2D(image, i, j, cvScalar( 255, 255, 255));
            else
                cvSet2D(image, i, j, cvScalar( 0, 0, 0));
        }
    }
}

+(NSBitmapImageRep*) cvimage:(cv::Mat)image GaussianFilter:(int)blur {
    Mat dst;
    for (int i = 1; i < blur; i = i + 2 ){
        GaussianBlur( image, dst, Size2i( i, i ), 0, 0 );
    }
    NSBitmapImageRep* bitmapRep = nil;
    Mat dispImage;
    cvtColor(dst, dispImage, CV_BGR2RGB);
    bitmapRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&dispImage.data pixelsWide:dispImage.cols pixelsHigh:dispImage.rows bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:dispImage.step bitsPerPixel:0];
    dispImage.release();
    return bitmapRep;
}

+(NSBitmapImageRep*) cvimage:(cv::Mat)image BilateralFilter:(int)blur {
    Mat dst;
    for (int i = 1; i < blur; i = i + 2 ){
        bilateralFilter ( image, dst, i, i * 2, i / 2 );
    }
    NSBitmapImageRep* bitmapRep = nil;
    Mat dispImage;
    cvtColor(dst, dispImage, CV_BGR2RGB);
    bitmapRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&dispImage.data pixelsWide:dispImage.cols pixelsHigh:dispImage.rows bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:dispImage.step bitsPerPixel:0];
    dispImage.release();
    return bitmapRep;
}

+(NSBitmapImageRep*) cvimageMedianFilter:(Mat)image {
    Mat dst;
    for ( int i = 1; i < 9; i = i + 2 ) {
         medianBlur (image, dst, i );
    }
    NSBitmapImageRep* bitmapRep = nil;
    Mat dispImage;
    cvtColor(dst, dispImage, CV_BGR2RGB);
    bitmapRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&dispImage.data pixelsWide:dispImage.cols pixelsHigh:dispImage.rows bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:dispImage.step bitsPerPixel:0];
    dispImage.release();
    return bitmapRep;
}

@end
