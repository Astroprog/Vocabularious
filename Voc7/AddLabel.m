//
//  AddLabel.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 27.06.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "AddLabel.h"

@implementation AddLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 30)];
        firstLabel.textColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255.0 alpha:1];
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.font = [UIFont fontWithName:@"Helvetica" size:25.0];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:firstLabel];
        
        secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 200, 30)];
        secondLabel.textColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255.0 alpha:1];
        secondLabel.backgroundColor = [UIColor clearColor];
        secondLabel.font = [UIFont fontWithName:@"Helvetica" size:23.0];
        secondLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:secondLabel];
        
        firstLabel.text = NSLocalizedString(@"Vokabel", nil);
        secondLabel.text = NSLocalizedString(@"hinzugefügt", nil);


    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0.65, 0.65, 0.65, 0.9);
    
    CGSize shadowOffset = CGSizeMake (0, 0);
    CGContextSetShadowWithColor(context, shadowOffset, 10, [[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] CGColor]); 
    
    
    CGRect roundedRect = CGRectMake(10.0, 10.0, 180.0, 80.0); 
    CGFloat radius = 10.0; 
    
    CGFloat minx = CGRectGetMinX(roundedRect), midx = CGRectGetMidX(roundedRect), maxx = CGRectGetMaxX(roundedRect); 
    CGFloat miny = CGRectGetMinY(roundedRect), midy = CGRectGetMidY(roundedRect), maxy = CGRectGetMaxY(roundedRect); 
    
    CGContextMoveToPoint(context, minx, midy); 
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius); 
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius); 
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius); 
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius); 
    CGContextClosePath(context); 
    
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    
    

}

@end
