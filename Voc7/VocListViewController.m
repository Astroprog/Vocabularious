//
//  VocListViewController
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 17.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "VocListViewController.h"

#import "Vokabel.h"
#import "Sammlung.h"
#import "VocInfoViewController.h"
#import "AddVocViewController.h"
#import "RootViewController.h"
#import "Kategorie.h"
#import "CustomCell.h"
#import "AccessoryView.h"
#import "HeaderView.h"
#import "FileManagerViewController.h"
#import "FileImportViewController.h"
#import "CSVWriter.h"
#import "AddLabel.h"
#import "SelectKategorieViewController.h"
#import "LoadingIndicator.h"



NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;
int globalIndex;
BOOL sortingChanged;
CGFloat mainScreenHeight;


@implementation VocListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tempKategorie.vocArray = [[NSMutableArray alloc] init];
        self.canceled = NO;
        
        if (mainScreenHeight == 568.0) {
            self.preferredContentSize = CGSizeMake(320.0, 600.0 + 80.0);
        }
        else {
            self.preferredContentSize = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView:)];
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    //addVocViewController = [[AddVocViewController alloc] initWithNibName:@"AddVocViewController" bundle:nil];
    //fileManagerViewController = [[FileManagerViewController alloc] initWithNibName:@"FileManagerViewController" bundle:nil];
        
    //fileImportViewController = [[FileImportViewController alloc] initWithNibName:@"FileImportViewController" bundle:nil];
    
    //selectController = [[SelectKategorieViewController alloc] init];
    
    if (mainScreenHeight == 568.0) {
        //tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 + 88.0 - self.navigationController.navigationBar.frame.size.height - 63.0) style:UITableViewStylePlain];
    } else {
        //tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 - 44.0 - self.navigationController.navigationController.navigationBar.frame.size.height - 63.0) style:UITableViewStylePlain];
    }
    
    //tableView.delegate = self;
    //tableView.dataSource = self;
    //[self.view addSubview:tableView];
    
    
    //tableView.separatorColor = [UIColor blackColor];
    tableView.backgroundColor = [UIColor whiteColor];
    
//    toolbar = [[UIToolbar alloc] init];
//    toolbar.barStyle = UIBarStyleDefault;
    if (mainScreenHeight == 568.0) {
        //toolbar.frame = CGRectMake(0, 416 + 88.0 - self.navigationController.navigationBar.frame.size.height, 320, 50);
    }
    else {
        //toolbar.frame = CGRectMake(0, 416.0 - self.navigationController.navigationBar.frame.size.height, 320, 50);
    }
    
    
    //[toolbar sizeToFit];
    //[self.view addSubview:toolbar];
    addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAdd:)];
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(pushDelete:)];
    
    saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pushSave:)];
    
    searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pushSearch:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:addItem, flexible, searchItem, flexible, trashItem, flexible, saveItem, nil]];
    [self.view bringSubviewToFront:toolbar];
    self.canceled = NO;
    self.title = self.tempKategorie.kategorieName;
    fromVocInfo = NO;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    tableView.tableHeaderView = searchBar;
    //self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    //self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor whiteColor];
    searchItems = [[NSMutableArray alloc] init];
    [tableView setContentOffset:CGPointMake(0, 44)];
    toolbar.translucent = NO;
    [self sortCurrentArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewDidChangeRowSelection:) name:UITableViewSelectionDidChangeNotification object:tableView];
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, mainScreenHeight)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.alpha = 0.0;
    [self.view addSubview:backgroundView];
}

