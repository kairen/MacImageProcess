//
//  NSImage+CVImage.m
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/11/12.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import "NSImage+CVImage.h"

@implementation NSImage (CVImage)

+(NSImage*) opencvImageToNSImage:(IplImage *)img {
    char *d = img->imageData;
    
    NSString *COLORSPACE;
    if(img->nChannels == 1){
        COLORSPACE = NSDeviceWhiteColorSpace;
    }
    else{
        COLORSPACE = NSDeviceRGBColorSpace;
    }
    
    NSBitmapImageRep *bmp = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL pixelsWide:img->width pixelsHigh:img->height bitsPerSample:img->depth samplesPerPixel:img->nChannels
                             hasAlpha:NO isPlanar:NO colorSpaceName:COLORSPACE bytesPerRow:img->widthStep bitsPerPixel:0];
    int x, y;
    NSUInteger colors[3];
    for(y=0; y<img->height; y++){
        for(x=0; x<img->width; x++){
            if(img->nChannels > 1){
                colors[2] = (unsigned int) d[(y * img->widthStep) + (x*3)];
                colors[1] = (unsigned int) d[(y * img->widthStep) + (x*3)+1];
                colors[0] = (unsigned int) d[(y * img->widthStep) + (x*3)+2];
            }
            else{
                colors[0] = (unsigned int)d[(y * img->width) + x];
            }
            [bmp setPixel:colors atX:x y:y];
        }
    }
    
    NSData *tif = [bmp TIFFRepresentation];
    NSImage *im = [[NSImage alloc] initWithData:tif];
    
    return im ;
}

-(CGImageRef)CGImage
{
    CGContextRef bitmapCtx = CGBitmapContextCreate(NULL/*data - pass NULL to let CG allocate the memory*/,
                                                   [self size].width,
                                                   [self size].height,
                                                   8 /*bitsPerComponent*/,
                                                   0 /*bytesPerRow - CG will calculate it for you if it's allocating the data.  This might get padded out a bit for better alignment*/,
                                                   [[NSColorSpace genericRGBColorSpace] CGColorSpace],
                                                   kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapCtx flipped:NO]];
    [self drawInRect:NSMakeRect(0,0, [self size].width, [self size].height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapCtx);
    CGContextRelease(bitmapCtx);
    
    return cgImage;
}

-(cv::Mat) cvImageMat
{
    CGImageRef imageRef = [self CGImage];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), imageRef);
    CGContextRelease(contextRef);
    CGImageRelease(imageRef);
    return cvMat;
}
@end
