//
//  FileImportViewController.m
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 29.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "FileImportViewController.h"
#import "AccessoryView.h"
#import "CustomCell.h"
#import "Kategorie.h"
#import "Vokabel.h"
#import "parseCSV.h"
#import "XMLParser.h"

NSMutableArray *kategorieArray;
int globalIndex;
Kategorie *tempKategorie;

@implementation FileImportViewController

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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.title = NSLocalizedString(@"Aus iTunes importieren", nil);
    
        
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataArrayWithRightExtensions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *fileName = [dataArrayWithRightExtensions objectAtIndex:indexPath.row];
//    NSLog(@"filename: %@", fileName);
    cell.textLabel.text = fileName;
    
    //AccessoryView *accessory = [AccessoryView accessoryWithColor:cell.textLabel.textColor];
    //accessory.highlightedColor = [UIColor blackColor];
    //cell.accessoryView = accessory;
    
    
    return cell;
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
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* pathAsString = [paths objectAtIndex:0];
    NSString *fileString = [NSString stringWithFormat:@"/%@",[dataArrayWithRightExtensions objectAtIndex:indexPath.row]];
    
    NSRange range = NSMakeRange([fileString length]-4, 4);
    NSString *extension = [fileString substringWithRange:range];
    NSString* filePath = [pathAsString stringByAppendingString:fileString];

#pragma mark ----CSV----
    if ([extension isEqualToString:@".csv"])
    {
//    NSLog(@"path %@",filePath);
    CSVParser *parser = [CSVParser new];
    [parser openFile:filePath];
    NSMutableArray *csvContent = [parser parseFile];
//    NSLog(@"counting csv: %d",[csvContent count]);
//    NSLog(@"%@",csvContent);
    NSMutableArray *currentVocArray = [[NSMutableArray alloc] init];
    int c;
    for (c = 0; c < [csvContent count]; c++) {
        //NSLog(@"content of line %d: %@", c, [csvContent objectAtIndex: c]);
        NSArray *keyArray = [csvContent objectAtIndex:c];
        //NSLog(@"count %d", [keyArray count]);
        //NSLog(@"%@", keyArray);
        NSString *germanStringCSV = [keyArray objectAtIndex:0];
        
//        NSUInteger testInt = [keyArray indexOfObject:[keyArray lastObject]];
//        NSLog(@"testint %d", testInt);
    
    if ([keyArray indexOfObject:[keyArray lastObject]] != 0) {
        NSString *foreignStringCSV = [keyArray objectAtIndex:1];
        addVoc = [[Vokabel alloc] init];
        addVoc.homeString = germanStringCSV;
        addVoc.foreignString = foreignStringCSV;
        [currentVocArray addObject:addVoc];
        //NSLog(@"current %@",currentVocArray);
        }
//        NSLog(@"%@",addVoc.homeString);
//        NSLog(@"%@",addVoc.foreignString);
        
    }
    self.importVocs = currentVocArray;
    currentVocArray = nil;
    self.canceledImport = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    }
    
#pragma mark ----XML----
    else if ([extension isEqualToString:@".xml"])
    {
//        NSLog(@"xml-mode");
        NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
        xmlParser = [[XMLParser alloc] init];
        

        [xmlParser parseXMLfile:url];
        NSMutableArray *xmlContent = xmlParser.completed;
        NSMutableArray *currentVocArray = [[NSMutableArray alloc] init];
        
        for (int c = 0; c < [xmlContent count]; c++) {
//        NSLog(@"content of line %d: %@", c, [xmlContent objectAtIndex: c]);
        NSMutableArray *keyArray = [xmlContent objectAtIndex:c];
        NSString *germanStringXML = [keyArray objectAtIndex:0];
//        NSLog(@"german : %@", germanStringXML);
//        NSUInteger testInt = [keyArray indexOfObject:[keyArray lastObject]];
//        NSLog(@"testint %d", testInt);
//        NSLog(@"content: %d", [xmlContent count]);
        
        if ([keyArray indexOfObject:[keyArray lastObject]] != 0) {
            NSString *foreignStringXML = [keyArray objectAtIndex:1];
//            NSLog(@"foreign : %@", foreignStringXML);
            addVoc = [[Vokabel alloc] init];
            addVoc.homeString = germanStringXML;
            addVoc.foreignString = foreignStringXML;
            [currentVocArray addObject:addVoc];
//            NSLog(@"current %@",currentVocArray);
        }
        }
        self.importVocs = currentVocArray;
        currentVocArray = nil;
        self.canceledImport = YES;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)cancelView:(id)sender
{
    self.canceledImport = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
    NSLog(@"doc: %@",documentsDirectory);
    dataArray = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [dataArray addObjectsFromArray:[fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL]];
    //    NSLog(@"dataArray %@", dataArray);
    //self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.separatorColor = [UIColor clearColor];
    
    dataArrayWithRightExtensions = [[NSMutableArray alloc] init];
    self.canceledImport = NO;
    
    for (int i = 0; i<[dataArray count]; i++)
    {
//        NSString *newFileString;
        NSString *stringFromArray = [dataArray objectAtIndex:i];
        //        NSLog(@"String from array %@", stringFromArray);
        
        if ([stringFromArray length] >= 5)
        {
            NSRange range = NSMakeRange([stringFromArray length]-4, 4);
            
            NSString *extension = [stringFromArray substringWithRange:range];
            //        NSLog(@"extension %@", extension);
            
            if ([extension isEqualToString:@".csv"]  || [extension isEqualToString:@".xml"])
            {
//                newFileString = [stringFromArray substringToIndex:[stringFromArray length]-4];
                [dataArrayWithRightExtensions addObject:stringFromArray];
            }
        }
    }
    [self.tableView reloadData];
}
@end
