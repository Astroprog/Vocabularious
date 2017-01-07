//
//  RightNumberChangeControllerViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 01.08.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightNumberViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIPickerView *pickerView;
}

@end
