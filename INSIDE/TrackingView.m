//
//  TrackingView.m
//  INSIDE
//
//  Created by Bessie  on 14-9-17.
//  Copyright (c) 2014年 Bessie . All rights reserved.
//

#import "TrackingView.h"
#include <OpenGL/gl.h>

@implementation TrackingView
@synthesize trackingArea;
@synthesize eyeBox;
@synthesize mouseLocation;
@synthesize displayEyeBox;
@synthesize BG;

static int WINDOW_WIDTH = 240;
static int WINDOW_HEIGHT = 240;
static int RADIUS = 20;
static int LEN_SIZE = 120;
static float MAG = 1.6f;
static float K = -0.000025f;
static int EFFECT = 0;
static NSString *fileName = @"test-image.jpg";

static int FISHEYE_EFFECT = 0;
static int TRAP_EFFECT = 1;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        trackingArea = [[NSTrackingArea alloc] initWithRect:frame options:(NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow) owner:self userInfo:nil];
        [self addTrackingArea:trackingArea];
        eyeBox = CGRectMake(0.0, 0.0, WINDOW_WIDTH, WINDOW_HEIGHT);
        mouseLocation = NSMakePoint(0, 0);
        displayEyeBox = false;
        BG = [NSImage imageNamed:fileName];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if(displayEyeBox){
        if(EFFECT == FISHEYE_EFFECT){
            [self fisheyeDraw];
        }else if(EFFECT == TRAP_EFFECT){
            [self trapDraw];
        }
    }
}

// Updates with a fisheye effect.
- (void)fisheyeDraw{
    
    // Sets the window location
    eyeBox.origin.x = mouseLocation.x - WINDOW_WIDTH / 2;
    eyeBox.origin.y = mouseLocation.y - WINDOW_HEIGHT / 2;
    
    // Draw a circle
    NSBezierPath* circlePath = [NSBezierPath bezierPath];
    [circlePath appendBezierPathWithOvalInRect: eyeBox];
        
    [circlePath addClip];
    
    // Draw the distorted image in the window
    NSImage *BGDistortion = [self getDistortedImage];
    [BGDistortion drawInRect:eyeBox fromRect:eyeBox operation:NSCompositeSourceOver fraction:1];
    
    [circlePath setLineWidth:4];
    [self drawShadow:circlePath];
}

// Shadow for the window
- (void)drawShadow:(NSBezierPath *)path {
    [[NSColor blackColor] setStroke];
    NSShadow * shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor blackColor]];
    [shadow setShadowBlurRadius:10.0];
    [shadow set];
    [path stroke];
}

// Returns a distorted image with fisheye effect at the window
- (NSImage *)getDistortedImage{
    
    NSBitmapImageRep *BGData = [[NSBitmapImageRep alloc] initWithData:[BG TIFFRepresentation]];
    NSBitmapImageRep *outputData = [[NSBitmapImageRep alloc] initWithData:[BG TIFFRepresentation]];
    
    int lsize2 = LEN_SIZE * LEN_SIZE;
    int x = eyeBox.origin.x + LEN_SIZE;
    int y = BGData.size.height - eyeBox.origin.y - LEN_SIZE;
    for(int vd = -LEN_SIZE; vd < LEN_SIZE; vd++){
        for(int ud = -LEN_SIZE; ud < LEN_SIZE; ud++){
            int r2 = ud * ud + vd * vd;
            if(r2 <= lsize2){
                float f = MAG + K * r2;
                int u = floor(ud/f) + x;
                int v = floor(vd/f) + y;
                if(u >= 0 && u < BGData.size.width && v >= 0 && v < BGData.size.height){
                    NSColor *color = [BGData colorAtX:u y:v];
                    [outputData setColor:color atX:ud+x y:vd+y];
                }
            }
        }
    }
    
    NSImage * output = [[NSImage alloc] initWithSize:[outputData size]];
    [output addRepresentation: outputData];
    return output;
    
}

// A trap view not implemented yet.
- (void)trapDraw{
    // TODO: Not Implemented yet.
    if(mouseLocation.x < eyeBox.origin.x + RADIUS
       || mouseLocation.x > eyeBox.origin.x + WINDOW_WIDTH - RADIUS
       || mouseLocation.y < eyeBox.origin.y + RADIUS
       || mouseLocation.y > eyeBox.origin.y + WINDOW_HEIGHT - RADIUS){
        eyeBox.origin.x = mouseLocation.x - WINDOW_WIDTH / 2;
        eyeBox.origin.y = mouseLocation.y - WINDOW_HEIGHT / 2;
    }
    
    [BG drawInRect:eyeBox fromRect:eyeBox operation:NSCompositeSourceOver fraction:1];
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path setLineWidth:2];
    [path appendBezierPathWithRect:eyeBox];
    [self drawShadow:path];
    
}

// Sets current mouse Location, displays the window and
// repaints the whole screen
- (void)mouseEntered:(NSEvent *)theEvent {
    mouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    displayEyeBox = true;
    [self setNeedsDisplayInRect:trackingArea.rect];
    [self displayIfNeeded];
}

// Sets current mouse Location, displays the window and
// repaints the whole screen
- (void)mouseMoved:(NSEvent *)theEvent {
    mouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    displayEyeBox = true;
    [self setNeedsDisplayInRect:trackingArea.rect];
    [self displayIfNeeded];
}

// Sets current mouse Location, not displays the window and
// repaints the whole screen
- (void)mouseExited:(NSEvent *)theEvent {
    mouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    displayEyeBox = true;
    [self setNeedsDisplayInRect:trackingArea.rect];
    [self displayIfNeeded];
}

@end
