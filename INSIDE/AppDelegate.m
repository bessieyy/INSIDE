//
//  AppDelegate.m
//  INSIDE
//
//  Created by Bessie  on 14-9-17.
//  Copyright (c) 2014年 Bessie . All rights reserved.
//

#import "AppDelegate.h"
#import "TrackingView.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Gets screen size.
    NSRect screenRect = [[NSScreen mainScreen] frame];
    
    // Sets the window as the same size as the screen and make it transparent.
    // Loads TrackingView in thie window.
    [self.window setOpaque:NO];
    NSColor *semiTransparentBlue =[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    [self.window setBackgroundColor:semiTransparentBlue];
    [self.window setStyleMask:NSBorderlessWindowMask];
    NSRect frame = [self.window frame];
    frame.size = screenRect.size;
    frame.origin = screenRect.origin;
    [self.window setFrame:frame display:true];
    [self.window setContentView:[[TrackingView alloc] initWithFrame:frame]];
    [self.window makeKeyAndOrderFront:nil];
}

@end
