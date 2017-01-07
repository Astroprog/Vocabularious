//
//  PreferencesController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 31.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditPickerViewController;

@interface PreferencesController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    enum {
        Abfrage,
        Sprachen,
        Daten,
        Info
    };
    
    UISwitch *vocSwitch;
    UISwitch *pictureSwitch;
    UITextField *homeTextField;
    IBOutlet UITableView *preferencesTableView;
    EditPickerViewController *editPickerViewController;
}

- (void)pushVocSwitch:(id)sender;
- (void)pushPictureSwitch:(id)sender;

@end
