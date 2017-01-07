//
//  CollectionInfoViewController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 15.10.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "CollectionInfoViewController.h"
#import "CustomCell.h"
#import "AccessoryView.h"
#import "Sammlung.h"
#import "Kategorie.h"
#import "Vokabel.h"
#import "CSVWriter.h"
#import "AddCollectionViewController.h"
#import "VocInfoViewController.h"

NSMutableArray *collectionArray;
NSMutableArray *kategorieArray;
CGFloat mainScreenHeight;
BOOL sortingChanged;

@implementation CollectionInfoViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    /*if (mainScreenHeight == 568.0) {
     tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568 - self.navigationController.navigationBar.frame.size.height - 63) style:UITableViewStylePlain];
     } else {
     tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 - self.navigationController.navigationBar.frame.size.height - 63) style:UITableViewStylePlain];
     }*/
    
    //fileManagerViewController = [[FileManagerViewController alloc] initWithNibName:@"FileManagerViewController" bundle:nil];
    
//    if (mainScreenHeight == 568.0) {
//        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 + 88.0 - self.navigationController.navigationBar.frame.size.height - 63.0) style:UITableViewStylePlain];
//    } else {
//        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 - 44.0 - self.navigationController.navigationController.navigationBar.frame.size.height - 63.0) style:UITableViewStylePlain];
//    }
    
    //tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    //[self.view addSubview:tableView];
//    if (mainScreenHeight == 568.0) {
//        toolbar.frame = CGRectMake(0, 504.0 - self.navigationController.navigationBar.frame.size.height, 320, 50);
//    } else {
//        toolbar.frame = CGRectMake(0, 416 - self.navigationController.navigationBar.frame.size.height, 320, 50);
//    }
    //[toolbar sizeToFit];
    toolbar.translucent = NO;
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [infoButton addTarget:self action:@selector(pushInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(pushDelete:)];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pushSave:)];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pushSearch:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:infoItem, flexible, searchItem, flexible, trashItem, flexible, saveItem, nil]];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    tableView.tableHeaderView = searchBar;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    searchItems = [[NSMutableArray alloc] init];
    [tableView setContentOffset:CGPointMake(0, 44)];
    [self sortCurrentArray];
}


- (void)sortCurrentArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"sorting"] isEqualToString:@"date"]) {
        Sammlung *temp = [collectionArray objectAtIndex:self.collectionIndex];
        
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
        
        [collectionArray replaceObjectAtIndex:self.collectionIndex withObject:temp];
        
    } else if ([[defaults objectForKey:@"sorting"] isEqualToString:@"name"]) {
        
        Sammlung *temp = [collectionArray objectAtIndex:self.collectionIndex];
        
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
        [collectionArray replaceObjectAtIndex:self.collectionIndex withObject:temp];
    }
    
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor whiteColor];
    
    if (![searchString isEqual: @""]) {
        [searchItems removeAllObjects];
        
        Sammlung *collection = [collectionArray objectAtIndex:self.collectionIndex];
        
        for (Vokabel *tempVoc in collection.vocArray) {
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    [tableView flashScrollIndicators];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selection = [tableView indexPathForSelectedRow];
    Sammlung *collection = [collectionArray objectAtIndex:self.collectionIndex];
    self.title = collection.name;
    
	if (selection)
    {
        [tableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    if (sortingChanged) {
        [self sortCurrentArray];
        sortingChanged = NO;
    }
    [tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)pushSearch:(id)sender
{
    [tableView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)pushSave:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Via iTunes exportieren", nil),@"Via Mail senden",nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
}


- (void)pushDelete:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Alle Vokabeln dieser Sammlung löschen?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen", nil) destructiveButtonTitle:NSLocalizedString(@"Löschen", nil) otherButtonTitles:nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)pushInfo:(id)sender
{
    [self performSegueWithIdentifier:@"collectionInfoEditing" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"vocInfo"]) {
        vocInfoViewControllerCollection = segue.destinationViewController;
        vocInfoViewControllerCollection.viewedVoc = tempVoc;
        vocInfoViewControllerCollection.fromCollectionViewController = YES;
        fromVocInfo = NO;
    }
    else {
        addCollectionViewController = [segue.destinationViewController viewControllers][0];
        addCollectionViewController.editingCollection = YES;
        addCollectionViewController.indexOfEditingCollection = self.collectionIndex;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:NSLocalizedString(@"Alle Vokabeln dieser Sammlung löschen?", nil)]) {
        if (buttonIndex == 0) {
            [[[collectionArray objectAtIndex:self.collectionIndex] vocArray] removeAllObjects];
            [[[collectionArray objectAtIndex:self.collectionIndex] kategorieNames] removeAllObjects];
            [tableView reloadData];
        }
    } else {
        if (buttonIndex == 0)
        {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fileManagerViewController];
            //fileManagerViewController.fromCollectionInfoViewController = YES;
            //fileManagerViewController.currentCollectionIndex = self.collectionIndex;
            [self presentModalViewController:navigationController animated:YES];
        }
        else if (buttonIndex == 1)
        {
            [self openMail:self];
        }
    }
}

#pragma mark - Table view data source

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
 {
 return nil;
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tempTableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tempTableView == self.searchDisplayController.searchResultsTableView) {
        return [searchItems count];
    }
    else {
        Sammlung *collection = [collectionArray objectAtIndex:self.collectionIndex];
        return [collection.vocArray count];
    }
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Vokabel *voc;
    
    if (tempTableView == self.searchDisplayController.searchResultsTableView) {
        voc = [searchItems objectAtIndex:indexPath.row];
    }
    else {
        Sammlung *collection = [collectionArray objectAtIndex:self.collectionIndex];
        voc = [collection.vocArray objectAtIndex:indexPath.row];
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
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (editing) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushDone:)];
        [tableView setEditing:YES animated:YES];
        [self.navigationItem setRightBarButtonItem:doneItem animated:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
        [tableView setEditing:NO animated:YES];
    }
}

