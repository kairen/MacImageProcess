//
//  MainController.h
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/10/7.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainController : NSWindowController
@property(nonatomic, weak) IBOutlet NSTextField *widthField;
@property(nonatomic, weak) IBOutlet NSTextField *heightField;
@property(nonatomic, weak) IBOutlet NSImageView *processImage;
@property(nonatomic, weak) IBOutlet NSImageView *sourceImage;
@property(nonatomic, weak) IBOutlet NSPopUpButton *popUpButton;

-(IBAction) resizeAction:(id)sender;
-(IBAction) grayValueAction:(id)sender;
-(IBAction) twoValueAction:(id)sender;
-(IBAction) rotationAction:(id)sender;
-(IBAction) lowFilterAction:(id)sender;
-(IBAction) medianFilterAction:(id)sender;
-(IBAction) gaussianFilterAction:(id)sender;
-(IBAction) cvImageBGRtoYCrCb:(id)sender;
-(IBAction) detectionSkinColor:(id)sender;
-(IBAction) houghTransformAction:(id)sender;
-(IBAction) warpPerspectiveAction:(id)sender;


-(IBAction) aboutAction:(id)sender;
-(IBAction) selectImage:(id)sender;
@end
