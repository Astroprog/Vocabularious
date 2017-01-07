//
//  CollectionViewController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 01.09.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "CollectionViewController.h"
#import "AddCollectionViewController.h"
#import "CustomCell.h"
#import "AccessoryView.h"
#import "Sammlung.h"
#import "CollectionInfoViewController.h"

NSMutableArray *collectionArray;
BOOL selectedCollection;
CGFloat mainScreenHeight;

@implementation CollectionViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"Sammlung.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tabBarItem.title = @"Sammlungen";
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Bearbeiten", nil);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAdd:)];
    [self.navigationItem setLeftBarButtonItem:item animated:NO];
    self.title = NSLocalizedString(@"Sammlungen", nil);
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
//    if (mainScreenHeight == 568.0) {
//        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568 - self.navigationController.navigationBar.frame.size.height - 63) style:UITableViewStylePlain];
//    } else {
//        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 - self.navigationController.navigationBar.frame.size.height - 63) style:UITableViewStylePlain];
//    }
    
    /*
    
    tableView.separatorColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor blackColor]; */
    tableView.delegate = self;
    tableView.dataSource = self;
    
    //[self.view addSubview:tableView];
    
    currentCount = [collectionArray count];
    currentIndex = -1;
}

- (void)pushAdd:(id)sender
{
    [self performSegueWithIdentifier:@"addCollection" sender:self];
    fromAddCollection = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addCollection"]) {
        addController = [segue.destinationViewController viewControllers][0];
        addController.editingCollection = NO;
    }
    else if ([segue.identifier isEqualToString:@"collectionInfo"]) {
        CollectionInfoViewController *detailViewController = segue.destinationViewController;
        detailViewController.collectionIndex = [[tableView indexPathForSelectedRow] row];
        detailViewController.hidesBottomBarWhenPushed = YES;
        currentIndex = [[tableView indexPathForSelectedRow] row];
        fromAddCollection = NO;
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
    if (currentCount < [collectionArray count] && fromAddCollection) {
        NSIndexPath *NewAccountPath = [NSIndexPath indexPathForRow:[collectionArray count] - 1 inSection:0];
        NSArray *newAccountPaths = [NSArray arrayWithObject:NewAccountPath];
        [tableView insertRowsAtIndexPaths:newAccountPaths withRowAnimation:NO];
        fromAddCollection = NO;
    }
    [tableView flashScrollIndicators];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selection = [tableView indexPathForSelectedRow];
    
	if (selection)
    {
        [tableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    if (!fromAddCollection) {
        [tableView reloadData];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    currentCount = [collectionArray count];
}

#pragma mark - Table view data source

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
    return nil;
}
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [collectionArray count];
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
    Sammlung *collection = [collectionArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = collection.name;
    
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
        [collectionArray removeObjectAtIndex:indexPath.row];
        selectedCollection = NO;
        [tempTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Sammlung *tempCollection = [collectionArray objectAtIndex:fromIndexPath.row];
    [collectionArray removeObjectAtIndex:fromIndexPath.row];
    [collectionArray insertObject:tempCollection atIndex:toIndexPath.row];
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

/*
- (NSIndexPath *)tableView:(UITableView *)tempTableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
*/
- (void)tableView:(UITableView *)tempTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [self performSegueWithIdentifier:@"collectionInfo" sender:self];
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
