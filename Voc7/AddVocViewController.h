//
//  AddVocViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 17.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@class Vokabel;
@class MasterViewController;
@class AddLabel;
@class CustomButton;

extern BOOL list;

@interface AddVocViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UITextField *germanField;
    IBOutlet UITextField *foreignField;
    IBOutlet UILabel *foreignLanguageLabel;
    IBOutlet UILabel *homeLanguageLabel;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIBarButtonItem *pushButton;
    IBOutlet UITextField *reminderField;
   // IBOutlet UIButton *addPictureButton;
   // IBOutlet UIButton *addVocButton;
    
    UIButton *addPictureButton;
    UIButton *addVocButton;
    
    AddLabel *addLabel;
    
    Vokabel *addVoc;
    BOOL locked;
    BOOL secondField;
    BOOL thirdField;
    
    UIImagePickerController *cameraUI;
    UIImage *vocImage;
    UIImageView *imageView;
    BOOL pickedImage;
    BOOL cameraAvailable;
}

- (void)cancelView:(id)sender;
- (void)doneView:(id)sender;

- (IBAction)pushAddVoc:(id)sender;
- (IBAction)pushNext:(id)sender;
- (void)pushAddPicture:(id)sender;
- (void)changeTextFieldNotification:(id)selector;
- (void)startEditingTextFieldNotification:(id)selector;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

-(UIImage *)scaleImage:(UIImage *)image;


@property (nonatomic, retain) IBOutlet UIView *keyboardToolbar;
@property (nonatomic, retain) NSMutableArray *addVocs;
@property (nonatomic, retain) NSString *foreignLanguage;
@property (readwrite) BOOL canceled;
@end
