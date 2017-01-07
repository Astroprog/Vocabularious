//
//  BackupViewController.m
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 12.04.13.
//  Copyright (c) 2013 PetJan. All rights reserved.
//

#import "BackupViewController.h"
#import "AccessoryView.h"
#import "CustomCell.h"
#import "CustomButton.h"
#import "AddBackgroundView.h"
#import "HeaderView.h"
#import "LoadingIndicator.h"
#import "BlurView.h"

NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;
NSMutableArray *graphArray;
NSMutableArray *languages;
CGFloat mainScreenHeight;

@implementation BackupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        AddBackgroundView *backgroundView = [[AddBackgroundView alloc] initWithFrame:[self.view bounds]];
        [self.view addSubview:backgroundView];
        [self.view sendSubviewToBack:backgroundView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    documentPaths = [[NSArray alloc] init];
    documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [documentPaths objectAtIndex:0];
    
//    tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    //tableView.frame = self.view.frame;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    //tableView.separatorColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:tableView];
    CGRect frame = tableView.frame;
    frame.origin.y += mainScreenHeight;
    tableView.frame = frame;
    //    tableView.canCancelContentTouches = NO;
    
    //exportButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 20.0, 280.0, 44.0)];
    [exportButton setTitle:NSLocalizedString(@"Backup exportieren", nil) forState:UIControlStateNormal];
    //[exportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //showBackupsButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 80.0, 280.0, 44.0)];
    //[showBackupsButton setTitle:NSLocalizedString(@"Vorhandene Backups anzeigen", nil) forState:UIControlStateNormal];
    //[showBackupsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [exportButton addTarget:self action:@selector(pushExport:) forControlEvents:UIControlEventTouchUpInside];
    //[showBackupsButton addTarget:self action:@selector(pushShowBackups:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.view addSubview:exportButton];
    //[self.view addSubview:showBackupsButton];
    
    indicatorBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, mainScreenHeight)];
    indicatorBackgroundView.backgroundColor = [UIColor clearColor];
    indicatorBackgroundView.alpha = 0.0;
    indicator = [[LoadingIndicator alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, self.view.frame.size.width, 80.0)];
    [indicatorBackgroundView addSubview:indicator];
    [self.view addSubview:indicatorBackgroundView];
    blurView = [[BlurView alloc] initWithFrame:indicatorBackgroundView.frame];
    [indicatorBackgroundView addSubview:blurView];
    [indicatorBackgroundView sendSubviewToBack:blurView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = NSLocalizedString(@"Backups", nil);
    dataArray = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [dataArray addObjectsFromArray:[fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL]];
    backupFilesArray = [[NSMutableArray alloc] init];
    [self updateBackupArray];
    [tableView reloadData];
    tableShown = NO;
    //showBackupsButton.titleLabel.text = NSLocalizedString(@"Vorhandene Backups anzeigen", nil);
    exportButton.titleLabel.text = NSLocalizedString(@"Backup exportieren", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateBackupArray {
    [backupFilesArray removeAllObjects];
    [dataArray removeAllObjects];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [dataArray addObjectsFromArray:[fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL]];
    for (int i = 0; i<[dataArray count]; i++)
    {
        NSString *stringFromArray = [dataArray objectAtIndex:i];
        
        if ([stringFromArray length] >= 5)
        {
            NSRange range = NSMakeRange([stringFromArray length]-4, 4);
            NSString *extension = [stringFromArray substringWithRange:range];
            if ([extension isEqualToString:@".vcb"])
            {
                [backupFilesArray addObject:stringFromArray];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [backupFilesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    /*
    AccessoryView *accessory = [AccessoryView accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor blackColor];
    //    cell.accessoryView = accessory;
    //    cell.accessoryType = UITableViewCellAccessoryNone;
    */
    cell.textLabel.text = [[backupFilesArray objectAtIndex:indexPath.row] stringByDeletingPathExtension];
    
    return cell;
}

- (void)tableView:(UITableView *)tempTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* pathAsString = [paths objectAtIndex:0];
    NSString *fileString = [NSString stringWithFormat:@"/%@",[backupFilesArray objectAtIndex:indexPath.row]];
    fileImportPath = [pathAsString stringByAppendingString:fileString];
    //    NSLog(@"fileIP I: %@", fileImportPath);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Import Backup" message:NSLocalizedString(@"Wirklich alle Daten in Vocabularious überschreiben?", nil) delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView show];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20.0)];
    headerView.textLabel.text = NSLocalizedString(@"Backups", nil);
    return headerView;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && [alertView.title isEqualToString:@"Import Backup"]) {
        /*BOOL success = */
        [self importBackupFromFile:fileImportPath];
        //        NSLog(@"success %d", success);
        fileImportPath = nil;
        //        NSLog(@"fileIP II: %@", fileImportPath);
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Backups", nil);
}

- (BOOL)importBackupFromFile:(NSString *)filePath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *importBackupDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSNumber *rightNum = [importBackupDic objectForKey:@"rightNumber"];
    int rightNumber = [rightNum integerValue];
    
    NSNumber *hideV = [importBackupDic objectForKey:@"hideVocs"];
    int hideVocs = [hideV integerValue];
    
    NSNumber *hidePic = [importBackupDic objectForKey:@"hidePictures"];
    int hidePictures = [hidePic integerValue];
    
    NSNumber *homeStringWillBe = [importBackupDic objectForKey:@"homeStringWillBeDisplayedFirst"];
    BOOL homeStringWillBeDisplayedFirst = [homeStringWillBe boolValue];
    
    NSString *sorting = [importBackupDic objectForKey:@"sorting"];
    NSString *sortingOrder = [importBackupDic objectForKey:@"sortingOrder"];
    
    NSData *kategorieData = [importBackupDic objectForKey:@"kategorieData"];
    NSData *collectionData = [importBackupDic objectForKey:@"collectionData"];
    NSData *graphData = [importBackupDic objectForKey:@"graphData"];
    NSData *languagesData = [importBackupDic objectForKey:@"languagesData"];
    
    NSMutableArray *kategorieImportArray = [NSKeyedUnarchiver unarchiveObjectWithData:kategorieData];
    NSMutableArray *collectionImportArray = [NSKeyedUnarchiver unarchiveObjectWithData:collectionData];
    NSMutableArray *graphImportArray = [NSKeyedUnarchiver unarchiveObjectWithData:graphData];
    NSMutableArray *languagesImportArray = [NSKeyedUnarchiver unarchiveObjectWithData:languagesData];
    
    [kategorieArray removeAllObjects];
    [collectionArray removeAllObjects];
    [graphArray removeAllObjects];
    [languages removeAllObjects];
    [kategorieArray addObjectsFromArray:kategorieImportArray];
    [collectionArray addObjectsFromArray:collectionImportArray];
    [graphArray addObjectsFromArray:graphImportArray];
    [languages addObjectsFromArray:languagesImportArray];
    
    [defaults setBool:homeStringWillBeDisplayedFirst forKey:@"homeStringWillBeDisplayedFirst"];
    [defaults setInteger:hideVocs forKey:@"hideVocs"];
    [defaults setInteger:hidePictures forKey:@"hidePictures"];
    [defaults setInteger:rightNumber forKey:@"rightNumber"];
    [defaults setObject:sorting forKey:@"sorting"];
    [defaults setObject:sortingOrder forKey:@"sortingOrder"];
    
    return YES;
}

- (void)exportBackupToFilePath:(NSString *)filePath {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        indicatorBackgroundView.alpha = 1.0;
    }completion:nil];
    [indicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int rightNum = [defaults integerForKey:@"rightNumber"];
    NSNumber *rightNumber = [NSNumber numberWithInt:rightNum];
    
    BOOL homeStringWillBe = [defaults boolForKey:@"homeStringWillBeDisplayedFirst"];
    NSNumber *homeStringWillBeDisplayedFirst = [NSNumber numberWithBool:homeStringWillBe];
    
    NSString *sorting = [defaults stringForKey:@"sorting"];
    
    NSString *sortingOrder = [defaults stringForKey:@"sortingOrder"];
    
    int hideV = [defaults integerForKey:@"hideVocs"];
    NSNumber *hideVocs = [NSNumber numberWithInt:hideV];
    
    int hidePic = [defaults integerForKey:@"hidePictures"];
    NSNumber *hidePictures = [NSNumber numberWithInt:hidePic];
    
    NSData *kategorieData = [NSKeyedArchiver archivedDataWithRootObject:kategorieArray];
    NSData *collectionData = [NSKeyedArchiver archivedDataWithRootObject:collectionArray];
    NSData *graphData = [NSKeyedArchiver archivedDataWithRootObject:graphArray];
    NSData *languagesData = [NSKeyedArchiver archivedDataWithRootObject:languages];
    
    NSArray *objectArray = [NSArray arrayWithObjects:kategorieData, collectionData, graphData, languagesData, rightNumber, homeStringWillBeDisplayedFirst, sorting, sortingOrder, hideVocs, hidePictures, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:@"kategorieData", @"collectionData", @"graphData", @"languagesData", @"rightNumber", @"homeStringWillBeDisplayedFirst", @"sorting", @"sortingOrder", @"hideVocs", @"hidePictures", nil];
    
    NSMutableDictionary *backupDictionary = [[NSMutableDictionary alloc] initWithObjects:objectArray forKeys:keyArray];
    [backupDictionary writeToFile:filePath atomically:YES];
}

- (void)pushExport:(id)selector {
    [self updateBackupArray];
    [tableView reloadData];
    [blurView setViewToBlur:self.view];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setDateFormat:NSLocalizedString(@"dd-MM-YY HH:mm", nil)];
    
    NSString *date = [dateFormatter stringFromDate:currentDate];
    NSLog(@"Date %@", date);
    
    NSString* finalPath = [NSString stringWithFormat:@"%@/Backup %@.vcb", documentsDirectory, date];
    
    NSLog(@"docu %@", finalPath);
    
    indicator.loading.text = [NSLocalizedString(@"Exportieren", nil) stringByAppendingString:@"..."];
    [self performSelectorOnMainThread:@selector(exportBackupToFilePath:) withObject:finalPath waitUntilDone:YES];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            indicatorBackgroundView.alpha = 0.0;
        }completion:^(BOOL finishedCompletion){
            [indicator stopAnimating];
        }];
    });
    
    int currentCount = [backupFilesArray count];
    NSLog(@"currentCount %d", currentCount);
    [self updateBackupArray];
    NSLog(@"update count : %d", [backupFilesArray count]);
    if (currentCount < [backupFilesArray count]) {
        NSIndexPath *NewAccountPath =[NSIndexPath indexPathForRow:[backupFilesArray count] - 1 inSection:0];
        NSArray *newAccountPaths = [NSArray arrayWithObject:NewAccountPath];
        [tableView insertRowsAtIndexPaths:newAccountPaths withRowAnimation:YES];
    }
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Backup exportiert", nil) message:NSLocalizedString(@"Das Backup wurde erfolgreich in iTunes gespeichert.", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    });
}
/*
- (void)pushShowBackups:(id)selector {
    if (!tableShown) {
        [self updateBackupArray];
        [tableView reloadData];
        [UIView animateWithDuration:0.4 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
            if (mainScreenHeight != 568.0) {
                CGRect frame = tableView.frame;
                frame.origin.y -= 339.0;
                frame.size.height = 276.0;
                tableView.frame = frame;
            }
            else {
                CGRect frame = tableView.frame;
                frame.origin.y -= 422.0;
                frame.size.height = 360.0;
                tableView.frame = frame;
            }
        } completion:nil];
        [showBackupsButton setTitle:NSLocalizedString(@"Vorhandene Backups ausblenden", nil) forState:UIControlStateNormal];
        tableShown = YES;
    }
    
    else if (tableShown) {
        [UIView animateWithDuration:0.4 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
            if (mainScreenHeight != 568.0) {
                CGRect frame = tableView.frame;
                frame.origin.y += 339.0;
                tableView.frame = frame;
            }
            else {
                CGRect frame = tableView.frame;
                frame.origin.y += 422.0;
                tableView.frame = frame;
            }
        } completion:nil];
        [showBackupsButton setTitle:NSLocalizedString(@"Vorhandene Backups anzeigen", nil) forState:UIControlStateNormal];
        tableShown = NO;
        [tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
}

*/

@end
