//
//  AddCollectionViewController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 01.09.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "AddCollectionViewController.h"
#import "AddBackgroundView.h"
#import "Sammlung.h"
#import "AccessoryView.h"
#import "CustomCell.h"
#import "Kategorie.h"
#import "Vokabel.h"
#import "HeaderView.h"

NSMutableArray *collectionArray;
NSMutableArray *kategorieArray;
CGFloat mainScreenHeight;
BOOL sortingChanged;

@implementation AddCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushDone:)];
    doneItem.enabled = NO;
    doneItem.title = NSLocalizedString(@"Fertig", nil);
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pushCancel:)];
    cancelItem.title = NSLocalizedString(@"Abbrechen", nil);
    [self.navigationItem setRightBarButtonItem:doneItem animated:NO];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
//    AddBackgroundView *backgroundView = [[AddBackgroundView alloc] initWithFrame:[self.view bounds]];
//    [self.view addSubview:backgroundView];
//    [self.view sendSubviewToBack:backgroundView];
    
//    if (mainScreenHeight == 568.0) {
//        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 70.0, self.view.bounds.size.width, self.view.bounds.size.height + 18.0) style:UITableViewStylePlain];
//
//    } else {
//        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 70.0, self.view.bounds.size.width, self.view.bounds.size.height - 70.0) style:UITableViewStylePlain];
//
//    }
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.editing = YES;
    tableView.tableHeaderView = nil;
    
    //[self.view addSubview:tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextFieldNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditingTextFieldNotification:) name:UITextFieldTextDidBeginEditingNotification
                                               object:nameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidChangeRowSelection:) name:UITableViewSelectionDidChangeNotification object:tableView];
    nameTextField.delegate = self;
    userDidSelectKategorie = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.editingCollection) {
        self.title = NSLocalizedString(@"Neue Sammlung", nil);
    }
    else if (self.editingCollection)
    {
        self.title = NSLocalizedString(@"Bearbeiten", nil);
        nameTextField.text = [[collectionArray objectAtIndex:self.indexOfEditingCollection] name];
        NSMutableArray *rowsToSelect = [self selectedKategoriesInCollection];
        
        for (int i = 0; i < [rowsToSelect count]; i++) {
            NSNumber *number = [rowsToSelect objectAtIndex:i];
            int selected = [number intValue];
            NSIndexPath *path = [NSIndexPath indexPathForRow:selected inSection:0];
            [tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionTop];
            number = nil;
        }
    }
    [self tableViewDidChangeRowSelection:self];
    [self changeTextFieldNotification:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    nameTextField.text = @"";
    userDidSelectKategorie = NO;
}

- (void)pushDone:(id)sender
{
    
    Sammlung *newCollection = [[Sammlung alloc] init];
    newCollection.name = nameTextField.text;
    NSArray *chosenKategories = [[NSArray alloc] initWithArray:[tableView indexPathsForSelectedRows]];
    
    for (NSIndexPath *path in chosenKategories) {
        Kategorie *tempKategorie = [kategorieArray objectAtIndex:path.row];
        [newCollection.kategorieNames addObject:tempKategorie.kategorieName];
        for (Vokabel *voc in tempKategorie.vocArray) {
            [newCollection.vocArray addObject:voc];
            }
        }
    if (!self.editingCollection) {
        [collectionArray addObject:newCollection];
    }
    else if (self.editingCollection)
    {
        [collectionArray replaceObjectAtIndex:self.indexOfEditingCollection withObject:newCollection];
    }
    
    sortingChanged = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20.0)];
    headerView.textLabel.text = NSLocalizedString(@"Listen", nil);
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tempTableView numberOfRowsInSection:(NSInteger)section
{
    return [kategorieArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    AccessoryView *accessory = [AccessoryView accessoryWithColor:cell.textLabel.textColor];
//    accessory.highlightedColor = [UIColor blackColor];
//    cell.accessoryView = accessory;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [[kategorieArray objectAtIndex:indexPath.row] kategorieName];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Listen", nil);
}

- (void)tableView:(UITableView *)tempTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedKategorie = [tempTableView cellForRowAtIndexPath:indexPath];
    
    if (selectedKategorie.editingStyle == 3) {
        //selectedKategorie.textLabel.textColor = [UIColor blackColor];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 3; //Multiple Editing
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)changeTextFieldNotification:(id)selector
{
    BOOL space = [[nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    if (![nameTextField.text length] || !space || !userDidSelectKategorie) {
        doneItem.enabled = NO;
    }
    else if ([nameTextField.text length] && space && userDidSelectKategorie)
    {
        doneItem.enabled = YES;
    }
}

- (void)startEditingTextFieldNotification:(id)selector
{
    BOOL space = [[nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    if (![nameTextField.text length] || !space || !userDidSelectKategorie) {
        doneItem.enabled = NO;
    }
    else if ([nameTextField.text length] && space && userDidSelectKategorie)
    {
        doneItem.enabled = YES;
    }
}

- (void)tableViewDidChangeRowSelection:(id)selector;
{
    NSArray *chosenKategories = [[NSArray alloc] initWithArray:[tableView indexPathsForSelectedRows]];
    if ([chosenKategories count] != 0) {
        userDidSelectKategorie = YES;
    }
    else userDidSelectKategorie = NO;
    [self changeTextFieldNotification:self];
    chosenKategories = nil;
}

- (NSMutableArray *)selectedKategoriesInCollection
{
    NSMutableArray *selectedRowsArray = [[NSMutableArray alloc] init];
    Sammlung *collection = [collectionArray objectAtIndex:self.indexOfEditingCollection];
    for (int i = 0; i < [kategorieArray count]; i++)
    {
        if ([collection.kategorieNames containsObject:[[kategorieArray objectAtIndex:i] kategorieName]]) {
            NSNumber *select = [NSNumber numberWithInt:i];
            [selectedRowsArray addObject:select];
        }
    }
    collection = nil;
    return selectedRowsArray;
}


@end
