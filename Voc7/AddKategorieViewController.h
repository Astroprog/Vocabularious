//
//  AddKategorieViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 20.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Kategorie;
@class KategorieViewController;

@interface AddKategorieViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    Kategorie *addKategorie;
    
    IBOutlet UITextField *languageField;
    IBOutlet UIPickerView *languagePicker;
    IBOutlet UILabel *languageLabel;
    IBOutlet UILabel *nameLabel;
    NSString *language;
}
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end
