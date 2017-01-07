//
//  SelectKategorieViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 22.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class StatisticsController;
@class Kategorie;

@interface SelectKategorieViewController : UITableViewController {
    IBOutlet RootViewController *rootViewController;
    IBOutlet StatisticsController *statisticsController;
}

- (void)doneView:(id)sender;

@property (readwrite) BOOL collection;
@property (readwrite) int selectedKategorieIndex; // for masterVC --> add to Kategorie
@property (readwrite) BOOL fromMasterViewController;
@end