- (void)viewDidUnload
{
    vocInfoViewController = nil;
    addVocViewController = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.tempKategorie.kategorieName;
    NSIndexPath *selection = [tableView indexPathForSelectedRow];
    
    vocInfoViewController = [[VocInfoViewController alloc] initWithNibName:@"VocInfoViewController" bundle:nil];
    
	if (selection)
    {
        [tableView deselectRowAtIndexPath:selection animated:YES];
    }
    if (!fromVocInfo) {
        [tableView reloadData];
    } else {
        fromVocInfo = NO;
    }
    
    if (sortingChanged) {
        [self sortCurrentArray];
        sortingChanged = NO;
    }
    editingAll = NO;
    [tableView reloadData];
    
    if (![self.tempKategorie.vocArray count]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    if (selectController.fromMasterViewController) {
        selectController.fromMasterViewController = NO;
        [self addSelectedWordsToKategorie];
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.canceled = addVocViewController.canceled;
    canceledImport = fileImportViewController.canceledImport;
    if (self.canceled)
    {
        int count = [addVocViewController.addVocs count];
        [self addNewVocsFromArray:addVocViewController.addVocs];
        for (int i = 1; i <= count; i++) {
            [self.tempKategorie.vocArray addObject:[addVocViewController.addVocs objectAtIndex:i - 1]];
            NSIndexPath *NewAccountPath =[NSIndexPath indexPathForRow:[self.tempKategorie.vocArray count] - 1 inSection:0];
            NSArray *newAccountPaths = [NSArray arrayWithObject:NewAccountPath];
            [tableView insertRowsAtIndexPaths:newAccountPaths withRowAnimation:NO];
        }
        self.editingVoc = nil;
    } else if (self.canceled == NO){
        int count = [addVocViewController.addVocs count];
        if (count > 0) {
            [self addNewVocsFromArray:addVocViewController.addVocs];
            for (int i = 1; i <= count; i++) {
                [self.tempKategorie.vocArray addObject:[addVocViewController.addVocs objectAtIndex:i - 1]];
                NSIndexPath *NewAccountPath =[NSIndexPath indexPathForRow:[self.tempKategorie.vocArray count] - 1 inSection:0];
                NSArray *newAccountPaths = [NSArray arrayWithObject:NewAccountPath];
                [tableView insertRowsAtIndexPaths:newAccountPaths withRowAnimation:NO];
            }
            self.editingVoc = nil;
            [tableView setContentOffset:CGPointMake(0, 44)];
        }
        
    } if (canceledImport) {
        
        indicator = [[LoadingIndicator alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, self.view.frame.size.width, 50.0)];
        indicator.loading.text = NSLocalizedString(@"Laden...", nil);
        [backgroundView addSubview:indicator];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                backgroundView.alpha = 0.8;
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }completion:nil];
            [indicator startAnimating];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(importVocsFromItunes:) userInfo:nil repeats:0];
            timer = nil;
        });
        [tableView setContentOffset:CGPointMake(0, 44)];

    } else {
        if (self.editingVoc) {
            addVocViewController.canceled = NO;
        }
    }
    
    addVocViewController.canceled = NO;
    fileImportViewController.canceledImport = NO;
    [tableView flashScrollIndicators];
    if (addVocViewController) {
        addVocViewController = nil;
        addVocViewController = [[AddVocViewController alloc] initWithNibName:@"AddVocViewController" bundle:nil];
    }
    if (![self.tempKategorie.vocArray count]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)importVocsFromItunes:(id)selector {
    int importCount = [fileImportViewController.importVocs count];
    for (int i = 1; i<= importCount; i++) {
        [self.tempKategorie.vocArray addObject:[fileImportViewController.importVocs objectAtIndex:i - 1]];
        NSIndexPath *NewAccountPath =[NSIndexPath indexPathForRow:[self.tempKategorie.vocArray count] - 1 inSection:0];
        NSArray *newAccountPaths = [NSArray arrayWithObject:NewAccountPath];
        [tableView insertRowsAtIndexPaths:newAccountPaths withRowAnimation:NO];
    }
    [tableView setContentOffset:CGPointMake(0.0, 44.0)];
    self.editingVoc = nil;
    fileImportViewController.importVocs = nil;
    [indicator stopAnimating];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backgroundView.alpha = 0.0;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    selectedVocs = [[NSArray alloc] initWithArray:[tableView indexPathsForSelectedRows]];
    vocInfoViewController = nil;
    [tableView setEditing:NO];
    [self pushDone:self];
	[super viewDidDisappear:animated];
}


- (void)addNewVocsFromArray:(NSMutableArray *)newArray
{
    for (Sammlung *collection in collectionArray)
    {
        for (int i = 0; i < [collection.kategorieNames count]; i++)
        {
            if ([self.tempKategorie.kategorieName isEqualToString:[collection.kategorieNames objectAtIndex:i]]) {
                for (int d = 0; d < [newArray count]; d++) {
                    [collection.vocArray addObject:[newArray objectAtIndex:d]];
                }
            }
        }
    }
}


