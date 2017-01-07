//
//  EditLanguageViewController.m
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 06.08.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "EditLanguageViewController.h"
#import "Vokabel.h"
#import "Sammlung.h"
#import "Kategorie.h"

NSMutableArray *languages;
NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;
CGFloat mainScreenHeight;
int selectedForChange;

@implementation EditLanguageViewController

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
    doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneView:)];
    doneItem.title = NSLocalizedString(@"Fertig", nil);
    self.navigationItem.rightBarButtonItem = doneItem;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView:)];
    cancelItem.title = NSLocalizedString(@"Abbrechen", nil);
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.title = NSLocalizedString(@"Bearbeiten", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextFieldNotification:)
     name:UITextFieldTextDidChangeNotification
     object:editField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditingTextFieldNotification:) name:UITextFieldTextDidBeginEditingNotification
    object:editField];
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, mainScreenHeight)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.alpha = 0.0;
    [self.view addSubview:backgroundView];
}

- (void)changeTextFieldNotification:(id)selector
{
    BOOL space = [[editField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    if (![editField.text length] || !space) {
        doneItem.enabled = NO;
    }
    else if ([editField.text length] && space)
    {
        doneItem.enabled = YES;
    }
}

- (void)startEditingTextFieldNotification:(id)selector
{
    BOOL space = [[editField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    if (![editField.text length] || !space) {
        doneItem.enabled = NO;
    }
    else if ([editField.text length] && space)
    {
        doneItem.enabled = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    if (selectedForChange == [languages count]) {
        doneItem.enabled = NO;
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [editField resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)doneView:(id)selector {
    BOOL space = [[editField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    
    if (space && [editField.text length] && selectedForChange != [languages count]) {
    [languages replaceObjectAtIndex:selectedForChange withObject:editField.text];
    [self.navigationController popViewControllerAnimated:YES];
    }
    else if (space && [editField.text length] && selectedForChange == [languages count])
    {
        [languages addObject:editField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelView:(id)selector {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [editField becomeFirstResponder];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(int)UITableViewCellStateDefaultMask reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    editField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x+17.0, cell.frame.origin.y +11.0, 289.0, 25.0)];
    editField.delegate = self;
    editField.returnKeyType = UIReturnKeyDone;
    editField.adjustsFontSizeToFitWidth = YES;
    editField.textColor = [UIColor blackColor];
    
    
        editField.keyboardType = UIKeyboardTypeDefault;
        editField.placeholder = NSLocalizedString(@"Sprache/Thema:", nil);
        editField.text = self.editingLanguage;
        editField.clearButtonMode = UITextFieldViewModeAlways;
        editField.autocapitalizationType = NO;
        editField.autocorrectionType = NO;
        [editField setEnabled:YES];
        [cell addSubview:editField];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
