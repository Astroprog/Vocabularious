//
//  EditLanguageViewController.h
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 06.08.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadingIndicator;


@interface EditLanguageViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

{
    IBOutlet UITextField *editField;
    UIBarButtonItem *doneItem;
    UIActivityIndicatorView *indicator;
    UIView *backgroundView;
}

- (void)doneView:(id)selector;
- (void)cancelView:(id)selector;
- (void)changeTextFieldNotification:(id)selector;
- (void)startEditingTextFieldNotification:(id)selector;

@property (strong) NSString* editingLanguage;
@end
