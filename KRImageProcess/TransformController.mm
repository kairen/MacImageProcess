//
//  TransformController.m
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/11/21.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import "TransformController.h"
#import "MainController.h"
#import "CVProcess.h"
#import "NSImage+CVImage.h"
#import "NSBitmapImageRep+Process.h"


@interface TransformController ()

@property(nonatomic, copy) NSArray *images;
@end

@implementation TransformController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.images = @[@"image_01",@"image_02",@"image_03",@"image_04",@"image_05"];
    [self.popUpButton addItemsWithTitles:self.images];
    [self selectImageName:self.images[0]];
}


-(void) showProcessImage:(NSBitmapImageRep *)imageRep size:(NSSize)size {
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image addRepresentation:imageRep];
    self.processImage.image = image;
}


#pragma mark - Select Image Action
-(IBAction) selectImage:(id)sender {
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[self.sourceImage.image TIFFRepresentation]];
    NSSize size = NSMakeSize(imageRep.pixelsWide,
                             imageRep.pixelsHigh);
    
    NSInteger index = [(NSPopUpButton *)sender indexOfSelectedItem];
    self.popUpButton.title = self.images[index];
    [self selectImageName:self.images[index]];
    
    Mat sourceImage = imread([self imagePath:self.sourceImage.image.name],1);
    Mat effectImage = imread([self imagePath:self.effectImage.image.name],1);
    
    Point2f pts1[] = {Point2f(0,0),Point2f(0,sourceImage.rows),Point2f(sourceImage.cols,sourceImage.rows),Point2f(sourceImage.cols,0)};
    Point2f pts2[] = {Point2f(0,0),Point2f(0,effectImage.rows),Point2f(effectImage.cols,effectImage.rows),Point2f(effectImage.cols,0)};
    
    Mat perspective_matrix = getPerspectiveTransform(pts1, pts2);
    Mat dispImage;
    warpPerspective(sourceImage, dispImage, perspective_matrix, sourceImage.size(), INTER_LINEAR);
    
    line(sourceImage, pts1[0], pts1[1], cv::Scalar(255,255,0), 2, CV_AA);
    line(sourceImage, pts1[1], pts1[2], cv::Scalar(255,255,0), 2, CV_AA);
    line(sourceImage, pts1[2], pts1[3], cv::Scalar(255,255,0), 2, CV_AA);
    line(sourceImage, pts1[3], pts1[0], cv::Scalar(255,255,0), 2, CV_AA);
    line(sourceImage, pts2[0], pts2[1], cv::Scalar(255,0,255), 2, CV_AA);
    line(sourceImage, pts2[1], pts2[2], cv::Scalar(255,0,255), 2, CV_AA);
    line(sourceImage, pts2[2], pts2[3], cv::Scalar(255,0,255), 2, CV_AA);
    line(sourceImage, pts2[3], pts2[0], cv::Scalar(255,0,255), 2, CV_AA);

    Mat disp_Image;
    cvtColor(dispImage, disp_Image, CV_BGR2RGB);
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&disp_Image.data pixelsWide:disp_Image.cols pixelsHigh:disp_Image.rows bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:disp_Image.step bitsPerPixel:0];
    dispImage.release();
    disp_Image.release();
    [self showProcessImage:bitmapRep size:size];
}

-(void) selectImageName:(NSString*)name {
    self.sourceImage.image = [NSImage imageNamed:[NSString stringWithFormat:@"%@_one.jpg",name]];
    self.effectImage.image = [NSImage imageNamed:[NSString stringWithFormat:@"%@_two.jpg",name]];
}

-(const char *) imagePath:(NSString*)imageName {
    NSString *path = [[NSBundle mainBundle]pathForImageResource:imageName];
    return [path UTF8String];
}

@end
