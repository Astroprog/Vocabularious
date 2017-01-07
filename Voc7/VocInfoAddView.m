//
//  VocInfoAddView.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 20.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "VocInfoAddView.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomButton.h"
#import "VocInfoViewController.h"

BOOL imageSet;
CGFloat mainScreenHeight;

@implementation VocInfoAddView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.7;
        self.layer.masksToBounds = NO;
        //self.layer.cornerRadius = 4; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 10;
        //self.layer.shadowOpacity = 0.7;
        //self.layer.shadowColor = [[UIColor whiteColor] CGColor];
        
        self.germanLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 100, 20)];
        self.germanLabel.textColor = [UIColor whiteColor];
        self.germanLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.germanLabel];
        self.germanLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"homeLanguage"] stringByAppendingString:@":"];
        
        self.foreignLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 85, 100, 20)];
        self.foreignLabel.textColor = [UIColor whiteColor];
        self.foreignLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.foreignLabel];
//        foreignLabel.text = @"Englisch:";
        
        self.reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 135, 100, 20)];
        self.reminderLabel.textColor = [UIColor whiteColor];
        self.reminderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.reminderLabel];
        self.reminderLabel.text = NSLocalizedString(@"Reminder:", nil);
        
        self.pictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 188.0-15.0, 100, 20)];
        self.pictureLabel.textColor = [UIColor whiteColor];
        self.pictureLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.pictureLabel];
        self.pictureLabel.text = NSLocalizedString(@"Bild:", nil);
        
        self.germanField = [[UITextField alloc] initWithFrame:CGRectMake(120, 30, 160, 31)];
        self.foreignField = [[UITextField alloc] initWithFrame:CGRectMake(120, 80, 160, 31)];
        self.reminderField = [[UITextField alloc] initWithFrame:CGRectMake(120, 130, 160, 31)];
        
        self.germanField.borderStyle = UITextBorderStyleRoundedRect;
        self.germanField.font = [UIFont systemFontOfSize:15];
        self.germanField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.germanField.keyboardType = UIKeyboardTypeDefault;
        self.germanField.returnKeyType = UIReturnKeyDone;
        self.germanField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.germanField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.germanField.delegate = self;

        self.foreignField.borderStyle = UITextBorderStyleRoundedRect;
        self.foreignField.font = [UIFont systemFontOfSize:15];
        self.foreignField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.foreignField.keyboardType = UIKeyboardTypeDefault;
        self.foreignField.returnKeyType = UIReturnKeyDone;
        self.foreignField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.foreignField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.foreignField.delegate = self;
        
        self.reminderField.borderStyle = UITextBorderStyleRoundedRect;
        self.reminderField.font = [UIFont systemFontOfSize:15];
        self.reminderField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.reminderField.keyboardType = UIKeyboardTypeDefault;
        self.reminderField.returnKeyType = UIReturnKeyDone;
        self.reminderField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.reminderField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.reminderField.delegate = self;
        [self addSubview:self.reminderField];
        [self addSubview:self.germanField];
        [self addSubview:self.foreignField];
        
        editPictureButton = [[UIButton alloc] initWithFrame:CGRectMake(120.0, 163.0, 160.0, 40.0)];
        [editPictureButton setTitle:NSLocalizedString(@"Bild bearbeiten", nil) forState:UIControlStateNormal];
        [editPictureButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
        [editPictureButton addTarget:self action:@selector(editPicture:) forControlEvents:UIControlEventTouchUpInside];
        [editPictureButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        [self addSubview:editPictureButton];

  
        
    }
    return self;
}

- (void)reloadTextFieldsWithGermanString:(NSString *)firstString andForeignString:(NSString *)secondString andReminderString:(NSString *)thirdString;
{
    self.germanField.text = firstString;
    self.foreignField.text = secondString;
    self.reminderField.text = thirdString;
    if (!imageSet) {
        [editPictureButton setTitle:NSLocalizedString(@"Bild hinzufügen", nil) forState:UIControlStateNormal];
    }
    else if (imageSet) {
        [editPictureButton setTitle:NSLocalizedString(@"Bild bearbeiten", nil) forState:UIControlStateNormal];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"return" object:infoViewController];
    [textField resignFirstResponder];
    self.germanField.text = @"";
    self.foreignField.text = @"";
    self.reminderField.text = @"";
    return YES;
}

- (void)editPicture:(id)sender {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editPicture" object:infoViewController];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)keyboardWillShow
{
    if (mainScreenHeight == 568.00) {
        return;
    }
    else {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.27];
    CGRect frame = editPictureButton.frame;
    frame.origin.y = editPictureButton.frame.origin.y + 25.0;
    editPictureButton.frame = frame;
    [UIView commitAnimations];
    }

}

- (void)keyboardWillHide
{
    if (mainScreenHeight == 568.0) {
        return;
    }
    else {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.27];
    CGRect frame = editPictureButton.frame;
    frame.origin.y = editPictureButton.frame.origin.y - 25.0;
    editPictureButton.frame = frame;
    [UIView commitAnimations];
    }
}

@end
