//
//  VocInfoBackgroundView.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 20.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "VocInfoBackgroundView.h"

CGFloat mainScreenHeight;

@implementation VocInfoBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


- (void)drawRoundedRectAtX:(float)x Y:(float)y Width:(float)width height:(float)height
{
    CGSize shadowOffset = CGSizeMake (0, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetShadowWithColor(context, shadowOffset, 5, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor]);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    
    
    CGRect roundedRect = CGRectMake(x, y, width, height);
    CGFloat radius = 5.0;
    
    CGFloat minx = CGRectGetMinX(roundedRect), midx = CGRectGetMidX(roundedRect), maxx = CGRectGetMaxX(roundedRect);
    CGFloat miny = CGRectGetMinY(roundedRect), midy = CGRectGetMidY(roundedRect), maxy = CGRectGetMaxY(roundedRect);
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, x, midy); 
    CGContextAddLineToPoint(context, x + width, midy); 
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    
    CGContextClosePath(context);
    CGContextSaveGState(context);
    CGContextClip(context);
    
    
    //Gradient für Rechteck
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.10,  // Start color
        1.0, 1.0, 1.0, 0.03 }; // End color
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
    CGPoint topCenter = CGPointMake(midx, miny);
    CGPoint midCenter = CGPointMake(midx, midy - 0.5 * (midy - miny));
    CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);
    
    topCenter = CGPointMake(midx, midy);
    midCenter = CGPointMake(midx, maxy - 0.5 * (maxy - midy));
    
    CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);
	
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0.1, 0.1, 0.1, 1.0);
    CGContextAddRect(context, [self bounds]);
    CGContextDrawPath(context, kCGPathFill);
    
    [self drawRoundedRectAtX:20 Y:23 Width:280 height:80];
    
    CGSize shadowOffset = CGSizeMake (0, 0);
    
    CGContextSetShadowWithColor(context, shadowOffset, 5, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor]);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    
    
    CGRect roundedRect = CGRectMake(20, 120, 280, 60);
    CGFloat radius = 5.0;
    
    CGFloat minx = CGRectGetMinX(roundedRect), midx = CGRectGetMidX(roundedRect), maxx = CGRectGetMaxX(roundedRect);
    CGFloat miny = CGRectGetMinY(roundedRect), midy = CGRectGetMidY(roundedRect), maxy = CGRectGetMaxY(roundedRect);
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    /*CGContextBeginPath(context);
    CGContextMoveToPoint(context, 20, midy);
    CGContextAddLineToPoint(context, 300, midy);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathStroke);
    */
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    
    CGContextClosePath(context);
    CGContextSaveGState(context);
    CGContextClip(context);
    
    
    //Gradient für Rechteck
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.10,  // Start color
        1.0, 1.0, 1.0, 0.03 }; // End color
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
    CGPoint topCenter = CGPointMake(midx, miny);
    CGPoint midCenter = CGPointMake(midx, midy);
    CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);
	
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    CGContextRestoreGState(context);
    
    
    [self drawRoundedRectAtX:20 Y:180 Width:280 height:80];

    
       
}


@end