- (void)sortCurrentArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"sorting"] isEqualToString:@"date"]) {
        Kategorie *temp = [kategorieArray objectAtIndex:globalIndex];
        
        if ([[defaults objectForKey:@"sortingOrder"] isEqualToString:@"descending"]) {
            temp.vocArray = [[NSMutableArray alloc] initWithArray:[temp.vocArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                int first = [(Vokabel *)a addDate];
                int second = [(Vokabel *)b addDate];
                if ( first < second ) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else if ( first > second ) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else {
                    return (NSComparisonResult)NSOrderedSame;
                }
            }]];
        } else {
            temp.vocArray = [[NSMutableArray alloc] initWithArray:[temp.vocArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                int first = [(Vokabel *)a addDate];
                int second = [(Vokabel *)b addDate];
                if ( first < second ) {
                    return (NSComparisonResult)NSOrderedAscending;
                } else if ( first > second ) {
                    return (NSComparisonResult)NSOrderedDescending;
                } else {
                    return (NSComparisonResult)NSOrderedSame;
                }
            }]];
        }
        
        [kategorieArray replaceObjectAtIndex:globalIndex withObject:temp];
        
    } else if ([[defaults objectForKey:@"sorting"] isEqualToString:@"name"]) {
        
        Kategorie *temp = [kategorieArray objectAtIndex:globalIndex];
        
        if ([[defaults objectForKey:@"sortingOrder"] isEqualToString:@"descending"]) {
            
            NSSortDescriptor *nameSort;
            if ([defaults boolForKey:@"homeStringWillBeDisplayedFirst"]) {
                nameSort = [NSSortDescriptor sortDescriptorWithKey:@"homeString" ascending:NO];
            } else {
                nameSort = [NSSortDescriptor sortDescriptorWithKey:@"foreignString" ascending:NO];
            }
            NSArray *sortDescriptors = [NSArray arrayWithObject:nameSort];
            
            temp.vocArray = [[NSMutableArray alloc] initWithArray:[temp.vocArray sortedArrayUsingDescriptors:sortDescriptors]];
            
        } else {
            NSSortDescriptor *nameSort;
            if ([defaults boolForKey:@"homeStringWillBeDisplayedFirst"]) {
                nameSort = [NSSortDescriptor sortDescriptorWithKey:@"homeString" ascending:YES];
            } else {
                nameSort = [NSSortDescriptor sortDescriptorWithKey:@"foreignString" ascending:YES];
            }
            NSArray *sortDescriptors = [NSArray arrayWithObject:nameSort];
            
            temp.vocArray = [[NSMutableArray alloc] initWithArray:[temp.vocArray sortedArrayUsingDescriptors:sortDescriptors]];
            
        }
        [kategorieArray replaceObjectAtIndex:globalIndex withObject:temp];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    //self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor whiteColor];
    
    if (![searchString isEqual: @""]) {
        [searchItems removeAllObjects];
        for (Vokabel *tempVoc in self.tempKategorie.vocArray) {
            NSRange result;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults boolForKey:@"homeStringWillBeDisplayedFirst"]) {
                result = [tempVoc.homeString rangeOfString:searchString options:NSCaseInsensitiveSearch];
            } else {
                result = [tempVoc.foreignString rangeOfString:searchString options:NSCaseInsensitiveSearch];
            }
            if (result.location != NSNotFound) {
                [searchItems addObject:tempVoc];
            }
        }
        return YES;
    } else {
        return NO;
    }
}

/*-(void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 UISearchBar *searchBar = self.searchDisplayController.searchBar;
 CGRect rect = searchBar.frame;
 rect.origin.y = MIN(0, scrollView.contentOffset.y);
 searchBar.frame = rect;
 }*/

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (editing) {
        editingAll = YES;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAdd:)];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushDone:)];
        [self.navigationItem setLeftBarButtonItem:item animated:YES];
        [tableView setEditing:YES animated:YES];
        [self.navigationItem setRightBarButtonItem:doneItem animated:YES];
        deleteSelection = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Löschen (0)", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pushDeleteSelection:)];
        addToKategorieItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Zu Liste hinzufügen (0)", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(showSelectKategorie:)];
        addToKategorieItem.enabled = NO;
        deleteSelection.enabled = NO;
        [toolbar setItems:[NSArray arrayWithObjects:flexible, deleteSelection, flexible, addToKategorieItem, flexible, nil] animated:YES];
    } else {
        editingAll = NO;
        [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [toolbar setItems:[NSArray arrayWithObjects:addItem, flexible, searchItem, flexible, trashItem, flexible, saveItem, nil]];
        [tableView setEditing:NO animated:YES];
    }
}

- (void)pushSearch:(id)sender
{
    [tableView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)pushSave:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Aus iTunes importieren",nil),NSLocalizedString(@"Via iTunes exportieren", nil),NSLocalizedString(@"Via Mail senden",nil), nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
}
- (void)pushDone:(id)sender
{
    editingAll = NO;
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [toolbar setItems:[NSArray arrayWithObjects:addItem, flexible, searchItem, flexible, trashItem, flexible, saveItem, nil]];
    [tableView setEditing:NO animated:YES];
}

