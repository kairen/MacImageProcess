//
//  NSImage+Process.h
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/11/11.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct {
    uint8_t red;
    uint8_t green;
    uint8_t blue;
    uint8_t alpha;
} Pixel;

@interface NSBitmapImageRep (Process)

-(NSBitmapImageRep*) bitmapImageResize:(NSSize)newSize;
-(NSBitmapImageRep*) bitmapImageTwoValue;
-(NSBitmapImageRep*) bitmapImageGrayValue;
-(NSBitmapImageRep*) bitmapImageRotation;
-(NSBitmapImageRep*) bitmapImageLowFilter;
-(NSBitmapImageRep*) bitmapImageMedianFilter;

@end
