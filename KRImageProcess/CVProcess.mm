//
//  CVProcess.m
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/11/11.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import "CVProcess.h"

const int avg_cb = 112;//YCbCr顏色空間膚色cb的平均值
const int avg_cr = 120;//YCbCr顏色空間膚色cr的平均值
const int skinRange = 23;//YCbCr顏色空間膚色的範圍
const int nOffset=200;

@implementation CVProcess

+(NSBitmapImageRep*) cvimage:(cv::Mat)src_img warpPerspective:(BOOL)restore {
    
    cv::Point2f pts1[] = {cv::Point2f(0,0),cv::Point2f(0,src_img.rows),cv::Point2f(src_img.cols,src_img.rows),cv::Point2f(src_img.cols,0)};
    cv::Point2f pts2[] = {cv::Point2f(0,0),cv::Point2f(0+nOffset,src_img.rows),cv::Point2f(src_img.cols-nOffset,src_img.rows),cv::Point2f(src_img.cols,0)};
    
    cv::Mat perspective_matrix;
    if(restore) {
        perspective_matrix = cv::getPerspectiveTransform(pts2, pts1);
    } else {
        perspective_matrix = cv::getPerspectiveTransform(pts1, pts2);
    }
    cv::Mat dst_img;
    
    cv::warpPerspective(src_img, dst_img, perspective_matrix, src_img.size(), cv::INTER_LINEAR);
    
    cv::line(src_img, pts1[0], pts1[1], cv::Scalar(255,255,0), 2, CV_AA);
    cv::line(src_img, pts1[1], pts1[2], cv::Scalar(255,255,0), 2, CV_AA);
    cv::line(src_img, pts1[2], pts1[3], cv::Scalar(255,255,0), 2, CV_AA);
    cv::line(src_img, pts1[3], pts1[0], cv::Scalar(255,255,0), 2, CV_AA);
    cv::line(src_img, pts2[0], pts2[1], cv::Scalar(255,0,255), 2, CV_AA);
    cv::line(src_img, pts2[1], pts2[2], cv::Scalar(255,0,255), 2, CV_AA);
    cv::line(src_img, pts2[2], pts2[3], cv::Scalar(255,0,255), 2, CV_AA);
    cv::line(src_img, pts2[3], pts2[0], cv::Scalar(255,0,255), 2, CV_AA);
    
    Mat dispImage;
    
    cvtColor(dst_img, dispImage, CV_BGR2RGB);
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&dispImage.data pixelsWide:dispImage.cols pixelsHigh:dispImage.rows bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:dispImage.step bitsPerPixel:0];
    dispImage.release();
    return bitmapRep;
}

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
