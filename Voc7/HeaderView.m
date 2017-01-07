//
//  HeaderView.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 09.04.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import "HeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x + 5, self.bounds.origin.y, self.bounds.size.width - 100.0, self.bounds.size.height)];
        _textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.layer.shadowOpacity = 1.0;
        _textLabel.layer.shadowColor = (__bridge CGColorRef)([UIColor whiteColor]);
        _textLabel.layer.shadowRadius = 1.0;
        _textLabel.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        [self addSubview:_textLabel];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0.9, 0.9, 0.9, 1.0);
    CGContextAddRect(context, [self bounds]);
    CGContextDrawPath(context, kCGPathFill);
    
    CGSize shadowOffset = CGSizeMake (0, 0);
    
    CGContextSetShadowWithColor(context, shadowOffset, 10, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor]);
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 0.0, 0.0, 0.55,  // Start color
        0.0, 0.0, 0.0, 0.06 }; // End color
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(context, glossGradient, bottomCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
}


@end