- (void)pushDone:(id)sender
{
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
    [tableView setEditing:NO animated:YES];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tempTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tempTableView == self.searchDisplayController.searchResultsTableView) {
            Vokabel *searchVoc = [searchItems objectAtIndex:indexPath.row];
            [[[collectionArray objectAtIndex:self.collectionIndex] vocArray] removeObjectIdenticalTo:searchVoc];
            
            [searchItems removeObjectAtIndex:indexPath.row];
            [tempTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
        }
        else {
            Sammlung *collection = [collectionArray objectAtIndex:self.collectionIndex];
            [collection.vocArray removeObjectAtIndex:indexPath.row];
            [tempTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Sammlung *tempCollection = [collectionArray objectAtIndex:self.collectionIndex];
    Vokabel *tempVocab = [tempCollection.vocArray objectAtIndex:fromIndexPath.row];
    [tempCollection.vocArray removeObjectAtIndex:fromIndexPath.row];
    [tempCollection.vocArray insertObject:tempVocab atIndex:toIndexPath.row];
}


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tempTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tempTableView == self.searchDisplayController.searchResultsTableView) {
        tempVoc = [searchItems objectAtIndex:indexPath.row];
    } else {
        Sammlung *collection = [collectionArray objectAtIndex:self.collectionIndex];
        tempVoc = [collection.vocArray objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"vocInfo" sender:self];
    
}


- (void)openMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSString *subject = [NSString stringWithFormat:@"%@", [[collectionArray objectAtIndex:self.collectionIndex] name]];
        [mailer setSubject:subject];
        NSData *sendData = [self produceFileForMail];
        [mailer addAttachmentData:sendData mimeType:@"text/csv" fileName:subject];
        [self presentViewController:mailer animated:YES completion:nil ];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Unable to send Mail"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
//            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
//            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
//            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
//            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
//            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)produceFileForMail
{
    Sammlung *collection = [collectionArray objectAtIndex:self.collectionIndex];
    NSMutableArray *vocsOfCurrent = collection.vocArray;
    
    CSVWriter *aWriter = [[CSVWriter alloc] init];
    NSString *receivedString = [aWriter convertStringToCSV:vocsOfCurrent];
    NSData *mailData = [receivedString dataUsingEncoding:NSUTF8StringEncoding];
    collection = nil;
    vocsOfCurrent = nil;
    return mailData;
}

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing animated:YES];
    
    if (editing) {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Fertig", nil);
    }
    else {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Bearbeiten", nil);
    }
}



@end
