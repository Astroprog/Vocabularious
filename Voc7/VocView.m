//
//  VocView.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 16.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "VocView.h"
#import <QuartzCore/QuartzCore.h>

int rightVocCount;
int vocCount;
CGFloat mainScreenHeight;

@implementation VocView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!drawLabel) {
        CGRect bounds = [self bounds];
        float midX = CGRectGetMidX(bounds);
        drawLabel = [[UILabel alloc] initWithFrame:CGRectMake(midX - 50, 20, 100, 40)];
        drawLabel.backgroundColor = [UIColor clearColor];
        drawLabel.font = [UIFont systemFontOfSize:22.0];
        drawLabel.textColor = [UIColor blackColor];
        drawLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        drawLabel.textAlignment = NSTextAlignmentCenter;
        //drawLabel.layer.shadowColor = [drawLabel.textColor CGColor];
        //drawLabel.layer.shadowOffset = CGSizeZero;
        drawLabel.layer.masksToBounds = NO;
        //drawLabel.layer.shadowRadius = 3.0f;
        //drawLabel.layer.shadowOpacity = 1;
        drawLabel.numberOfLines = 1;
        [drawLabel sizeToFit];
        [self addSubview:drawLabel];
    }
    
    
    if (!drawScrollView)
    {
        drawScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 70)];
        drawScrollView.showsVerticalScrollIndicator = NO;
        drawScrollView.showsHorizontalScrollIndicator = YES;
        drawScrollView.scrollEnabled = YES;
        drawScrollView.userInteractionEnabled = YES;
        drawScrollView.pagingEnabled = YES;
        drawScrollView.bounces = YES;
        drawScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        drawScrollView.delegate = self;
        [drawScrollView addSubview:drawLabel];
        [self addSubview:drawScrollView];
    }
    
        
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextAddRect(context, [self bounds]);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSaveGState(context);
    
    CGSize shadowOffset = CGSizeMake (0, 0);
        
    CGContextSetShadowWithColor(context, shadowOffset, 5, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor]);
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName:[UIColor blackColor] };

    
    if (mainScreenHeight == 568.00)
    {
        drawLabel.text = drawString;
    
        //[[NSString stringWithFormat:NSLocalizedString(@"%d/%d sicher",nil), rightVocCount, vocCount] drawInRect:CGRectMake(10, 95 + 45.0, 100, 15) withFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        //[drawName drawInRect:CGRectMake(110, 95 + 45.0, 150, 15) withFont:[UIFont fontWithName:@"Helvetica" size:15.0f] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        [[NSString stringWithFormat:NSLocalizedString(@"%d/%d sicher",nil), rightVocCount, vocCount] drawInRect:CGRectMake(10, 55 + 45.0, 100, 15) withAttributes:attributes];
        [drawName drawInRect:CGRectMake(110, 55 + 45.0, 150, 15) withAttributes:attributes];

    }
    
    
    else {

        drawLabel.text = drawString;
        
        [[NSString stringWithFormat:NSLocalizedString(@"%d/%d sicher", nil), rightVocCount, vocCount] drawInRect:CGRectMake(10, 75, 100, 15) withAttributes:attributes];
        [drawName drawInRect:CGRectMake(95, 75, 150, 15) withAttributes:attributes];
    }
        if (self.green) {
            CGContextSetShadowWithColor(context, shadowOffset, 10, [[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0] CGColor]); 
            CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.7);
        } else {
            CGContextSetShadowWithColor(context, shadowOffset, 10, [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]); 
            CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.7);
        }
    
    if (mainScreenHeight == 568.00)
    {
        CGContextAddEllipseInRect(context, CGRectMake(285, 60 + 45.0, 10, 10));
    }
    else CGContextAddEllipseInRect(context, CGRectMake(285, 80, 10, 10));
    CGContextDrawPath(context, kCGPathFill);
    

    CGContextRestoreGState(context);

    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.5,  // Start color
        1.0, 1.0, 1.0, 0.06 }; // End color
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	

    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);

        
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    [drawLabel sizeToFit];
    
    if (drawLabel.frame.size.width >= CGRectGetWidth([self bounds])) {
        drawLabel.frame = CGRectMake(10, 20, drawLabel.frame.size.width, drawLabel.frame.size.height);
    } else {
        drawLabel.frame = CGRectMake(CGRectGetMidX([self bounds]) - drawLabel.frame.size.width / 2, 20, drawLabel.frame.size.width, drawLabel.frame.size.height);
    }

    drawScrollView.contentSize = CGSizeMake(drawLabel.frame.size.width + 30, 20);
    drawScrollView.decelerationRate = 0.1f;
    [drawScrollView flashScrollIndicators];

}

- (void)setDrawString:(NSString *)string andName:(NSString *)name
{
    drawString = string;
    drawName = name;
    [self setNeedsDisplay];
}



@end
