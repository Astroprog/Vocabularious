//
//  CustomButton.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 15.04.13.
//  Copyright (c) 2013 PetJan. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        roundedRectangle = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *borderColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.00f];
    UIColor *topColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.00f];
    UIColor *bottomColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1.00f];
    UIColor *innerGlow = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    // Gradient Declarations
    NSArray *gradientColors = (@[
                               (id)topColor.CGColor,
                               (id)bottomColor.CGColor
                               ]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(gradientColors), NULL);
    
    NSArray *highlightedGradientColors = (@[
                                          (id)bottomColor.CGColor,
                                          (id)topColor.CGColor
                                          ]);
    
    CGGradientRef highlightedGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(highlightedGradientColors), NULL);
    
    // Draw rounded rectangle bezier path
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangle cornerRadius: 8];
    // Use the bezier as a clipping path
    [roundedRectanglePath addClip];
    [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0] set];
    [roundedRectanglePath fill];
    // Use one of the two gradients depending on the state of the button
    CGGradientRef background = self.highlighted ? highlightedGradient : gradient;
    
    // Draw gradient within the path
    
    if (self.highlighted) {
        CGContextDrawLinearGradient(context, background, CGPointMake(roundedRectangle.size.width / 2, roundedRectangle.size.height / 2), CGPointMake(roundedRectangle.size.width / 2, roundedRectangle.size.height), 0);
    } else {
        CGContextDrawLinearGradient(context, background, CGPointMake(roundedRectangle.size.width / 2, 0), CGPointMake(roundedRectangle.size.width / 2, roundedRectangle.size.height / 2), 0);
    }
    
    
    // Draw border
    [borderColor setStroke];
    roundedRectanglePath.lineWidth = 2;
    [roundedRectanglePath stroke];
    
    // Draw Inner Glow
    UIBezierPath *innerGlowRect = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(1.5, 1.5, roundedRectangle.size.width - 3.0, roundedRectangle.size.height - 3.0) cornerRadius: 5.5];
    [innerGlow setStroke];
    innerGlowRect.lineWidth = 1;
    [innerGlowRect stroke];
    
    // Cleanup
    CGGradientRelease(gradient);
    CGGradientRelease(highlightedGradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)setHighlighted:(BOOL)highlighted
{
    [self setNeedsDisplay];
    [super setHighlighted:highlighted];
}


@end
