//
//  TransformController.h
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/11/21.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TransformController : NSWindowController

@property(nonatomic, weak) IBOutlet NSImageView *effectImage;
@property(nonatomic, weak) IBOutlet NSImageView *sourceImage;
@property(nonatomic, weak) IBOutlet NSImageView *processImage;

@property(nonatomic, weak) IBOutlet NSPopUpButton *popUpButton;


-(IBAction) selectImage:(id)sender;
@end