- (void)pushDelete:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Alle Vokabeln dieser Liste löschen?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen", nil) destructiveButtonTitle:NSLocalizedString(@"Löschen", nil) otherButtonTitles:nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)pushDeleteSelection:(id)sender {
    NSArray *vocSelection = [tableView indexPathsForSelectedRows];
    for (int i = 0; i < [vocSelection count]; i++) {
        Vokabel *tempVoc = [self.tempKategorie.vocArray objectAtIndex:[[vocSelection objectAtIndex:i] row]];
        for (Sammlung *collection in collectionArray) {
            [collection.vocArray removeObjectIdenticalTo:tempVoc];
        }
    }
    NSMutableIndexSet *deleteSet = [[NSMutableIndexSet alloc ] init];
    for (int i = 0; i < [vocSelection count]; i++) {
        [deleteSet addIndex:[[vocSelection objectAtIndex:i] row]];
    }
    [self.tempKategorie.vocArray removeObjectsAtIndexes:deleteSet];
    [tableView deleteRowsAtIndexPaths:vocSelection withRowAnimation:UITableViewRowAnimationFade];
    [self tableViewDidChangeRowSelection:self];
    if (![self.tempKategorie.vocArray count]) {
        [self pushDone:self];
        if (![self.tempKategorie.vocArray count]) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

- (void)pushAdd:(id)sender {
    /*
    addVocViewController.foreignLanguage = self.tempKategorie.foreignLanguage;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addVocViewController];
    [self presentModalViewController:navigationController animated:YES];*/
    [self performSegueWithIdentifier:@"addVoc" sender:self];
}

- (void)showSelectKategorie:(id)selector {
    selectController = [[SelectKategorieViewController alloc] init];
    selectController.fromMasterViewController = YES;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectController];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (void)addSelectedWordsToKategorie {
    
    for (int i = 0; i < [selectedVocs count]; i++) {
        Vokabel *tempVoc = [self.tempKategorie.vocArray objectAtIndex:[[selectedVocs objectAtIndex:i] row]];
        [[[kategorieArray objectAtIndex:selectController.selectedKategorieIndex] vocArray] addObject:tempVoc];
        for (Sammlung *tempCollection in collectionArray) {
            for (NSString *name in tempCollection.kategorieNames) {
                if ([name isEqualToString:[[kategorieArray objectAtIndex:selectController.selectedKategorieIndex] kategorieName]]) {
                    [tempCollection.vocArray addObject:tempVoc];
                }
            }
        }
        tempVoc = nil;
    }
    [tableView reloadData];
    
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//    CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate([[sectionArray objectAtIndex:section] addDate], CFTimeZoneCopySystem());
//    header.textLabel.text = [NSString stringWithFormat:@"%d.%d.%d", currentDate.day, currentDate.month, (int)currentDate.year];
//    return header;
//}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tempTableView numberOfRowsInSection:(NSInteger)section
{
    if (tempTableView == self.searchDisplayController.searchResultsTableView) {
        return [searchItems count];
    } else {
        return [self.tempKategorie.vocArray count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tempTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tempTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
/*
    AccessoryView *accessory = [AccessoryView accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor whiteColor];
    cell.accessoryView = accessory;
  */
    Vokabel *voc;
    
    if (tempTableView == self.searchDisplayController.searchResultsTableView) {
        voc = [searchItems objectAtIndex:indexPath.row];
    } else {
        voc = [self.tempKategorie.vocArray objectAtIndex:indexPath.row];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"homeStringWillBeDisplayedFirst"]) {
        cell.textLabel.text = voc.homeString;
    } else {
        cell.textLabel.text = voc.foreignString;
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingAll) {
        return 3;
    }
    else {
        return 1;
    }
    return 1;
}


/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return @"Vokabelliste";
    } else {
        return nil;
    }
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tempTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Vokabel *tempVoc = [self.tempKategorie.vocArray objectAtIndex:indexPath.row];

        for (Sammlung *collection in collectionArray) {
            [collection.vocArray removeObjectIdenticalTo:tempVoc];
        }
        
        [self.tempKategorie.vocArray removeObjectAtIndex:indexPath.row];
        [tempTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (![self.tempKategorie.vocArray count]) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
    
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Vokabel *fromVoc = [self.tempKategorie.vocArray objectAtIndex:fromIndexPath.row];
    [self.tempKategorie.vocArray removeObjectAtIndex:fromIndexPath.row];
    [self.tempKategorie.vocArray insertObject:fromVoc atIndex:toIndexPath.row];
}



/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tempTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tempTableView.editing) {
//    Vokabel *tempVoc;
//    if (tempTableView == self.searchDisplayController.searchResultsTableView) {
//        tempVoc = [searchItems objectAtIndex:indexPath.row];
//    } else {
//        tempVoc = [self.tempKategorie.vocArray objectAtIndex:indexPath.row];
//    }
//    tempVoc.foreignLanguage = self.tempKategorie.foreignLanguage;
//    vocInfoViewController.viewedVoc = tempVoc;
//    vocInfoViewController.fromCollectionViewController = NO;
//    fromVocInfo = YES;
    //[self.navigationController pushViewController:vocInfoViewController animated:YES];
        [self performSegueWithIdentifier:@"vocInfo" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"preparing");
    if ([segue.identifier isEqualToString:@"vocInfo"]) {
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        if (!tableView.editing) {
            Vokabel *tempVoc;
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                tempVoc = [searchItems objectAtIndex:indexPath.row];
            } else {
                tempVoc = [self.tempKategorie.vocArray objectAtIndex:indexPath.row];
            }
            tempVoc.foreignLanguage = self.tempKategorie.foreignLanguage;
            vocInfoViewController = segue.destinationViewController;
            vocInfoViewController.viewedVoc = tempVoc;
            vocInfoViewController.fromCollectionViewController = NO;
            fromVocInfo = YES;
        }
    }
    else if ([segue.identifier isEqualToString:@"addVoc"]) {
        addVocViewController = [segue.destinationViewController viewControllers][0];
        addVocViewController.foreignLanguage = self.tempKategorie.foreignLanguage;
    }
    else if ([segue.identifier isEqualToString:@"fileImport"]) {
        fileImportViewController = [segue.destinationViewController viewControllers][0];
    }
    else if ([segue.identifier isEqualToString:@"fileExport"]) {
        fileManagerViewController = [segue.destinationViewController viewControllers][0];
        fileManagerViewController.fromCollectionInfoViewController = NO;
    }
}


