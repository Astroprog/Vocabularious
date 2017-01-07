//
//  SortingController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 10.04.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import "SortingController.h"

BOOL sortingChanged;

@implementation SortingController

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
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = NSLocalizedString(@"Sortierung", nil);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sortingString = [defaults objectForKey:@"sorting"];
    NSString *sortingOrder = [defaults objectForKey:@"sortingOrder"];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0 && [sortingString isEqualToString:@"name"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (indexPath.row == 1 && [sortingString isEqualToString:@"date"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (indexPath.row == 2 && ![sortingString isEqualToString:@"name"] && ![sortingString isEqualToString:@"date"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Name", nil);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Datum", nil);
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Keine Sortierung", nil);
        }
        
    } else {
        if (indexPath.row == 1 && [sortingOrder isEqualToString:@"descending"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (indexPath.row == 0 && ![sortingOrder isEqualToString:@"descending"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Aufsteigend", nil);
        } else {
            cell.textLabel.text = NSLocalizedString(@"Absteigend", nil);
        }
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"Sortierung nach:", nil);
    } else {
        return NSLocalizedString(@"Richtung:", nil);
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (indexPath.row == 0 && indexPath.section == 0) {
        [defaults setObject:@"name" forKey:@"sorting"];
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        [defaults setObject:@"date" forKey:@"sorting"];
    } else if (indexPath.row == 2 && indexPath.section == 0) {
        [defaults setObject:@"none" forKey:@"sorting"];
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        [defaults setObject:@"ascending" forKey:@"sortingOrder"];
    } else {
        [defaults setObject:@"descending" forKey:@"sortingOrder"];
    }
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    sortingChanged = YES;
    [defaults synchronize];
    
}

@end
