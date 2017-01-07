//
//  VocView.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 16.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VocView : UIView <UIScrollViewDelegate> {
    NSString *drawString;
    NSString *drawName;
    UILabel *drawLabel;
    UIScrollView *drawScrollView;
}

- (void)setDrawString:(NSString *)string andName:(NSString *)name;

@property (readwrite) BOOL green;
@end
