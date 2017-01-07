//
//  BlurView.m
//  Voc7
//
//  Created by Maximilian Scheurer on 12.04.14.
//  Copyright (c) 2014 Maximilian Scheurer. All rights reserved.
//

#import "BlurView.h"
#import <GPUImage/GPUImage.h>


@implementation BlurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _radius = 0.7;
    }
    return self;
}

- (void)setViewToBlur:(UIView*)view {
    //NSLog(@"blurring");
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width,view.frame.size.height));
    CGContextRef context=UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//
//    CIContext *newContext = [CIContext contextWithOptions:nil];
//    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
//    
//    //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:inputImage forKey:kCIInputImageKey];
//    [filter setValue:[NSNumber numberWithFloat:50.0f] forKey:@"inputRadius"];
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
//    CGImageRef cgImage = [newContext createCGImage:result fromRect:[inputImage extent]];
    GPUImageiOSBlurFilter* blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = _radius;
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
    [picture addTarget:blurFilter];
    [picture processImage];
    
    //UIImageWriteToSavedPhotosAlbum([picture imageFromCurrentlyProcessedOutput], nil, nil, nil);
    NSAssert([blurFilter imageFromCurrentlyProcessedOutput] != nil, nil);
    self.image = [blurFilter imageFromCurrentlyProcessedOutput];
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
