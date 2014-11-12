//
//  NSImage+Process.m
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/11/11.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import "NSBitmapImageRep+Process.h"

int compare( const void *arg1, const void *arg2 ) {
    return *(char *)arg1 - *(char *)arg2;
}

@implementation NSBitmapImageRep (Process)

-(NSBitmapImageRep*) bitmapImageResize:(NSSize)newSize {
    NSBitmapImageRep *bitmapImageRep = [self bitmapBySize:newSize];;
    
    NSSize size = NSMakeSize(self.pixelsWide,
                             self.pixelsHigh);
    Pixel *outPixel = (Pixel*)[bitmapImageRep bitmapData];
    Pixel *inPixel = (Pixel*)[self bitmapData];
    
    float x_ratio = ((float)(size.width - 1)) / newSize.width ;
    float y_ratio = ((float)(size.height - 1))/ newSize.height ;
    for (NSUInteger row = 0; row < newSize.width; row++) {
        for (NSUInteger col = 0; col < newSize.height; col++) {
            int x = (int)(x_ratio * col) ;
            int y = (int)(y_ratio * row) ;
            float x_diff = (x_ratio * col) - x ;
            float y_diff = (y_ratio * row) - y ;
            int index = (int)(y * (NSInteger)size.width + x) ;
            Pixel a = inPixel[index] ;
            Pixel b = inPixel[index + 1] ;
            Pixel c = inPixel[index + (NSInteger)size.width] ;
            Pixel d = inPixel[index + (NSInteger)size.width + 1] ;
            outPixel[row * (NSInteger)newSize.width + col].red = (a.red) * (1 - x_diff) * (1-y_diff) + (b.red) * (x_diff) * (1-y_diff) + (c.red) * (y_diff) * (1-x_diff) + (d.red) * (x_diff * y_diff);
            outPixel[row * (NSInteger)newSize.width + col].green = (a.green) * (1 - x_diff) * (1-y_diff) + (b.green) * (x_diff) * (1-y_diff) + (c.green) * (y_diff) * (1-x_diff) + (d.green) * (x_diff * y_diff);
            outPixel[row * (NSInteger)newSize.width + col].blue = (a.blue) * (1 - x_diff) * (1-y_diff) + (b.blue) * (x_diff) * (1-y_diff) + (c.blue) * (y_diff) * (1-x_diff) + (d.blue) * (x_diff * y_diff);
            
            outPixel[row * (NSInteger)newSize.width + col].alpha = a.alpha;
        }
    }
    return bitmapImageRep;
}

-(NSBitmapImageRep*) bitmapImageTwoValue {
    NSSize size = NSMakeSize(self.pixelsWide,
                             self.pixelsHigh);
    NSBitmapImageRep *bitmapImageRep = [self bitmapBySize:size];;
    Pixel *outPixel = (Pixel*)[bitmapImageRep bitmapData];
    Pixel *inPixel = (Pixel*)[self bitmapData];
    for (NSUInteger row = 0; row < size.width; row++) {
        for (NSUInteger col = 0; col < size.height; col++) {
            Pixel rgba = inPixel[row * (NSInteger)size.width + col] ;
            NSInteger gray = rgba.red * 0.299 + rgba.green * 0.587 + rgba.blue * 0.114;
            gray = (gray > 127) ? 0xff:0x0;
            outPixel[row * (NSInteger)size.width + col].red = gray;
            outPixel[row * (NSInteger)size.width + col].green = gray;
            outPixel[row * (NSInteger)size.width + col].blue = gray;
            outPixel[row * (NSInteger)size.width + col].alpha = rgba.alpha;
        }
    }
    return bitmapImageRep;
}

-(NSBitmapImageRep*) bitmapImageGrayValue {
    NSSize size = NSMakeSize(self.pixelsWide,
                             self.pixelsHigh);
    NSBitmapImageRep *bitmapImageRep = [self bitmapBySize:size];
    Pixel *outPixel = (Pixel*)[bitmapImageRep bitmapData];
    Pixel *inPixel = (Pixel*)[self bitmapData];
    for (NSUInteger row = 0; row < size.width; row++) {
        for (NSUInteger col = 0; col < size.height; col++) {
            Pixel rgba = inPixel[row * (NSInteger)size.width + col] ;
            NSInteger gray = rgba.red * 0.299 + rgba.green * 0.587 + rgba.blue * 0.114;
            outPixel[row * (NSInteger)size.width + col].red = gray;
            outPixel[row * (NSInteger)size.width + col].green = gray;
            outPixel[row * (NSInteger)size.width + col].blue = gray;
            outPixel[row * (NSInteger)size.width + col].alpha = rgba.alpha;
        }
    }
    return bitmapImageRep;
}

