//
//  VocInfoAddView.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 20.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VocInfoViewController;

@interface VocInfoAddView : UIView <UITextFieldDelegate>
{
    IBOutlet VocInfoViewController *infoViewController;
    IBOutlet UIButton *editPictureButton;
}

- (void)reloadTextFieldsWithGermanString:(NSString *)firstString andForeignString:(NSString *)secondString andReminderString:(NSString *)thirdString;
- (void)editPicture:(id)sender;
- (void)keyboardWillShow;
- (void)keyboardWillHide;

@property (strong) UILabel *germanLabel;
@property (strong) UILabel *foreignLabel;
@property (strong) UILabel *reminderLabel;
@property (strong) UILabel *pictureLabel;
@property (strong) UITextField *foreignField;
@property (strong) UITextField *germanField;
@property (strong) UITextField *reminderField;
@end
