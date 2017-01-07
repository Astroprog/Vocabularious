//
//  GraphView.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 28.03.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import "GraphView.h"
#import "Day.h"

NSMutableArray *graphArray;
CGFloat mainScreenHeight;


@implementation GraphView

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint startingPoint;
    
    if (mainScreenHeight == 568.0) {
        startingPoint = CGPointMake(50.0, 350.0);
    } else {
        startingPoint = CGPointMake(50.0, 300.0);
    }
    
    float yAxisLength = 220.0;
    float xAxisLength = 250.0;
    
    //Hintergrundfarbe
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, [self bounds]);
    
    UIFont *font13 = [UIFont fontWithName:@"Helvetica" size:13.0f];
    UIFont *font15 = [UIFont fontWithName:@"Helvetica" size:15.0f];
    UIFont *font16 = [UIFont fontWithName:@"Helvetica" size:16.0f];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes13 = @{NSFontAttributeName:font13, NSParagraphStyleAttributeName:paragraphStyle};
    NSDictionary *attributes15 = @{NSFontAttributeName:font15, NSParagraphStyleAttributeName:paragraphStyle};
    NSDictionary *attributes16 = @{NSFontAttributeName:font16, NSParagraphStyleAttributeName:paragraphStyle};

    
    
    
    float dx = 32.0;
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 4.0);
    
    int start = [graphArray count] - 8;
    if (start < 0) {
        start = 0;
    }
    
    
    for (int i = start; i < [graphArray count]; i++) {
        
        Day *day = [graphArray objectAtIndex:i];
        double y = (double)day.rightVocs / ((double)day.rightVocs + (double)day.wrongVocs) * 200.0;
        CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(day.time, CFTimeZoneCopySystem());
        NSString *dateString = [NSString stringWithFormat:@"%d.%d", currentDate.day, currentDate.month];
        
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.0);
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.0);
        CGContextSetShadow(context, CGSizeZero, 0);

        [dateString drawInRect:CGRectMake((i - start) * dx + startingPoint.x - 12.0, startingPoint.y + 10.0, 30.0, 20.0) withAttributes:attributes13];
        
        CGContextSetLineWidth(context, 3.0);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 5), 5, [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] CGColor]);
        CGContextSetRGBStrokeColor(context, 0.0, 0.5, 0.9, 1.0);
        CGContextSetRGBFillColor(context, 0.0, 0.5, 0.9, 1.0);
        
        
        if (i == start) {
            CGContextMoveToPoint(context, (i - start) * dx + startingPoint.x + 3.0, startingPoint.y - y - 3.0);
        } else {
            CGContextAddLineToPoint(context, (i - start) * dx + startingPoint.x + 3.0, startingPoint.y - y - 3.0);
        }
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetShadow(context, CGSizeZero, 0);
    
    
    //Schatten
    
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 3.0);
    
    //Achsen und Pfeile
    
    CGContextMoveToPoint(context, startingPoint.x, startingPoint.y);
    CGContextAddLineToPoint(context, startingPoint.x, startingPoint.y - yAxisLength);
    CGContextAddLineToPoint(context, startingPoint.x - 5.0, startingPoint.y - yAxisLength);
    CGContextAddLineToPoint(context, startingPoint.x, startingPoint.y - yAxisLength - 10.0);
    CGContextAddLineToPoint(context, startingPoint.x + 5.0, startingPoint.y - yAxisLength);
    CGContextAddLineToPoint(context, startingPoint.x, startingPoint.y - yAxisLength);
    CGContextMoveToPoint(context, startingPoint.x - 1.5, startingPoint.y);
    CGContextAddLineToPoint(context, startingPoint.x + xAxisLength, startingPoint.y);
    CGContextAddLineToPoint(context, startingPoint.x + xAxisLength, startingPoint.y - 5.0);
    CGContextAddLineToPoint(context, startingPoint.x + xAxisLength + 10.0, startingPoint.y);
    CGContextAddLineToPoint(context, startingPoint.x + xAxisLength, startingPoint.y + 5.0);
    CGContextAddLineToPoint(context, startingPoint.x + xAxisLength, startingPoint.y);
    
    
    //Skala
    
    for (int i = 1; i <= 10; i++) {
        CGContextMoveToPoint(context, startingPoint.x - 5.0 + 2.0 * (pow(-1.0, (double)(i - 1)) - 1), startingPoint.y - 20.0 * i - 3.0);
        CGContextAddLineToPoint(context, startingPoint.x + 5.0 - 2.0 * (pow(-1.0, (double)(i - 1)) - 1), startingPoint.y - 20.0 * i - 3.0);
    }
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [@"20" drawInRect:CGRectMake(15.0, startingPoint.y - 52.0, 30.0, 30.0) withAttributes:attributes16];
    [@"40" drawInRect:CGRectMake(15.0, startingPoint.y - 92.0, 30.0, 30.0) withAttributes:attributes16];
    [@"60" drawInRect:CGRectMake(15.0, startingPoint.y - 132.0, 30.0, 30.0) withAttributes:attributes16];
    [@"80" drawInRect:CGRectMake(15.0, startingPoint.y - 172.0, 30.0, 30.0) withAttributes:attributes16];
    [@"100" drawInRect:CGRectMake(9.0, startingPoint.y - 212.0, 30.0, 30.0) withAttributes:attributes16];
    [@"%" drawInRect:CGRectMake(18.0, startingPoint.y - 237.0, 30.0, 30.0) withAttributes:attributes16];
    
    CGContextBeginPath(context);
    
    for (int i = 1; i <= 7; i++) {
        CGContextMoveToPoint(context, startingPoint.x + i * dx + 3.0, startingPoint.y - 5.0);
        CGContextAddLineToPoint(context, startingPoint.x + i * dx + 3.0, startingPoint.y  + 5.0);
    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    //Überschrift
    
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    
    
    CGRect roundedRect = CGRectMake(20.0, 15.0, 280.0, 40.0);
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
    
    [NSLocalizedString(@"Anteil richtiger Lösungen insgesamt", nil) drawInRect:CGRectMake(20, 25.0, 280.0, 40.0) withAttributes:attributes15];
    
    
    
    
    
    
    
}

@end
