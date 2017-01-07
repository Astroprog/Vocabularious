//
//  FileManagerViewController.m
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 23.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//


#import "FileManagerViewController.h"
#import "Kategorie.h"
#import "Sammlung.h"
#import "Vokabel.h"
#import "CSVWriter.h"
#import "AddBackgroundView.h"
#import "CustomButton.h"


NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;
int globalIndex;

@implementation FileManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //fileNameField.text = @"set";
        self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        AddBackgroundView *backgroundView = [[AddBackgroundView alloc] initWithFrame:[self.view bounds]];
        [self.view addSubview:backgroundView];
        [self.view sendSubviewToBack:backgroundView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.title = NSLocalizedString(@"Via iTunes exportieren", nil);
    
    exportButton = [[UIButton alloc] initWithFrame:CGRectMake(15.0, 180.0, 290.0, 37.0)];
    [exportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exportButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [exportButton setTitle:NSLocalizedString(@"Exportieren", nil) forState:UIControlStateNormal];
    [exportButton addTarget:self action:@selector(getExportFileNameButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exportButton];
    exportButton.enabled = NO;
    Kategorie *currentKategorie = [kategorieArray objectAtIndex:globalIndex];
    NSMutableArray *vocsOfCurrent = currentKategorie.vocArray;
    numberOfVocs.text = [NSLocalizedString(@"Anzahl der Vokabeln: ", nil) stringByAppendingString:[NSString stringWithFormat:@"%d",vocsOfCurrent.count]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextFieldNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:fileNameField];
}


- (void)cancelView:(id)sender
{
    fileNameField.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}

- (void)changeTextFieldNotification:(id)selector
{
    BOOL space = [[fileNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    if (![fileNameField.text length] || !space) {
        exportButton.enabled = NO;
    }
    else if ([fileNameField.text length] && space)
    {
        exportButton.enabled = YES;
    }
}

- (void)getExportFileNameButton:(id)sender {
    NSMutableArray *vocsOfCurrent = [[NSMutableArray alloc] init];
    
    if (!self.fromCollectionInfoViewController)
    {
        Kategorie *currentKategorie = [kategorieArray objectAtIndex:globalIndex];
        vocsOfCurrent = currentKategorie.vocArray;
    }
    else if (self.fromCollectionInfoViewController)
    {
        Sammlung *currentCollection = [collectionArray objectAtIndex:self.currentCollectionIndex];
        vocsOfCurrent = currentCollection.vocArray;
    }
    
        CSVWriter *aWriter = [[CSVWriter alloc] init];
        NSString *receivedString = [aWriter convertStringToCSV:vocsOfCurrent];
        NSString *fileName = fileNameField.text;
        NSString *fileExtension;
        fileExtension = @".csv";
//        NSLog(@"extension");
        NSString *exportName = [fileName stringByAppendingString:fileExtension];
//        NSLog(@"export: %@", exportName);
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSLog(@"docs: %@", documentsDirectory);
        NSString *zippedPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,exportName];
//        NSLog(@"zippedPath %@", zippedPath);
    
        NSError *error;
        BOOL success = [receivedString writeToFile:zippedPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
        if (!success) {
//            NSLog(@"Error importing file: %@", error.localizedDescription);
        }
        //    [receivedString writeToFile:zippedPath atomically:NO encoding:NSASCIIStringEncoding error:nil];
        fileNameField.text = @"";
//        [self fileExistsAtAbsolutePath:zippedPath];
        [self dismissViewControllerAnimated:YES completion:nil];

   /* } else if ([fileNameField.text length] && segmentedControl.selectedSegmentIndex == 1) {
        
        XMLWriter *xmlWriter = [[XMLWriter alloc] init];
        NSString *receivedString = [xmlWriter convertStringToXML:vocsOfCurrent];
        NSString *fileName = fileNameField.text;
        NSString *fileExtension;
        fileExtension = @".xml";
        NSLog(@"extension");
        NSString *exportName = [fileName stringByAppendingString:fileExtension];
        NSLog(@"export: %@", exportName);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSLog(@"docs: %@", documentsDirectory);
        NSString *zippedPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,exportName];
        NSLog(@"zippedPath %@", zippedPath);
        
        NSError *error;         BOOL success = [receivedString writeToFile:zippedPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
        if (!success) {
        NSLog(@"Error importing file: %@", error.localizedDescription);
        }
        //    [receivedString writeToFile:zippedPath atomically:NO encoding:NSASCIIStringEncoding error:nil];
        fileNameField.text = @"";
        [self fileExistsAtAbsolutePath:zippedPath];
        [self dismissModalViewControllerAnimated:YES];
        }*/
         
}
    


/*- (void)fileExistsAtAbsolutePath:(NSString*)filename {
    BOOL isDirectory;
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory];
    
    NSLog(@" %d; %d", isDirectory, fileExistsAtPath);
    //return fileExistsAtPath && !isDirectory;
}*/

@end
