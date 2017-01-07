//
//  VocInfoViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 17.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@class Vokabel;
@class VocInfoAddView;
@class BlurView;

extern BOOL imageSet;

@interface VocInfoViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    UILabel *rightLabel;
    UILabel *falseLabel;
    IBOutlet UILabel *foreignLanguageLabel;
    IBOutlet UILabel *homeLanguageLabel;
    UILabel *rightTitleLabel;
    UILabel *falseTitleLabel;
    IBOutlet UIScrollView *foreignScrollView;
    IBOutlet UIScrollView *homeScrollView;
    IBOutlet UIScrollView *reminderScrollView;
    
    VocInfoAddView *addView;
    BlurView *blurView;
    BOOL cameraAvailable;
    BOOL pickedImage;
    UIImagePickerController *cameraUI;
    UIImage *vocImage;
    UIImageView *imageView;
    
    BOOL removed;
    UIView *backgroundView;
}

- (void)textFieldDidReturn;
- (void)pushAddPicture:(id)selector;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

- (void)removeViewWithVocImage;
- (void)showViewWithVocImage:(UIImage *)image;
- (void)exchangeVocInCollectionWithOldVoc:(Vokabel *)oldVoc andNewVoc:(Vokabel *)newVoc;
- (void)exchangeVocInKategorieWithOldVoc:(Vokabel *)oldVoc andNewVoc:(Vokabel *)newVoc;


@property (strong) Vokabel *viewedVoc;
@property (strong) IBOutlet UILabel *germanLabel;
@property (strong) IBOutlet UILabel *foreignLabel;
@property (strong) IBOutlet UILabel *reminderLabel;
@property (readwrite) BOOL fromCollectionViewController;
@end
