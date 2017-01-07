//
//  KategorieViewController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 20.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "KategorieViewController.h"
#import "Sammlung.h"
#import "Kategorie.h"
#import "Vokabel.h"
#import "AddKategorieViewController.h"
#import "TableViewBackground.h"
#import "AccessoryView.h"
#import "VocListViewController.h"

NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;
BOOL startedIntroduction;
int globalIndex;

@implementation KategorieViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"VocListe.png"];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = NSLocalizedString(@"Listen", nil);
    //self.tabBarItem.title = NSLocalizedString(@"Listen", nil);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAdd:)];
    [self.navigationItem setLeftBarButtonItem:item animated:NO];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Bearbeiten", nil);
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    //self.tableView.backgroundColor = [UIColor whiteColor];
    currentCount = [kategorieArray count];
    //addKategorieViewController = [[AddKategorieViewController alloc] initWithNibName:@"AddKategorieViewController" bundle:nil];
    //self.tableView.separatorColor = [UIColor clearColor];
    //self.tableView.backgroundColor = [UIColor clearColor];
    //TableViewBackground *view = [[TableViewBackground alloc] init];
    //self.tableView.backgroundView = view;
    CGRect frame = self.tableView.frame;
    frame.size.height = 461.0;
    self.tableView.frame = frame;
}

- (void)pushAdd:(id)sender
{
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"AddKategorieViewController" bundle:nil];
//    addKategorieViewController = (AddKategorieViewController *)[board instantiateInitialViewController];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addKategorieViewController];
    fromAddKategorie = YES;
    [self performSegueWithIdentifier:@"addKategorie" sender:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!fromAddKategorie)
    {
        [self.tableView reloadData];
    }
    
    if (startedIntroduction) {
        [self performSegueWithIdentifier:@"addKategorie" sender:self];
        fromAddKategorie = YES;
        startedIntroduction = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (currentCount < [kategorieArray count] && fromAddKategorie) {
        NSIndexPath *NewAccountPath = [NSIndexPath indexPathForRow:[kategorieArray count] - 1 inSection:0];
        NSArray *newAccountPaths = [NSArray arrayWithObject:NewAccountPath];
        [self.tableView insertRowsAtIndexPaths:newAccountPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        fromAddKategorie = NO;
    }
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    currentCount = [kategorieArray count];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"vocList"]) {
        VocListViewController *vocListController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Kategorie *tempKategorie = [kategorieArray objectAtIndex:indexPath.row];
        vocListController.tempKategorie = tempKategorie;
        vocListController.hidesBottomBarWhenPushed = YES;
        globalIndex = indexPath.row;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [kategorieArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    /*AccessoryView *accessory = [AccessoryView accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor whiteColor];
    cell.accessoryView = accessory;*/
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[kategorieArray objectAtIndex:indexPath.row] kategorieName];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[kategorieArray objectAtIndex:section] date] description];
}
 
 */
 


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Kategorie *tempKategorie = [kategorieArray objectAtIndex:indexPath.row];
    
        for (Vokabel *tempVoc in tempKategorie.vocArray) {
            for (Sammlung *collection in collectionArray) {
                [collection.vocArray removeObjectIdenticalTo:tempVoc];
            }
        }
        [kategorieArray removeObjectAtIndex:indexPath.row];
        globalIndex = 0;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Kategorie *fromKat = [kategorieArray objectAtIndex:fromIndexPath.row];
    [kategorieArray removeObjectAtIndex:fromIndexPath.row];
    [kategorieArray insertObject:fromKat atIndex:toIndexPath.row];
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
    NSLog(@"selected Row!");
    //Kategorie *tempKategorie = [kategorieArray objectAtIndex:indexPath.row];
    fromAddKategorie = NO;
    //[self.navigationController pushViewController:masterViewController animated:YES];
    //[self performSegueWithIdentifier:@"vocList" sender:self];
}


- (void)setEditing:(BOOL)editing {
    {
        // Make sure you call super first
        [super setEditing:editing animated:YES];
        
        if (editing)
        {
            self.editButtonItem.title = NSLocalizedString(@"Fertig", nil);
        }
        else
        {
            self.editButtonItem.title = NSLocalizedString(@"Bearbeiten", nil);
        }
    }
}



@end
