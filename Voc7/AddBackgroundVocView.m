//
//  AddBackgroundVocView.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 17.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "AddBackgroundVocView.h"

@implementation AddBackgroundVocView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0.1, 0.1, 0.1, 1.0);
    CGContextAddRect(context, [self bounds]);
    CGContextDrawPath(context, kCGPathFill);
    
    CGSize shadowOffset = CGSizeMake (0, 0);
    
    CGContextSetShadowWithColor(context, shadowOffset, 10, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor]); 
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
        1.0, 1.0, 1.0, 0.06 }; // End color
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
    
    
        CGRect currentBounds = self.bounds;
        CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
        CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds) - 40.0);
        CGContextDrawLinearGradient(context, glossGradient, bottomCenter, midCenter, 0);
        CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0);
        midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds) - 130.0);
        
        CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
    
    
    
}


@end