-(NSBitmapImageRep*) bitmapImageRotation {
    NSSize size = NSMakeSize(self.pixelsWide,
                             self.pixelsHigh);
    NSBitmapImageRep *bitmapImageRep = [self bitmapBySize:size];
    Pixel *outPixel = (Pixel*)[bitmapImageRep bitmapData];
    Pixel *inPixel = (Pixel*)[self bitmapData];
    for (NSUInteger row = 0; row < size.width; row++) {
        for (NSUInteger col = 0; col < size.height; col++) {
            Pixel rgba = inPixel[row * (NSInteger)size.width + col] ;
            outPixel[col * (NSInteger)size.width + row].red = rgba.red;
            outPixel[col * (NSInteger)size.width + row].green = rgba.green;
            outPixel[col * (NSInteger)size.width + row].blue = rgba.blue;
            outPixel[col * (NSInteger)size.width + row].alpha = rgba.alpha;
        }
    }
    return bitmapImageRep;
}

-(NSBitmapImageRep*) bitmapImageLowFilter {
    NSSize size = NSMakeSize(self.pixelsWide,
                             self.pixelsHigh);
    NSBitmapImageRep *bitmapImageRep = [self bitmapBySize:size];
    Pixel *outPixel = (Pixel*)[bitmapImageRep bitmapData];
    Pixel *inPixel = (Pixel*)[self bitmapData];
    
    float Kernel[3][3] = {
        {1/9.0, 1/9.0, 1/9.0},
        {1/9.0, 1/9.0, 1/9.0},
        {1/9.0, 1/9.0, 1/9.0}
    };
    
    for (NSUInteger row = 0; row < size.width - 1; row++) {
        for (NSUInteger col = 0; col < size.height - 1; col++) {
            float sumR = 0,sumG = 0,sumB = 0;
            Pixel rgba = inPixel[row * (NSInteger)size.width + col];
            
            for(int k = -1; k <= 1;k++){
                for(int j = -1; j <=1; j++){
                    Pixel rgb = inPixel[(row - j) * (NSInteger)size.width + (col - k)];
                    sumR += (Kernel[j+1][k+1] * rgb.red);
                    sumG += (Kernel[j+1][k+1] * rgb.green);
                    sumB += (Kernel[j+1][k+1] * rgb.blue);
                }
            }
            outPixel[row * (NSInteger)size.width + col].red = sumR;
            outPixel[row * (NSInteger)size.width + col].green = sumG;
            outPixel[row * (NSInteger)size.width + col].blue = sumB;
            outPixel[row * (NSInteger)size.width + col].alpha = rgba.alpha;
        }
    }
    return bitmapImageRep;
}

-(NSBitmapImageRep*) bitmapImageMedianFilter {
    NSSize size = NSMakeSize(self.pixelsWide,
                             self.pixelsHigh);
    NSBitmapImageRep *bitmapImageRep = [self bitmapBySize:size];
    Pixel *outPixel = (Pixel*)[bitmapImageRep bitmapData];
    Pixel *inPixel = (Pixel*)[self bitmapData];
    
    for (NSUInteger row = 0; row < size.width - 1; row++) {
        for (NSUInteger col = 0; col < size.height - 1; col++) {
            int count = 0;
            NSInteger arrayR[9],arrayG[9],arrayB[9];
            Pixel rgba = inPixel[row * (NSInteger)size.width + col];
            
            for(int k = -1; k <= 1;k++){
                for(int j = -1; j <=1; j++){
                    Pixel rgb = inPixel[(row - j) * (NSInteger)size.width + (col - k)];
                    arrayR[count] = rgb.red;
                    arrayG[count] = rgb.green;
                    arrayB[count] = rgb.blue;
                    count++;
                }
            }
            qsort(arrayR, sizeof(arrayR) / sizeof(NSInteger), sizeof(NSInteger), compare);
            qsort(arrayG, sizeof(arrayG) / sizeof(NSInteger), sizeof(NSInteger), compare);
            qsort(arrayB, sizeof(arrayB) / sizeof(NSInteger), sizeof(NSInteger), compare);
            outPixel[row * (NSInteger)size.width + col].red = arrayR[4];
            outPixel[row * (NSInteger)size.width + col].green = arrayG[4];
            outPixel[row * (NSInteger)size.width + col].blue = arrayB[4];
            outPixel[row * (NSInteger)size.width + col].alpha = rgba.alpha;
        }
    }
    return bitmapImageRep;
}

#pragma mark - Get Bitmap from szie
-(NSBitmapImageRep*) bitmapBySize:(NSSize)size {
    NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:(unsigned char **)NULL pixelsWide:size.width pixelsHigh:size.height bitsPerSample:(int)8 samplesPerPixel:(int)4 hasAlpha:(BOOL)YES isPlanar:(BOOL)NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:(size.width * sizeof(Pixel)) bitsPerPixel:(int)0];
    return bitmapImageRep;
}

@end
