//
//  TrackingView.h
//  INSIDE
//
//  Created by Bessie  on 14-9-17.
//  Copyright (c) 2014年 Bessie . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TrackingView : NSView
@property NSTrackingArea *trackingArea;
@property NSRect eyeBox;
@property bool displayEyeBox;
@property NSImage *BG;
@property NSPoint mouseLocation;

@end
