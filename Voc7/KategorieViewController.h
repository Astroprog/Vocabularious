//
//  KategorieViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 20.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSMutableArray *kategorieArray;

@class Kategorie;
@class MasterViewController;
@class AddKategorieViewController;

@interface KategorieViewController : UITableViewController {
    IBOutlet MasterViewController *masterViewController;
    IBOutlet AddKategorieViewController *addKategorieViewController;
    
    Kategorie *editingKategorie;
    
    int currentCount;
    BOOL fromAddKategorie;
}

- (void)pushAdd:(id)sender;

@end
