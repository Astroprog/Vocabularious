//
//  EditPickerViewController.h
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 05.08.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditLanguageViewController;

extern int selectedForChange;

@interface EditPickerViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    enum {
        foreign
    };
    IBOutlet EditLanguageViewController *editLanguageViewController;
}

- (void)doneView:(id)selector;

@end
