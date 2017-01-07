//
//  BackupViewController.h
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 12.04.13.
//  Copyright (c) 2013 PetJan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadingIndicator;
@class BlurView;

@interface BackupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

{
    IBOutlet UITableView *tableView;
    NSMutableArray *dataArray;
    NSMutableArray *backupFilesArray;
    NSString *fileImportPath;
    
    IBOutlet UIButton *exportButton;
    //IBOutlet UIButton *showBackupsButton;
    BOOL tableShown;
    
    NSArray *documentPaths;
    NSString *documentsDirectory;
    LoadingIndicator *indicator;
    UIView *indicatorBackgroundView;
    BlurView *blurView;
}

- (BOOL)importBackupFromFile:(NSString *)filePath;
- (void)exportBackupToFilePath:(NSString *)filePath;
- (void)pushExport:(id)selector;
//- (void)pushShowBackups:(id)selector;
- (void)updateBackupArray;

@end
