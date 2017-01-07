//
//  DiagramView.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 18.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Vokabel;
@class Kategorie;

@interface DiagramView : UIView
{
    NSMutableArray *angleArray;
    int rightValue;
    int falseValue;
    int gesamt;
}

- (void)diagramWithDataArray;

@end
