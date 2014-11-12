//
//  AppDelegate.m
//  KRImageProcess
//
//  Created by Bai-Kai-Ren on 2014/10/7.
//  Copyright (c) 2014年 Bai-Kai-Ren. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"

@interface AppDelegate ()

@property(nonatomic, strong) MainController *mainController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.mainController = [[MainController alloc]initWithWindowNibName:@"MainController"];
    [self.mainController.window makeKeyAndOrderFront:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
