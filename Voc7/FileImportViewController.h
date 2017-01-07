//
//  FileImportViewController.h
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 29.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Vokabel;
@class XMLParser;

@interface FileImportViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataArray;
    NSMutableArray *dataArrayWithRightExtensions;
    Vokabel *addVoc;
    XMLParser *xmlParser;
}

- (void)cancelView:(id)sender;

@property (nonatomic, retain) NSMutableArray *importVocs;
@property (readwrite) BOOL canceledImport;

@end

