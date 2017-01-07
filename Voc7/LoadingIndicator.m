//
//  LoadingIndicator.m
//  Vocabularious
//
//  Created by Maximilian Scheurer on 17.05.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import "LoadingIndicator.h"

@implementation LoadingIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.center = CGPointMake(frame.size.width/2, 200.0);
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _loading = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/2, 200.0, 50.0)];
        _loading.center = CGPointMake(frame.size.width/2, 260.0);
        //_loading.textColor = [UIColor blackColor];
        _loading.textColor = [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1];
        _loading.backgroundColor = [UIColor clearColor];
        _loading.font = [UIFont fontWithName:@"Helvetica" size:25.0];
        _loading.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_loading];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
