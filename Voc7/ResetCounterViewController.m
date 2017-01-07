//
//  ResetCounterViewController.m
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 09.04.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import "ResetCounterViewController.h"
#import "CustomCell.h"
#import "AccessoryView.h"
#import "Kategorie.h"
#import "Sammlung.h"
#import "Vokabel.h"
#import "HeaderView.h"
#import "VocExchanger.h"

NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;
CGFloat mainScreenHeight;

@implementation ResetCounterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Zähler zurücksetzen", nil);
    self.navigationController.navigationBar.translucent = NO;
    tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    CGRect frame = tableView.frame;
    //frame.origin.y += 64.0;
    tableView.frame = frame;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [tableView setEditing:YES];
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    if (mainScreenHeight == 568.0) {
        toolbar.frame = CGRectMake(0, 416 + 88.0 - self.navigationController.navigationBar.frame.size.height, 320, 50);
    }
    else {
        toolbar.frame = CGRectMake(0, 416.0 - self.navigationController.navigationBar.frame.size.height, 320, 50);
    }
    
    [toolbar sizeToFit];
    [self.view addSubview:toolbar];
    [toolbar setTranslucent:NO];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    resetButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Zurücksetzen", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(resetChosen:)];
    
    resetAllButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Alle zurücksetzen", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(resetAll:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:resetButton, flexible, resetAllButton, nil]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidChangeRowSelection:) name:UITableViewSelectionDidChangeNotification object:tableView];
    exchanger = [[VocExchanger alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self tableViewDidChangeRowSelection:self];
}

- (void)viewWillDisappear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == Kategorien) {
        return [kategorieArray count];
    }
    else if (section == Sammlungen)
    {
        return [collectionArray count];
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == Kategorien) {
        cell.textLabel.text = [[kategorieArray objectAtIndex:indexPath.row] kategorieName];
    }
    else if (indexPath.section == Sammlungen)
    {
        cell.textLabel.text = [[collectionArray objectAtIndex:indexPath.row] name];
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == Kategorien) {
        return NSLocalizedString(@"Listen", nil);
    }
    else if (section == Sammlungen)
    {
        return NSLocalizedString(@"Sammlungen", nil);
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20.0)];
    if (section == Kategorien) {
        headerView.textLabel.text = NSLocalizedString(@"Listen", nil);
    }
    else if (section == Sammlungen)
    {
        headerView.textLabel.text = NSLocalizedString(@"Sammlungen", nil);
    }
    
    return headerView;
}


- (void)resetChosen:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Zurücksetzen", nil) message:NSLocalizedString(@"Wirklich zurücksetzen?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Nein", nil) otherButtonTitles:NSLocalizedString(@"Ja", nil), nil];
    [alertView show];
}

- (void)resetAll:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alle zurücksetzen", nil) message:NSLocalizedString(@"Wirklich alle Wörter zurücksetzen?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Nein", nil) otherButtonTitles:NSLocalizedString(@"Ja", nil), nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:NSLocalizedString(@"Zurücksetzen", nil)]) {
        
    if (buttonIndex == 0) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        [self tableViewDidChangeRowSelection:self];
    }
    else if (buttonIndex == 1)
    {
    NSArray *selected = [NSArray arrayWithArray:[tableView indexPathsForSelectedRows]];
    for (NSIndexPath *path in selected) {
        if (path.section == Kategorien) {
            Kategorie *currentKategorie = [kategorieArray objectAtIndex:path.row];
            for (int i = 0; i < [currentKategorie.vocArray count]; i++)
            {
                Vokabel *voc = [currentKategorie.vocArray objectAtIndex:i];
                Vokabel *oldVoc = [voc copy];
                voc.rightCount = 0;
                voc.rightGesamt = 0;
                voc.falseGesamt = 0;
                [[[kategorieArray objectAtIndex:path.row] vocArray] replaceObjectAtIndex:i withObject:voc];
                exchanger.selectedCollection = NO;
                [exchanger exchangeVocWithOldVoc:oldVoc andNewVoc:voc];
            }
            [tableView deselectRowAtIndexPath:path animated:YES];
            [self tableViewDidChangeRowSelection:self];
        }
        else if (path.section == Sammlungen) {
            Sammlung *currentCollection = [collectionArray objectAtIndex:path.row];
            for (int i = 0; i < [currentCollection.vocArray count]; i++) {
                Vokabel *voc = [currentCollection.vocArray objectAtIndex:i];
                Vokabel *oldVoc = [voc copy];
                voc.rightCount = 0;
                voc.rightGesamt = 0;
                voc.falseGesamt = 0;
                [[[collectionArray objectAtIndex:path.row] vocArray] replaceObjectAtIndex:i withObject:voc];
                exchanger.selectedCollection = YES;
                [exchanger exchangeVocWithOldVoc:oldVoc andNewVoc:voc];
            }
            [tableView deselectRowAtIndexPath:path animated:YES];
            [self tableViewDidChangeRowSelection:self];
        }
    }
    }
    }
    else {
        if (buttonIndex == 1) {
            for (int i = 0; i < [kategorieArray count]; i++) {
                Kategorie *currentKategorie;
                currentKategorie = [kategorieArray objectAtIndex:i];
                for (Vokabel *voc in currentKategorie.vocArray) {
                    voc.rightCount = 0;
                    voc.rightGesamt = 0;
                    voc.falseGesamt = 0;
                }
            }
            
            for (int i = 0; i < [collectionArray count]; i++) {
                Sammlung *currentCollection;
                currentCollection = [collectionArray objectAtIndex:i];
                for (Vokabel *voc in currentCollection.vocArray) {
                    voc.rightCount = 0;
                    voc.rightGesamt = 0;
                    voc.falseGesamt = 0;
                }
            }
        }
    }
}

- (void)tableViewDidChangeRowSelection:(id)selector
{
    NSArray *selected = [NSArray arrayWithArray:[tableView indexPathsForSelectedRows]];
    if ([selected count]) {
        resetButton.enabled = YES;
        resetButton.title = [NSString stringWithFormat:NSLocalizedString(@"Zurücksetzen (%d)", nil), [selected count]];
    }
    else if (![selected count])
    {
        resetButton.title = NSLocalizedString(@"Zurücksetzen (0)", nil);
        resetButton.enabled = NO;
    }
    selected = nil;
}




@end
