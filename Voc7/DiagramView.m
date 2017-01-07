//
//  DiagramView.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 18.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "DiagramView.h"
#import "Vokabel.h"
#import "Kategorie.h"
#import "Sammlung.h"

Kategorie *currentKategorie;
Kategorie *statisticsKategorie;
Sammlung *statisticsCollection;
BOOL selectedCollection;
CGFloat mainScreenHeight;

@implementation DiagramView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)diagramWithDataArray
{
    angleArray = [[NSMutableArray alloc] init];
    
    rightValue = 0;
    falseValue = 0;
    gesamt = 0;
        
    int rightLimit = 3;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"rightNumber"]) {
        rightLimit = [defaults integerForKey:@"rightNumber"];
    }
    
    if (selectedCollection) {
        for (Vokabel *voc in statisticsCollection.vocArray) {
            if (voc.rightCount == rightLimit) {
                rightValue++;
            } else {
                falseValue++;
            }
            gesamt++;
        }
    } else {
        for (Vokabel *voc in statisticsKategorie.vocArray) {
            if (voc.rightCount == rightLimit) {
                rightValue++;
            } else {
                falseValue++;
            }
            gesamt++;
        }
    }
    
    double wert1 = ((double)rightValue / (double)gesamt) * 2 * M_PI - 0.5 * M_PI;
    double wert2 = ((double)falseValue / (double)gesamt) * 2 * M_PI + wert1;
    NSNumber *number1 = [[NSNumber alloc] initWithDouble:wert1];
    NSNumber *number2 = [[NSNumber alloc] initWithDouble:wert2];
    [angleArray addObject:number1];
    [angleArray addObject:number2];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self diagramWithDataArray];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Hintergrundfarbe
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, [self bounds]);
    
    //Schattenoffset
    CGSize shadowOffset = CGSizeMake (0, 0);

    //Grüner Schatten für Diagramm
    CGContextSetShadowWithColor(context, shadowOffset, 10, [[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0] CGColor]);
    
    //Grüner Diagrammteil
    
    CGPoint center;
    
    if (mainScreenHeight == 568.0) {
        center = CGPointMake(160, 280);
    } else {
        center = CGPointMake(160, 240);
    }
    
    
    if (rightValue < gesamt) {
        
        CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, center.x, center.y);
        CGContextAddArc(context, center.x, center.y, 75, 1.5 * M_PI, [[angleArray objectAtIndex:0] doubleValue], 0);
        CGContextClosePath(context);
        
        CGContextSetLineWidth(context, 2.0);
        CGContextDrawPath(context, kCGPathFill);

    } else {
        if (rightValue == 0) {
            CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
            CGContextSetShadowWithColor(context, shadowOffset, 10, [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]);
            CGContextAddEllipseInRect(context, CGRectMake(center.x - 75, center.y - 75, 150, 150));
            CGContextDrawPath(context, kCGPathFill);
        } else {
            CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
            CGContextSetShadowWithColor(context, shadowOffset, 10, [[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0] CGColor]);
            CGContextAddEllipseInRect(context, CGRectMake(center.x - 75, center.y - 75, 150, 150));
            CGContextDrawPath(context, kCGPathFill);
        }
    }
        
    //Roter Diagrammteil
    CGContextSetShadowWithColor(context, shadowOffset, 10, [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, 75, [[angleArray objectAtIndex:0] doubleValue], 1.5 * M_PI, 0);    
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextDrawPath(context, kCGPathFill);
    
    //Rechteck mit runden Ecken
    
    CGContextSetShadowWithColor(context, shadowOffset, 5, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor]); 
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    
    
    CGRect roundedRect = CGRectMake(20.0, 60.0, 280.0, 80.0);
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
    CGContextMoveToPoint(context, 20.0, midy); //20
    CGContextAddLineToPoint(context, 300.0, midy); //300
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
    
    //Datenanzeige
    
    CGContextSetShadowWithColor(context, shadowOffset, 5, [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]);
    CGContextFillRect(context, CGRectMake(minx + 15.0, miny + 15.0, 10.0, 10.0));
    
//    CGContextSetShadowWithColor(context, shadowOffset, 5, [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] CGColor]);
    CGContextSetShadow(context, CGSizeZero, 0.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    
    UIFont *font15 = [UIFont fontWithName:@"Helvetica" size:15.0f];
    UIFont *font20 = [UIFont fontWithName:@"Helvetica" size:20.0f];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes15 = @{NSFontAttributeName:font15, NSParagraphStyleAttributeName:paragraphStyle};
    NSDictionary *attributes20 = @{NSFontAttributeName:font20, NSParagraphStyleAttributeName:paragraphStyle};
    
    if (gesamt) {
        
        [[NSString stringWithFormat:NSLocalizedString(@":  Noch nicht sicher (%d %%)", nil), (int)((float)falseValue / (float)gesamt * 100)] drawInRect:CGRectMake(minx + 30.0, miny + 10, 250, 15) withAttributes:attributes15];
        
        if (selectedCollection) {
            if ([statisticsCollection.name length] > 20) {
                [[NSString stringWithFormat:NSLocalizedString(@"Sammlung: %@", nil), statisticsCollection.name] drawInRect:CGRectMake(20.0, 17.0, 260, 30) withAttributes:attributes15];
            } else {
                [[NSString stringWithFormat:NSLocalizedString(@"Sammlung: %@", nil), statisticsCollection.name] drawInRect:CGRectMake(20.0, 17.0, 260, 30) withAttributes:attributes20];
            }
        } else {
            if ([statisticsKategorie.kategorieName length] > 20) {
                [[NSString stringWithFormat:NSLocalizedString(@"Liste: %@", nil), statisticsKategorie.kategorieName] drawInRect:CGRectMake(20.0, 17.0, 260, 30) withAttributes:attributes15];
            } else {
                [[NSString stringWithFormat:NSLocalizedString(@"Liste: %@", nil), statisticsKategorie.kategorieName] drawInRect:CGRectMake(20.0, 17.0, 260, 30) withAttributes:attributes20];
            }
        }

    } else {
        
        [[NSString stringWithFormat:NSLocalizedString(@"Liste auswählen", nil)] drawInRect:CGRectMake(20.0, 17.0, 260, 30) withAttributes:attributes20];
        
        [[NSString stringWithFormat:NSLocalizedString(@":  Keine Liste ausgewählt", nil)] drawInRect:CGRectMake(minx + 30.0, miny + 10, 250, 15) withAttributes:attributes15];
    }
       
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
    
    CGContextSetShadowWithColor(context, shadowOffset, 5, [[UIColor colorWithRed:0.5 green:1.0 blue:0.0 alpha:1.0] CGColor]);
    CGContextFillRect(context, CGRectMake(minx + 15.0, midy + 15.0, 10.0, 10.0));
    
    CGContextSetShadowWithColor(context, shadowOffset, 5, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor]); 
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    if (gesamt) {
        [[NSString stringWithFormat:NSLocalizedString(@":  Sicher (%d %%)", nil), (int)((float)rightValue / (float)gesamt * 100)] drawInRect:CGRectMake(minx + 30.0, midy + 10, 250, 15) withAttributes:attributes15];
    } else {
        [[NSString stringWithFormat:NSLocalizedString(@":  Keine Liste ausgewählt", nil)] drawInRect:CGRectMake(minx + 30.0, midy + 10, 250, 15) withAttributes:attributes15];
    }
        
}


@end
