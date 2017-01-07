//
//  PreferencesController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 31.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "PreferencesController.h"
#import "RightNumberViewController.h"
#import "ControlDirectionController.h"
#import "ResetCounterViewController.h"
#import "SortingController.h"
#import "BackupViewController.h"
#import "EditPickerViewController.h"

@implementation PreferencesController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = NSLocalizedString(@"Einstellungen", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"Einstellungen.png"];       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.title = NSLocalizedString(@"Einstellungen", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"blabla");
    if ([segue.identifier isEqualToString:@"rightNumber"]) {
        RightNumberViewController *rightController = segue.destinationViewController;
        rightController.hidesBottomBarWhenPushed = YES;
    }
    else if([segue.identifier isEqualToString:@"controlDirection"]){
        ControlDirectionController *controlController = segue.destinationViewController;
        controlController.hidesBottomBarWhenPushed = YES;
    }
    else if([segue.identifier isEqualToString:@"resetCounter"]){
        ResetCounterViewController *controller = segue.destinationViewController;
        controller.hidesBottomBarWhenPushed = YES;
    }
    else if([segue.identifier isEqualToString:@"sorting"]){
        SortingController *controller = segue.destinationViewController;
        controller.hidesBottomBarWhenPushed = YES;
    }
    else if([segue.identifier isEqualToString:@"backup"]){
        BackupViewController *controller = segue.destinationViewController;
        controller.hidesBottomBarWhenPushed = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL space = [[homeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (space) {
        [[NSUserDefaults standardUserDefaults] setObject:homeTextField.text forKey:@"homeLanguage"];
        [textField resignFirstResponder];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Falsche Eingabe", nil) message:NSLocalizedString(@"Bitte eine Muttersprache eingeben.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen", nil) otherButtonTitles:nil]; //TODO: translate!
        [alertView show];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell;
    NSLog(@"editing");
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        cell = (UITableViewCell *) textField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        cell = (UITableViewCell *) textField.superview.superview.superview;
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
    }
    [preferencesTableView scrollToRowAtIndexPath:[preferencesTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    
    //original
    //[preferencesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:Sprachen] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 50.0;
//    
//}

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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == Abfrage) {
        return 5;
    }
    else if (section == Daten)
    {
        return 2;
    }
    else if (section == Info)
    {
        return 2;
    }
    else if (section == Sprachen) {
        return 2;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil; // Sinnlosester Code ever?! :D :D
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == Abfrage) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Schwellenwert der Vokabeln", nil);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Abfragerichtung", nil);
        } else if (indexPath.row == 3) {
            cell.textLabel.text = NSLocalizedString(@"Sichere ausblenden", nil);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            vocSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
            [vocSwitch addTarget:self action:@selector(pushVocSwitch:) forControlEvents:UIControlEventValueChanged];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            if ([defaults integerForKey:@"hideVocs"] == 1) {
                vocSwitch.on = YES;
            }
            cell.accessoryView = vocSwitch;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Sortierung", nil);
        }
        else if (indexPath.row == 4) {
            cell.textLabel.text = NSLocalizedString(@"Bilder ausblenden", nil);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            pictureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
            [pictureSwitch addTarget:self action:@selector(pushPictureSwitch:) forControlEvents:UIControlEventValueChanged];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            if ([defaults integerForKey:@"hidePictures"] == 1) {
                pictureSwitch.on = YES;
            }
            cell.accessoryView = pictureSwitch;
        }
    }
    else if (indexPath.section == Daten)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"Zähler zurücksetzen", nil);
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"Backup", nil);
        }
    }
    else if (indexPath.section == Sprachen) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Muttersprache", nil); // ???: already translated?
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            homeTextField = [[UITextField alloc] initWithFrame:CGRectMake(178, 10, 125, cell.frame.size.height / 2.0)];
            homeTextField.delegate = self;
            homeTextField.adjustsFontSizeToFitWidth = YES;
            homeTextField.textColor = [UIColor grayColor];
            homeTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeLanguage"];
            homeTextField.placeholder = NSLocalizedString(@"Muttersprache", nil);
            homeTextField.keyboardType = UIKeyboardTypeDefault;
            homeTextField.returnKeyType = UIReturnKeyDone;
            homeTextField.backgroundColor = [UIColor clearColor];
            homeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            homeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            homeTextField.textAlignment = NSTextAlignmentLeft;
            homeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [homeTextField setEnabled: YES];
            [cell.contentView addSubview:homeTextField];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Fremdsprachen", nil); // ???: already translated?
        }
    }
    else if (indexPath.section == Info)
    {
        if (indexPath.row == 0) {
            cell = nil;
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"Version", nil);
            cell.detailTextLabel.text = @"2.0 beta";
            [cell.detailTextLabel setTextColor:[UIColor grayColor]];
        }
        else if (indexPath.row ==1)
        {
            cell.textLabel.text = NSLocalizedString(@"Info", nil);
        }
    }
    return cell;
}


- (void)pushVocSwitch:(UISwitch *)senderSwitch
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:vocSwitch.on forKey:@"hideVocs"];
    [defaults synchronize];
}

- (void)pushPictureSwitch:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:pictureSwitch.on forKey:@"hidePictures"];
    [defaults synchronize];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == Abfrage) {
        return NSLocalizedString(@"Vokabelabfrage", nil);
    }
    else if (section == Daten)
    {
        return NSLocalizedString(@"Datenmanagement", nil);
    }
    else if (section == Info) {
        return NSLocalizedString(@"Über Vocabularious", nil); // TODO: translate!
    }
    else if (section == Sprachen) {
        return NSLocalizedString(@"Sprachen", nil); // TODO: translate!
    }
    return nil;
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
    [homeTextField resignFirstResponder];
    if (indexPath.section == Abfrage && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"rightNumber" sender:self];

    } else if (indexPath.section == Abfrage && indexPath.row == 1){
        [self performSegueWithIdentifier:@"controlDirection" sender:self];
    } else if (indexPath.section == Abfrage && indexPath.row == 2) {
        [self performSegueWithIdentifier:@"sorting" sender:self];
    }
    else if (indexPath.section == Daten && indexPath.row == 0){
        [self performSegueWithIdentifier:@"resetCounter" sender:self];
    }
    else if (indexPath.section == Daten && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"backup" sender:self];
    }
    else if (indexPath.section == Sprachen && indexPath.row == 0) {
        [homeTextField becomeFirstResponder];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if (indexPath.section == Sprachen && indexPath.row == 1) {
        editPickerViewController = [[EditPickerViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:editPickerViewController animated:YES];
    }
    else if (indexPath.section == Info && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"showInfo" sender:self];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
