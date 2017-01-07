//
//  FileManagerViewController.h
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 23.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomButton;

@interface FileManagerViewController : UIViewController <UITextFieldDelegate>

{
    NSString *docPath;
    IBOutlet UITextField *fileNameField;
    UIButton *exportButton;
    IBOutlet UILabel *numberOfVocs;
}

- (void)getExportFileNameButton:(id)sender;

@property (readwrite) BOOL fromCollectionInfoViewController;
@property (readwrite) int currentCollectionIndex;

@end
