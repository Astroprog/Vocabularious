//
//  AccessoryView.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 16.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessoryView : UIControl
{
    
}

+ (AccessoryView *)accessoryWithColor:(UIColor *)color;

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;
@end
