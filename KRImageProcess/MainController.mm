//
//  MainController.m
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/10/7.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//


#import "MainController.h"
#import "CVProcess.h"
#import "NSImage+CVImage.h"
#import "NSBitmapImageRep+Process.h"

using namespace cv;

@interface MainController ()

@property(nonatomic, copy) NSArray *images;
@end

@implementation MainController

-(void) windowDidLoad {
    [super windowDidLoad];
    self.images = @[@"lena_std.png",@"lena_bad.png",@"Butterfly_pepper.png",
                    @"face.png",@"houghTrans.png"];
    [self.popUpButton addItemsWithTitles:self.images];
    self.sourceImage.image = [NSImage imageNamed:self.images[0]];
}

-(IBAction) aboutAction:(id)sender {
    NSAlert *alert = [NSAlert alertWithMessageText:@"影像處理作業" defaultButton:@"關閉" alternateButton:nil otherButton:nil informativeTextWithFormat:@"作業版本 1.0.0 \nMade in Lab 2801-1"];
    [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    
}

-(IBAction) warpPerspectiveAction:(id)sender {
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[self.sourceImage.image TIFFRepresentation]];
    NSSize size = NSMakeSize(imageRep.pixelsWide,
                             imageRep.pixelsHigh);
    Mat src = imread([self imagePath:self.sourceImage.image.name]);
    NSBitmapImageRep *bitmapImageRep = [CVProcess cvimage:src warpPerspective:((NSButton*)sender).tag];
    [self showProcessImage:bitmapImageRep size:size];
    [self saveImage:bitmapImageRep];
}

-(IBAction) houghTransformAction:(id)sender {
    IplImage *src = cvLoadImage([self imagePath:self.sourceImage.image.name]);
    IplImage *pColorImg = cvCreateImage(cvGetSize(src), 8, 3 );
    [CVProcess houghTransform:src efImage:pColorImg];
    self.processImage.image = [NSImage opencvImageToNSImage:pColorImg];
}

-(IBAction)detectionSkinColor:(id)sender {
    IplImage *src = cvLoadImage([self imagePath:self.sourceImage.image.name]);
    IplImage* pImgYCbCr = cvCreateImage(cvGetSize(src),
                                        src->depth,
                                        src->nChannels);
    cvCopy(src, pImgYCbCr, NULL);
    [CVProcess rgbToYCbCr:pImgYCbCr];
    [CVProcess skinColorDetection:pImgYCbCr];
    self.processImage.image = [NSImage opencvImageToNSImage:pImgYCbCr];
}

-(IBAction) cvImageBGRtoYCrCb:(id)sender {
    IplImage *src = cvLoadImage([self imagePath:self.sourceImage.image.name]);
    IplImage* pImgYCbCr = cvCreateImage(cvGetSize(src),
                                        src->depth,
                                        src->nChannels);
    cvCvtColor(src, pImgYCbCr, CV_RGB2YCrCb);
    self.processImage.image = [NSImage opencvImageToNSImage:pImgYCbCr];
}

-(IBAction) gaussianFilterAction:(id)sender {
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[self.sourceImage.image TIFFRepresentation]];
    NSSize size = NSMakeSize(imageRep.pixelsWide,
                             imageRep.pixelsHigh);
    Mat src = imread([self imagePath:self.sourceImage.image.name]);
    NSBitmapImageRep *bitmapImageRep = [CVProcess cvimage:src GaussianFilter:30];
    [self showProcessImage:bitmapImageRep size:size];
}

-(IBAction)resizeAction:(id)sender {
    
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[self.sourceImage.image TIFFRepresentation]];
    NSSize newSize = NSMakeSize([self.widthField.stringValue intValue],
                                [self.heightField.stringValue intValue]);
    if(newSize.width != newSize.height) return;
    
    NSBitmapImageRep *bitmapImageRep = [imageRep bitmapImageResize:newSize];
    [self showProcessImage:bitmapImageRep size:newSize];
    [self saveImage:bitmapImageRep];
}

-(IBAction) twoValueAction:(id)sender {
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[self.sourceImage.image TIFFRepresentation]];
    NSSize size = NSMakeSize(imageRep.pixelsWide,
                             imageRep.pixelsHigh);
    NSBitmapImageRep *bitmapImageRep = [imageRep bitmapImageTwoValue];
    
   [self showProcessImage:bitmapImageRep size:size];
}

-(IBAction) grayValueAction:(id)sender {
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[self.sourceImage.image TIFFRepresentation]];
    NSSize size = NSMakeSize(imageRep.pixelsWide,
                             imageRep.pixelsHigh);
    NSBitmapImageRep *bitmapImageRep = [imageRep bitmapImageGrayValue];
    [self showProcessImage:bitmapImageRep size:size];
}

-(IBAction) rotationAction:(id)sender {
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[self.sourceImage.image TIFFRepresentation]];
    NSSize size = NSMakeSize(imageRep.pixelsWide,
                             imageRep.pixelsHigh);
    NSBitmapImageRep *bitmapImageRep = [imageRep bitmapImageRotation];
    [self showProcessImage:bitmapImageRep size:size];
}

-(IBAction) lowFilterAction:(id)sender {
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[self.sourceImage.image TIFFRepresentation]];
    NSSize size = NSMakeSize(imageRep.pixelsWide,
                             imageRep.pixelsHigh);
    NSBitmapImageRep *bitmapImageRep = [imageRep bitmapImageLowFilter];
    [self showProcessImage:bitmapImageRep size:size];
}

-(IBAction) medianFilterAction:(id)sender {
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[self.sourceImage.image TIFFRepresentation]];
    NSSize size = NSMakeSize(imageRep.pixelsWide,
                             imageRep.pixelsHigh);
    Mat src = imread([self imagePath:self.sourceImage.image.name]);
    NSBitmapImageRep *bitmapImageRep = [CVProcess cvimageMedianFilter:src];
    [self showProcessImage:bitmapImageRep size:size];
}

-(void) showProcessImage:(NSBitmapImageRep *)imageRep size:(NSSize)size {
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image addRepresentation:imageRep];
    self.processImage.image = image;
}

#pragma mark - Other Action Method
-(IBAction) selectImage:(id)sender {
    NSInteger index = [(NSPopUpButton *)sender indexOfSelectedItem];
    self.popUpButton.title = self.images[index];
    self.sourceImage.image = [NSImage imageNamed:self.images[index]];
}

-(const char *) imagePath:(NSString*)imageName {
    NSString *path = [[NSBundle mainBundle]pathForImageResource:imageName];
    return [path UTF8String];
}

-(void) saveImage:(NSBitmapImageRep *)imageRep {
    NSData *imageData;
    NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:[imageRep TIFFRepresentation]];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    imageData = [rep representationUsingType:NSJPEGFileType properties:imageProps];
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    NSString *filePath = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"resize_%li_%li.png",(long)imageRep.pixelsWide,(long)imageRep.pixelsHigh]];
    [imageData writeToFile:filePath atomically:YES];
}

@end
