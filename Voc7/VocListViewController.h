//
//  VocListViewController.h
// Former: MasterViewController.h (MS)
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 17.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Vokabel;
@class VocInfoViewController;
@class AddVocViewController;
@class RootViewController;
@class Kategorie;
@class FileManagerViewController;
@class FileImportViewController;
@class SelectKategorieViewController;
@class LoadingIndicator;

@interface VocListViewController : UIViewController <UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UIToolbarDelegate>
{
    IBOutlet VocInfoViewController *vocInfoViewController;
    IBOutlet AddVocViewController *addVocViewController;
    IBOutlet FileManagerViewController *fileManagerViewController;
    IBOutlet FileImportViewController *fileImportViewController;
    IBOutlet SelectKategorieViewController *selectController;
    
    IBOutlet UITableView *tableView;
    IBOutlet UIToolbar *toolbar;
    NSMutableArray *editingVocs;
    NSMutableArray *searchItems;
    NSMutableArray *sortedArray;
    BOOL canceledImport;
    BOOL fromVocInfo;
    BOOL sorting;
    BOOL editingAll;
    LoadingIndicator *indicator;
    NSArray *selectedVocs;
    
    UIBarButtonItem *flexible, *trashItem, *saveItem, *searchItem, *addItem, *deleteSelection, *addToKategorieItem;
    UIView *backgroundView;
}

- (void)pushAdd:(id)sender;
- (void)pushDone:(id)sender;
- (void)pushDelete:(id)sender;
- (void)pushDeleteSelection:(id)sender;
- (void)pushSave:(id)sender;
- (void)pushSearch:(id)sender;
- (void)openMail:(id)sender;
- (id)produceFileForMail;
- (void)addNewVocsFromArray:(NSMutableArray *)newArray;
- (void)tableViewDidChangeRowSelection:(id)selector;
- (void)importVocsFromItunes:(id)selector;
- (void)showSelectKategorie:(id)selector;
- (void)addSelectedWordsToKategorie;

@property (nonatomic, retain) UISearchDisplayController *searchController;
@property (nonatomic, retain) Vokabel *editingVoc;
@property (nonatomic, retain) Kategorie *tempKategorie;
@property (readwrite) BOOL canceled;
@end