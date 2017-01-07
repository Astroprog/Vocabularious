//
//  AddKategorieViewController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 20.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "AddKategorieViewController.h"
#import "Kategorie.h"
#import "KategorieViewController.h"
#import "AddBackgroundView.h"
#import "AccessoryView.h"

NSMutableArray *languages;
CGFloat mainScreenHeight;

@implementation AddKategorieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       //AddBackgroundView *backgroundView = [[AddBackgroundView alloc] initWithFrame:[self.view bounds]];
        //[self.view addSubview:backgroundView];
        //[self.view sendSubviewToBack:backgroundView];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)cancelView:(id)sender
{
    languageField.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneView:(id)sender{
    if ([languageField.text length]) {
        addKategorie = [[Kategorie alloc] init];
        addKategorie.kategorieName = languageField.text;
        addKategorie.foreignLanguage = language;
        addKategorie.date = CFAbsoluteTimeGetCurrent();
        [kategorieArray addObject:addKategorie];
        languageField.text = @"";
    } else {
        languageField.text = @"";
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView:)];
    cancelButton.title = NSLocalizedString(@"Abbrechen", nil);
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneView:)];
    doneButton.title = NSLocalizedString(@"Fertig", nil);
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    language = NSLocalizedString(@"Sprache 1", nil);
    
    languageField.clearButtonMode = UITextFieldViewModeWhileEditing;
    /*
    if (mainScreenHeight == 568.00) {
        UIView *editBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 434, 320, 70)];
        UIColor *backroungColor = [[UIColor alloc] initWithRed:40.0 / 255 green:42.0 / 255 blue:56.0 / 255 alpha:1.0];
        editBackgroundView.backgroundColor = backroungColor;
        [self.view addSubview:editBackgroundView];
        [self.view sendSubviewToBack:editBackgroundView];
    } else {
        UIView *editBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 346, 320, 70)];
        UIColor *backroungColor = [[UIColor alloc] initWithRed:40.0 / 255 green:42.0 / 255 blue:56.0 / 255 alpha:0.9];
        editBackgroundView.backgroundColor = backroungColor;
        [self.view addSubview:editBackgroundView];
        [self.view sendSubviewToBack:editBackgroundView];
    }
    */
    AccessoryView *accessory = [AccessoryView accessoryWithColor:[UIColor whiteColor]];
    accessory.highlightedColor = [UIColor whiteColor];
    accessory.frame = CGRectMake(265.0, 13.5, 11.0, 15.0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:languageField];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)textFieldChanged:(id)selector {
    BOOL space = [[languageField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if (space) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [languages count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [languages objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    language = [languages objectAtIndex:row];
    NSLog(@"selected: %@", language);
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    if ([languages count]) {
    [languagePicker reloadAllComponents];
    [languagePicker selectRow:0 inComponent:0 animated:NO];
    }
    else  {
        NSLog(@"keine Sprachen vorhanden");
        // Keine Sprachen vorhanden
    }
    
    /*
    CGRect frame = languagePicker.frame;
    frame.origin.y = self.view.frame.size.height - 286.0;
    languagePicker.frame = frame;
    
    frame = languageLabel.frame;
    frame.origin.y = self.view.frame.size.height -315.0;
    languageLabel.frame = frame;*/
    
    self.title = NSLocalizedString(@"Neue Liste", nil);
    nameLabel.text = NSLocalizedString(@"Name der Liste:", nil);
    languageLabel.text = NSLocalizedString(@"Sprache/Thema:", nil);
    [self textFieldChanged:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    /*
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    CGRect frame = languagePicker.frame;
    frame.origin.y = self.view.frame.size.height - 180.0;
    languagePicker.frame = frame;
    
    frame = languageLabel.frame;
    frame.origin.y = self.view.frame.size.height -150.0;
    languageLabel.frame = frame;
    [UIView commitAnimations];
     */
}
- (void)keyboardWillHide:(NSNotification *)notification {
    /*[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.27];
    CGRect frame = languagePicker.frame;
    frame.origin.y = self.view.frame.size.height - 286.0;
    languagePicker.frame = frame;
    
    frame = languageLabel.frame;
    frame.origin.y = self.view.frame.size.height -315.0;
    languageLabel.frame = frame;
    
    
    [UIView commitAnimations];*/
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
