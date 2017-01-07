//
//  ResetCounterViewController.h
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 09.04.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Vokabel;
@class VocExchanger;

@interface ResetCounterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    enum {
        Kategorien, Sammlungen
    };
    UITableView *tableView;
    UIToolbar *toolbar;
    UIBarButtonItem *resetButton;
    UIBarButtonItem *resetAllButton;
    VocExchanger *exchanger;
}

- (void)resetChosen:(id)sender;
- (void)resetAll:(id)sender;
- (void)tableViewDidChangeRowSelection:(id)selector;


@end