- (void)tableViewDidChangeRowSelection:(id)selector;
{
    NSArray *chosenVocs = [[NSArray alloc] initWithArray:[tableView indexPathsForSelectedRows]];
    if ([chosenVocs count] != 0) {
        deleteSelection.enabled = YES;
        deleteSelection.title = [NSString stringWithFormat:NSLocalizedString(@"Löschen (%d)", nil), [chosenVocs count]];
        addToKategorieItem.enabled = YES;
        addToKategorieItem.title = [NSString stringWithFormat:NSLocalizedString(@"Zu Liste hinzufügen (%d)", nil), [chosenVocs count]];
    }
    else {
        deleteSelection.enabled = NO;
        deleteSelection.title = NSLocalizedString(@"Löschen (0)", nil);
        addToKategorieItem.enabled = NO;
        addToKategorieItem.title = [NSString stringWithFormat:NSLocalizedString(@"Zu Liste hinzufügen (0)", nil)];
    }
}


/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return NO;
    }
}*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:NSLocalizedString(@"Alle Vokabeln dieser Liste löschen?", nil)]) {
        if (buttonIndex == 0) {
            [self.tempKategorie.vocArray removeAllObjects];
            [tableView reloadData];
        }
    } else {
        if (buttonIndex == 0) {
            //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fileImportViewController];
            //[self presentModalViewController:navigationController animated:YES];
            [self performSegueWithIdentifier:@"fileImport" sender:self];
        }
        
        else if (buttonIndex == 1)
        {
            //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fileManagerViewController];
            [self performSegueWithIdentifier:@"fileExport" sender:self];
            //[self presentModalViewController:navigationController animated:YES];
        }
        else if (buttonIndex == 2)
        {
            [self openMail:self];
        }
    }
}

- (void)openMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            NSString *subject = [NSString stringWithFormat:@"%@", self.tempKategorie.kategorieName];
            [mailer setSubject:subject];
            NSData *sendData = [self produceFileForMail];
            [mailer addAttachmentData:sendData mimeType:@"text/csv" fileName:subject];
            [self presentViewController:mailer animated:YES completion:nil];
        }
    else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Unable to send Mail" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)produceFileForMail
{
    NSMutableArray *vocsOfCurrent = self.tempKategorie.vocArray;
    CSVWriter *aWriter = [[CSVWriter alloc] init];
    NSString *receivedString = [aWriter convertStringToCSV:vocsOfCurrent];
    NSData *mailData = [receivedString dataUsingEncoding:NSUTF8StringEncoding];
    vocsOfCurrent = nil;
    return mailData;
}

@end
