//
//  RootViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 17.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterViewController;
@class VocView;
@class DayController;
@class Sammlung;
@class Vokabel;
@class Kategorie;
@class BottomView;
@class SelectKategorieViewController;
@class StatisticsController;
@class VocExchanger;

extern int rightVocCount;
extern int vocCount;
extern Kategorie *currentKategorie;
extern int globalIndex;
extern int globalCollectionIndex;
extern BOOL selectedCollection;
extern BOOL startedIntroduction;

@interface RootViewController : UIViewController <UITextFieldDelegate>
{
    Sammlung *currentCollection;
    UIToolbar *selectToolbar;
    int currentIndex;
    int previousIndex;
    int rightLimit;
    NSTimer *nextTimer;
    SelectKategorieViewController *selectKategorieViewController;
    StatisticsController *statisticsController;
    
    IBOutlet UITextField *solutionTextField;
    IBOutlet UILabel *solutionLabel;
    IBOutlet MasterViewController *masterViewController;
    IBOutlet VocView *vocView;
    IBOutlet BottomView *bottomView;
    IBOutlet UIBarButtonItem *nextVocItem;
    IBOutlet UIBarButtonItem *checkVocItem;
    
    BOOL keyboardShown;
    BOOL removed;
    BOOL introduction;
    BOOL locked;
    UIImageView *imageView;
    UIView *backgroundView;
    UIView *introductionView;
    UIView *homeLanguageView;
    UITextField *homeLanguageField;
    
    DayController *dayController;
    NSMutableArray *wrongVocArray;
    VocExchanger *exchanger;
}

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

- (void)pushSelectCategorie:(id)sender;
- (void)pushSelectCollection:(id)sender;
- (IBAction)nextVoc:(id)sender;
- (IBAction)checkVoc:(id)sender;
- (void)showNextVoc;
- (void)showViewWithVocImage:(UIImage *)image;
- (void)removeViewWithVocImage;
- (void)animateImageWhenKeyboardHides;

@property (nonatomic, retain) IBOutlet UIView *keyboardToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end