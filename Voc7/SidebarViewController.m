//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "Kategorie.h"
#import "Sammlung.h"

NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;
int globalIndex;
int globalCollectionIndex;
BOOL selectedCollection;

@implementation SidebarViewController {

}

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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case Auswahl:
            return 1;
            break;
        case List:
            return [kategorieArray count];
            break;
        case Collection:
            return [collectionArray count];
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case Auswahl:
            return nil;
            break;
        case List:
            return NSLocalizedString(@"Listen", nil);
            break;
        case Collection:
            return NSLocalizedString(@"Sammlungen", nil);
            break;
            
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSString *infoString = @"";
    //NSString *detailString = @"";
    if (indexPath.section == Auswahl) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        infoString = NSLocalizedString(@"Auswählen", nil);
        cell.textLabel.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        if(indexPath.section == List) {
            infoString = [[kategorieArray objectAtIndex:indexPath.row] kategorieName];
        }
        else if (indexPath.section == Collection) {
            infoString = [[collectionArray objectAtIndex:indexPath.row] name];
        }
    }
    cell.textLabel.text = infoString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == List) {
        selectedCollection = NO;
        globalIndex = indexPath.row;
        [self performSegueWithIdentifier:@"selectedCell" sender:self];
    }
    else if (indexPath.section == Collection) {
        selectedCollection = YES;
        globalCollectionIndex = indexPath.row;
        [self performSegueWithIdentifier:@"selectedCell" sender:self];
    }
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.section == List) {
        NSString *name = [[kategorieArray objectAtIndex:indexPath.row] kategorieName];
        NSLog(@"List selected: %@", name);
    }
    else if (indexPath.section == Collection) {
        NSString *name = [[collectionArray objectAtIndex:indexPath.row] name];
        NSLog(@"Collection selected: %@", name);
    }
        
    if ([segue isKindOfClass: [SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

@end