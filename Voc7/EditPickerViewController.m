//
//  EditPickerViewController.m
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 05.08.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "EditPickerViewController.h"
#import "EditLanguageViewController.h"
#import "AccessoryView.h"
#import "CustomCell.h"

NSMutableArray *languages;
int selectedForChange;
@implementation EditPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Zurück", nil) style:(int)UIBarButtonSystemItemCancel target:self action:@selector(doneView:)];
    self.navigationItem.leftBarButtonItem = doneButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.title = NSLocalizedString(@"Bearbeiten", nil);
    [self.tableView setEditing:YES animated:NO];
    self.tableView.allowsSelectionDuringEditing = YES;
    editLanguageViewController = [[EditLanguageViewController alloc] initWithStyle:UITableViewStyleGrouped];

    /*self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor blackColor];*/
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)doneView:(id)selector
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == foreign) {
        int i = [languages count] +1;
        return i;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell;
    if (cell == nil) {
        /*cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];*/
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    AccessoryView *accessory = [AccessoryView accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor redColor];
    accessory.accessoryColor = [UIColor whiteColor];
//    cell.accessoryView = accessory;
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row < [languages count] && indexPath.section == foreign) {
        cell.textLabel.text = [languages objectAtIndex:indexPath.row];
    }
    else if (indexPath.row == [languages count] && indexPath.section == foreign)
    {
        cell.textLabel.text = NSLocalizedString(@"Hinzufügen", nil);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (languages.count > 1) {
        [languages removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nicht erlaubt!", nil) message:NSLocalizedString(@"Es dürfen nicht alle Fremdsprachen gelöscht werden!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen", nil) otherButtonTitles:nil];
            [alertView show];
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

}*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    if (indexPath.row < [languages count] && indexPath.section == foreign) {
        editLanguageViewController.editingLanguage = [languages objectAtIndex:indexPath.row];
        selectedForChange = indexPath.row;
        [self.navigationController pushViewController:editLanguageViewController animated:YES];
    }
    else if (indexPath.row == [languages count] && indexPath.section == foreign)
    {
        editLanguageViewController.editingLanguage = @"";
        selectedForChange = indexPath.row;
        [self.navigationController pushViewController:editLanguageViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle editingStyle;
    if (indexPath.row == [languages count]) {
    editingStyle = UITableViewCellEditingStyleInsert;
    }
    else {
        editingStyle = UITableViewCellEditingStyleDelete;
    }
    return editingStyle;
}


@end
