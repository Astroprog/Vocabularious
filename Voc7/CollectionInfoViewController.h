//
//  CollectionInfoViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 15.10.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Vokabel;
@class VocInfoViewController;
@class FileManagerViewController;
@class AddCollectionViewController;

@interface CollectionInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationBarDelegate, UIAlertViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIToolbar *toolbar;
    
    NSMutableArray *searchItems;
    NSMutableArray *editingVocs;
    BOOL fromVocInfo;
    Vokabel *tempVoc;
    IBOutlet VocInfoViewController *vocInfoViewControllerCollection;
    IBOutlet FileManagerViewController *fileManagerViewController;
    IBOutlet AddCollectionViewController *addCollectionViewController;
}

@property (readwrite) int collectionIndex;
@property (nonatomic, retain) UISearchDisplayController *searchController;
@property (nonatomic, retain) Vokabel *editingVoc;
@end

