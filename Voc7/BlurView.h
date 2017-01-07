//
//  BlurView.h
//  Voc7
//
//  Created by Maximilian Scheurer on 12.04.14.
//  Copyright (c) 2014 Maximilian Scheurer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlurView : UIImageView
{
    
}

-(void)setViewToBlur:(UIView*)view;

@property (readwrite) double radius;
@end
