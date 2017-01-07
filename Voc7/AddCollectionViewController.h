//
//  AddCollectionViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 01.09.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCollectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *nameTextField;
    IBOutlet UITableView *tableView;
    UIBarButtonItem *doneItem;
    BOOL userDidSelectKategorie;
}

- (void)pushDone:(id)sender;
- (void)pushCancel:(id)sender;
- (void)startEditingTextFieldNotification:(id)selector;
- (void)changeTextFieldNotification:(id)selector;
- (void)tableViewDidChangeRowSelection:(id)selector;
- (NSMutableArray *)selectedKategoriesInCollection;

@property (readwrite) BOOL editingCollection;
@property (readwrite) int indexOfEditingCollection;

@end
