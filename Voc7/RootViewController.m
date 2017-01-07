//
//  RootViewController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 17.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "RootViewController.h"
#import "DayController.h"
#import "VocExchanger.h"
#import "Sammlung.h"
#import "Vokabel.h"
#import "Kategorie.h"
#import "SWRevealViewController.h"
#import "VocView.h"
#import "BottomView.h"

Kategorie *currentKategorie;
NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;

int globalIndex;
int globalCollectionIndex;
BOOL selectedCollection;
BOOL startedIntroduction;
BOOL firstLaunch;
CGFloat mainScreenHeight;


@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"Abfrage.png"];
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //statisticsController = [[StatisticsController alloc] initWithNibName:@"StatisticsController" bundle:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarItem.title = NSLocalizedString(@"Abfrage", nil);
    selectToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
    [selectToolbar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Liste auswählen", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pushSelectCategorie:)];
    UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Sammlung auswählen", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pushSelectCollection:)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [selectToolbar setItems:[NSArray arrayWithObjects:collectionItem, flexItem, item, nil]];
    
    rightVocCount = 0;
    vocCount = 0;
    bottomView.hidden = YES;
    
    [vocView setDrawString:NSLocalizedString(@"Liste auswählen", nil) andName:@""];
    [self.view addSubview:selectToolbar];
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0];
    
    CGRect frame = selectToolbar.frame;
    frame.origin.y = 0.0;
    selectToolbar.frame = frame;
    solutionLabel.textColor = [UIColor blackColor];
    if (mainScreenHeight == 568.00) {
        [self.view sendSubviewToBack:vocView];
        frame = vocView.frame;
        frame.origin.y = selectToolbar.frame.size.height;
        vocView.frame = frame;
        
        frame = bottomView.frame;
        frame.origin.y = frame.origin.y + selectToolbar.frame.size.height + 80;
        bottomView.frame = frame;
        
        frame = solutionLabel.frame;
        frame.origin.y = frame.origin.y + selectToolbar.frame.size.height + 55;
        solutionLabel.frame = frame;
        
        frame = solutionTextField.frame;
        frame.origin.y = frame.origin.y + selectToolbar.frame.size.height + 55;
        solutionTextField.frame = frame;
        
        //[UIView commitAnimations];
    }
    
    else {
        frame = vocView.frame;
        frame.origin.y = selectToolbar.frame.size.height;
        vocView.frame = frame;
        
        frame = bottomView.frame;
        frame.origin.y = frame.origin.y + selectToolbar.frame.size.height;
        bottomView.frame = frame;
        
        frame = solutionLabel.frame;
        frame.origin.y = frame.origin.y + selectToolbar.frame.size.height;
        solutionLabel.frame = frame;
        
        frame = solutionTextField.frame;
        frame.origin.y = frame.origin.y + selectToolbar.frame.size.height;
        solutionTextField.frame = frame;
        
        //[UIView commitAnimations];
    }
    
    
    solutionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 44.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0;
    backgroundView.hidden = YES;
    [self.view addSubview:backgroundView];
    
    if (mainScreenHeight == 568.00) {
        homeLanguageView = [[UIView alloc] initWithFrame:CGRectMake(20, 180, 280, 210)];
    } else {
        homeLanguageView = [[UIView alloc] initWithFrame:CGRectMake(20, 125, 280, 210)];
    }
    
    
    homeLanguageView.backgroundColor = [UIColor whiteColor];
    homeLanguageView.alpha = 0.8;
    homeLanguageView.layer.masksToBounds = NO;
    homeLanguageView.layer.cornerRadius = 8;
    homeLanguageView.layer.shadowOffset = CGSizeMake(2, 2);
    homeLanguageView.layer.shadowRadius = 10;
    homeLanguageView.layer.shadowOpacity = 0.2;
    homeLanguageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    UILabel *textLabelHomeLanguageView;
    
    textLabelHomeLanguageView = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 240, 60)];
    textLabelHomeLanguageView.textColor = [UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:44.0/255.0 alpha:1];
    textLabelHomeLanguageView.backgroundColor = [UIColor clearColor];
    textLabelHomeLanguageView.font = [UIFont systemFontOfSize:19.0];
    textLabelHomeLanguageView.textAlignment = NSTextAlignmentCenter;
    [homeLanguageView addSubview:textLabelHomeLanguageView];
    textLabelHomeLanguageView.text = NSLocalizedString(@"Keine Muttersprache festgelegt", nil);
    textLabelHomeLanguageView.numberOfLines = 0;
    
    homeLanguageField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 85, 240.0, 31.0)];
    
    homeLanguageField.textColor = [UIColor blackColor];
    homeLanguageField.borderStyle = UITextBorderStyleRoundedRect;
    homeLanguageField.autocorrectionType = UITextAutocorrectionTypeDefault;
    homeLanguageField.keyboardType = UIKeyboardTypeDefault;
    homeLanguageField.returnKeyType = UIReturnKeyDone;
    homeLanguageField.clearButtonMode = UITextFieldViewModeWhileEditing;
    homeLanguageField.delegate = self;
    [homeLanguageView addSubview:homeLanguageField];
    
    UIButton *addButtonHomeLanguage = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 140, 240.0, 40.0)];
    [addButtonHomeLanguage setTitle:NSLocalizedString(@"Muttersprache festlegen", nil) forState:UIControlStateNormal];
    [addButtonHomeLanguage addTarget:self action:@selector(pushAddHomeLanguageButton:) forControlEvents:UIControlEventTouchDown];
    [addButtonHomeLanguage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [homeLanguageView addSubview:addButtonHomeLanguage];
    homeLanguageView.hidden = YES;
    
    [self.view addSubview:homeLanguageView];
    
    
    
    introductionView = [[UIView alloc] initWithFrame:CGRectMake(20, 180, 280, 140)];
    
    introductionView.backgroundColor = [UIColor whiteColor];
    introductionView.alpha = 0.8;
    introductionView.layer.masksToBounds = NO;
    introductionView.layer.cornerRadius = 8;
    introductionView.layer.shadowOffset = CGSizeMake(5, 5);
    introductionView.layer.shadowRadius = 10;
    introductionView.layer.shadowOpacity = 0.5;
    introductionView.layer.shadowColor = [[UIColor blackColor] CGColor];
    UILabel *textLabel;
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 240, 30)];
    textLabel.textColor = [UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:44.0/255.0 alpha:1];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [introductionView addSubview:textLabel];
    textLabel.text = NSLocalizedString(@"Keine Liste vorhanden", nil);
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 70, 240.0, 40.0)];
    [addButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(pushAddKategorieButton:) forControlEvents:UIControlEventTouchDown];
    addButton.titleLabel.textColor = [UIColor blackColor];
    [introductionView addSubview:addButton];
    introductionView.hidden = YES;
    introduction = NO;
    
    [self.view addSubview:introductionView];
    dayController = [[DayController alloc] init];
    
    checkVocItem.title = NSLocalizedString(@"Check", nil);
    nextVocItem.title = NSLocalizedString(@"Nächste Vokabel", nil);
    exchanger = [[VocExchanger alloc] init];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    self.title = NSLocalizedString(@"Abfrage", nil);
    self.navigationItem.leftBarButtonItem = self.sidebarButton;
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)showHomeLanguageView
{
    homeLanguageView.alpha = 0.0;
    backgroundView.alpha = 0.0;
    
    homeLanguageView.hidden = NO;
    backgroundView.hidden = NO;
    
    homeLanguageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.28 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
        homeLanguageView.alpha = 1.0;
        backgroundView.alpha = 0.7;
        homeLanguageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
            homeLanguageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
                homeLanguageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished){}];
            
        }];
    }];
}

- (void)showIntroductionView
{
    [self.view bringSubviewToFront:introductionView];
    introduction = YES;
    introductionView.alpha = 0.0;
    backgroundView.alpha = 0.0;
    
    introductionView.hidden = NO;
    backgroundView.hidden = NO;
    
    introductionView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.28 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
        introductionView.alpha = 1.0;
        backgroundView.alpha = 0.7;
        introductionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
            introductionView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
                introductionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished){}];
            
        }];
    }];
    
    
}

- (void)pushAddKategorieButton:(id)sender
{
    [UIView animateWithDuration:0.28 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
        introductionView.alpha = 0.0;
        backgroundView.alpha = 0.0;
        introductionView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    } completion:^(BOOL finished) {
        backgroundView.hidden = YES;
        introductionView.hidden = YES;
        introduction = NO;
        startedIntroduction = YES;
        //[self.tabBarController setSelectedIndex:1];
    }];
}

- (void)pushAddHomeLanguageButton:(id)sender
{
    if ([homeLanguageField.text length] > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:homeLanguageField.text forKey:@"homeLanguage"];
        [defaults synchronize];
        firstLaunch = NO;
        
        [UIView animateWithDuration:0.28 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
            homeLanguageView.alpha = 0.0;
            backgroundView.alpha = 0.0;
            homeLanguageView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        } completion:^(BOOL finished) {
            backgroundView.hidden = YES;
            homeLanguageView.hidden = YES;
            homeLanguageField.text = @"";
            locked = NO;
            [self textFieldShouldReturn:homeLanguageField];
            [self showIntroductionView];
        }];
    }
}

- (void)pushSelectCollection:(id)sender
{
    /*
     selectKategorieViewController = [[SelectKategorieViewController alloc] initWithNibName:@"SelectKategorieViewController" bundle:nil];
     selectKategorieViewController.collection = YES;
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectKategorieViewController];
     [self presentModalViewController:navigationController animated:YES];
     */
}


- (void)pushSelectCategorie:(id)sender
{
    /*
     selectKategorieViewController = [[SelectKategorieViewController alloc] initWithNibName:@"SelectKategorieViewController" bundle:nil];
     selectKategorieViewController.collection = NO;
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectKategorieViewController];
     [self presentModalViewController:navigationController animated:YES];
     */
}

- (void)viewDidUnload
{
    imageView = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //currentKategorie = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    keyboardShown = NO;
    vocView.green = NO;
    removed = YES;
    rightVocCount = 0;
    vocCount = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"rightNumber"]) {
        rightLimit = [defaults integerForKey:@"rightNumber"];
    } else {
        rightLimit = 3;
    }
    
    if (selectedCollection) {
        if ([collectionArray count]) {
            currentCollection = [collectionArray objectAtIndex:globalCollectionIndex];
        }
        
        for (Vokabel *voc in currentCollection.vocArray) {
            if (voc.rightCount == rightLimit) {
                rightVocCount++;
            }
        }
        
    } else {
        if ([kategorieArray count]) {
            currentKategorie = [kategorieArray objectAtIndex:globalIndex];
        }
        
        for (Vokabel *voc in currentKategorie.vocArray) {
            if (voc.rightCount == rightLimit) {
                rightVocCount++;
            }
        }
    }
    
    [self showNextVoc];
    [vocView setNeedsDisplay];
    [self.view bringSubviewToFront:vocView];
    [self.view bringSubviewToFront:solutionTextField];
    [self.view bringSubviewToFront:solutionLabel];
    [self.view bringSubviewToFront:_keyboardToolbar];
    [self.view bringSubviewToFront:backgroundView];
    [self.view bringSubviewToFront:introductionView];
    [self.view bringSubviewToFront:homeLanguageView];
    [self.view bringSubviewToFront:imageView];
    [[[[introductionView subviews] objectAtIndex:1] titleLabel] setTextColor:[UIColor blackColor]];
    solutionLabel.text = NSLocalizedString(@"Lösung:", nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (IBAction)nextVoc:(id)sender
{
    [self showNextVoc];
}

- (void)showNextVocFromArray:(NSMutableArray *)vocArray
{
    if ([vocArray count] > 0) {
        NSLog(@"Vokabeln vorhanden");
        int vocArrayCount = [vocArray count];
        srandom(time(NULL));
        currentIndex = arc4random() % vocArrayCount;
        
        if (selectedCollection) {
            vocCount = [currentCollection.vocArray count];
        }
        else {
            vocCount = [currentKategorie.vocArray count];
        }
        
        if ([vocArray count] > 1) {
            if (currentIndex == previousIndex) {
                if (currentIndex < vocArrayCount - 1) {
                    currentIndex++;
                } else {
                    currentIndex--;
                }
            }
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:@"homeStringWillBeDisplayedFirst"]) {
            [vocView setDrawString:[[vocArray objectAtIndex:currentIndex] homeString] andName:(selectedCollection ? currentCollection.name : currentKategorie.kategorieName)];
            Vokabel *vok = [vocArray objectAtIndex:currentIndex];
            if (vok.image && ![defaults integerForKey:@"hidePictures"])
            {
                [self showViewWithVocImage:vok.image];
            }
            vok = nil;
        } else {
            [vocView setDrawString:[[vocArray objectAtIndex:currentIndex] foreignString] andName:(selectedCollection ? currentCollection.name : currentKategorie.kategorieName)];
            Vokabel *vok = [vocArray objectAtIndex:currentIndex];
            if (vok.image && ![defaults integerForKey:@"hidePictures"])
            {
                [self showViewWithVocImage:vok.image];
            }
            vok = nil;
        }
        if ([[vocArray objectAtIndex:currentIndex] rightCount] < rightLimit) {
            vocView.green = NO;
        } else {
            vocView.green = YES;
        }
    } else {
        NSLog(@"Keine Vokabeln vorhanden.");
        vocCount = 0;
        rightVocCount = 0;
    }
}

- (void)reloadWrongVocs
{
    if (!wrongVocArray) {
        wrongVocArray = [[NSMutableArray alloc] init];
    } else {
        [wrongVocArray removeAllObjects];
    }
    
    if (selectedCollection) {
        for (Vokabel *tempVoc in currentCollection.vocArray) {
            if (tempVoc.rightCount < rightLimit) {
                [wrongVocArray addObject:tempVoc];
            }
        }
    } else {
        for (Vokabel *tempVoc in currentKategorie.vocArray) {
            if (tempVoc.rightCount < rightLimit) {
                [wrongVocArray addObject:tempVoc];
            }
        }
    }
    
    if ([wrongVocArray count] == 0) {
        [vocView setDrawString:NSLocalizedString(@"Fertig!", nil) andName:(selectedCollection ? currentCollection.name : currentKategorie.kategorieName)];
        vocCount = (selectedCollection ? currentCollection.vocArray.count : currentKategorie.vocArray.count);
        vocView.green = YES;
    }
}

- (void)showNextVoc
{
    imageView.image = nil;
    backgroundView.alpha = 0.0;
    if (firstLaunch) {
        NSLog(@"First Launch");
        [self showHomeLanguageView];
        locked = YES;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"hideVocs"] == 1)
    {
        if (selectedCollection) {
            if ([collectionArray count] > 0 && [currentCollection.vocArray count] == 0)
            {
                [vocView setDrawString:NSLocalizedString(@"Sammlung leer", nil) andName:@""];
                vocCount = 0;
            }
            else if ([collectionArray count] == 0 && [currentCollection.vocArray count] == 0)
            {
                [vocView setDrawString:NSLocalizedString(@"Sammlung erstellen", nil) andName:@""];
                vocCount = 0;
            }
            else {
                [self reloadWrongVocs];
                if ([wrongVocArray count]) {
                    [self showNextVocFromArray:wrongVocArray];
                }
            }
        }
        else
        {
            if ([kategorieArray count] > 0 && [currentKategorie.vocArray count] == 0)
            {
                [vocView setDrawString:NSLocalizedString(@"Liste leer", nil) andName:@""];
                vocCount = 0;
            }
            else if ([kategorieArray count] == 0 && [currentKategorie.vocArray count] == 0)
            {
                [vocView setDrawString:NSLocalizedString(@"Liste erstellen", nil) andName:@""];
                if (homeLanguageView.hidden == YES) {
                    [self showIntroductionView];
                }
                vocCount = 0;
            }
            else {
                [self reloadWrongVocs];
                if ([wrongVocArray count]) {
                    [self showNextVocFromArray:wrongVocArray];
                }
            }
        }
    }
    else {
        if (selectedCollection) {
            if ([collectionArray count] > 0 && [currentCollection.vocArray count] == 0) {
                [vocView setDrawString:NSLocalizedString(@"Sammlung leer", nil) andName:@""];
            } else if ([collectionArray count] == 0 && [currentCollection.vocArray count] == 0) {
                [vocView setDrawString:NSLocalizedString(@"Sammlung erstellen", nil) andName:@""];
            } else {
                [self showNextVocFromArray:currentCollection.vocArray];
            }
        } else {
            if ([kategorieArray count] > 0 && [currentKategorie.vocArray count] == 0) {
                [vocView setDrawString:NSLocalizedString(@"Liste leer", nil) andName:@""];
            } else if ([kategorieArray count] == 0 && [currentKategorie.vocArray count] == 0) {
                [vocView setDrawString:NSLocalizedString(@"Liste erstellen", nil) andName:@""];
                if (homeLanguageView.hidden == YES) {
                    [self showIntroductionView];
                }
            } else {
                [self showNextVocFromArray:currentKategorie.vocArray];
            }
        }
    }
    solutionTextField.text = @"";
    previousIndex = currentIndex;
}

- (void)checkVocFromArray:(NSMutableArray *)vocArray
{
    if ([solutionTextField.text length] > 0 && [vocArray count] > 0) {
        
        NSString *trimmedSolutionString = [solutionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *trimmedArrayString;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([defaults boolForKey:@"homeStringWillBeDisplayedFirst"]) {
            Vokabel *tempVoc = [vocArray objectAtIndex:currentIndex];
            trimmedArrayString = [tempVoc.foreignString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            Vokabel *oldVoc = [tempVoc copy];
            
            if ([trimmedSolutionString isEqualToString:trimmedArrayString]) {
                [vocView setDrawString:NSLocalizedString(@"Richtig!", nil) andName:(selectedCollection ? currentCollection.name : currentKategorie.kategorieName)];
                [dayController incrementRightCount];
                if (tempVoc.rightCount < rightLimit) {
                    tempVoc.rightCount++;
                    if (tempVoc.rightCount == rightLimit) {
                        vocView.green = YES;
                        rightVocCount++;
                    } else {
                        vocView.green = NO;
                    }
                } else {
                    vocView.green = YES;
                }
                tempVoc.rightGesamt++;
                [vocArray replaceObjectAtIndex:currentIndex withObject:tempVoc];
                exchanger.selectedCollection = selectedCollection;
                [exchanger exchangeVocWithOldVoc:oldVoc andNewVoc:tempVoc];
                oldVoc = nil;
            } else {
                [vocView setDrawString:[NSString stringWithFormat:NSLocalizedString(@"Falsch: %@", nil), [[vocArray objectAtIndex:currentIndex] foreignString]] andName:(selectedCollection ? currentCollection.name : currentKategorie.kategorieName)];
                [dayController incrementWrongCount];
                Vokabel *tempVoc = [vocArray objectAtIndex:currentIndex];
                if (tempVoc.rightCount == rightLimit) {
                    rightVocCount--;
                }
                tempVoc.rightCount = 0;
                tempVoc.falseGesamt++;
                vocView.green = NO;
                [vocArray replaceObjectAtIndex:currentIndex withObject:tempVoc];
                exchanger.selectedCollection = selectedCollection;
                [exchanger exchangeVocWithOldVoc:oldVoc andNewVoc:tempVoc];
                oldVoc = nil;
            }
            
        } else {
            Vokabel *tempVoc = [vocArray objectAtIndex:currentIndex];
            trimmedArrayString = [tempVoc.homeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            Vokabel *oldVoc = [tempVoc copy];
            if ([trimmedSolutionString isEqualToString:trimmedArrayString]) {
                [vocView setDrawString:NSLocalizedString(@"Richtig!", nil) andName:(selectedCollection ? currentCollection.name : currentKategorie.kategorieName)];
                [dayController incrementRightCount];
                if (tempVoc.rightCount < rightLimit) {
                    tempVoc.rightCount++;
                    if (tempVoc.rightCount == rightLimit) {
                        vocView.green = YES;
                        rightVocCount++;
                    } else {
                        vocView.green = NO;
                    }
                } else {
                    vocView.green = YES;
                }
                tempVoc.rightGesamt++;
                [vocArray replaceObjectAtIndex:currentIndex withObject:tempVoc];
                exchanger.selectedCollection = selectedCollection;
                [exchanger exchangeVocWithOldVoc:oldVoc andNewVoc:tempVoc];
                oldVoc = nil;
            } else {
                [vocView setDrawString:[NSString stringWithFormat:NSLocalizedString(@"Falsch: %@", nil), [[vocArray objectAtIndex:currentIndex] homeString]] andName:(selectedCollection ? currentCollection.name : currentKategorie.kategorieName)];
                [dayController incrementWrongCount];
                Vokabel *tempVoc = [vocArray objectAtIndex:currentIndex];
                if (tempVoc.rightCount == rightLimit) {
                    rightVocCount--;
                }
                tempVoc.rightCount = 0;
                tempVoc.falseGesamt++;
                vocView.green = NO;
                [vocArray replaceObjectAtIndex:currentIndex withObject:tempVoc];
                exchanger.selectedCollection = selectedCollection;
                [exchanger exchangeVocWithOldVoc:oldVoc andNewVoc:tempVoc];
                oldVoc = nil;
            }
        }
        nextTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(showNextVoc) userInfo:nil repeats:NO];
        solutionTextField.text = @"";
    }
    
}

- (IBAction)checkVoc:(id)sender
{
    if (selectedCollection) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults integerForKey:@"hideVocs"] == 1) {
            [self checkVocFromArray:wrongVocArray];
        }
        else {
            [self checkVocFromArray:currentCollection.vocArray];
        }
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults integerForKey:@"hideVocs"] == 1)
        {
            [self checkVocFromArray:wrongVocArray];
        }
        else
        {
            [self checkVocFromArray:currentKategorie.vocArray];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    keyboardShown = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - (210.0+48.0);
    self.keyboardToolbar.frame = frame;
    
    if (mainScreenHeight !=568.0) {
    frame = selectToolbar.frame;
    frame.origin.y = - frame.size.height;
    selectToolbar.frame = frame;
    
    frame = vocView.frame;
    //frame.origin.y = 0.0;
    vocView.frame = frame;
    
    frame = bottomView.frame;
    frame.origin.y = frame.origin.y - selectToolbar.frame.size.height;
    bottomView.frame = frame;
    
    frame = solutionLabel.frame;
    frame.origin.y = frame.origin.y - selectToolbar.frame.size.height;
    solutionLabel.frame = frame;
    
    frame = solutionTextField.frame;
    frame.origin.y = frame.origin.y - selectToolbar.frame.size.height;
    solutionTextField.frame = frame;
    
    if (homeLanguageField.editing) {
        
        if (mainScreenHeight == 568.00) {
            frame = homeLanguageView.frame;
            frame.origin.y = frame.origin.y - 130.0;
            homeLanguageView.frame = frame;
        } else {
            frame = homeLanguageView.frame;
            frame.origin.y = frame.origin.y - 108.0;
            homeLanguageView.frame = frame;
        }
        
        frame = backgroundView.frame;
        frame.origin.y = frame.origin.y - 44.0;
        backgroundView.frame = frame;
    }
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    keyboardShown = NO;
    if (!removed) {
        [self animateImageWhenKeyboardHides];
    }
        
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    self.keyboardToolbar.frame = frame;
    
    if (mainScreenHeight !=568.0) {
    frame = selectToolbar.frame;
    frame.origin.y = 0.0;
    selectToolbar.frame = frame;
    
    frame = vocView.frame;
    //frame.origin.y = selectToolbar.frame.size.height;
    vocView.frame = frame;
    
    frame = bottomView.frame;
    frame.origin.y = frame.origin.y + selectToolbar.frame.size.height;
    bottomView.frame = frame;
    
    frame = solutionLabel.frame;
    frame.origin.y = frame.origin.y + selectToolbar.frame.size.height;
    solutionLabel.frame = frame;
    
    frame = solutionTextField.frame;
    frame.origin.y = frame.origin.y + selectToolbar.frame.size.height;
    solutionTextField.frame = frame;
    
    if (homeLanguageField.editing) {
        if (mainScreenHeight == 568.00) {
            frame = homeLanguageView.frame;
            frame.origin.y = frame.origin.y + 130.0;
            homeLanguageView.frame = frame;
        } else {
            frame = homeLanguageView.frame;
            frame.origin.y = frame.origin.y + 108.0;
            homeLanguageView.frame = frame;
        }
        frame = backgroundView.frame;
        frame.origin.y = frame.origin.y + 44.0;
        backgroundView.frame = frame;
    }
    
    }
    [UIView commitAnimations];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}
# pragma mark - Images
- (void)showViewWithVocImage:(UIImage *)image
{
    removed = NO;
    if (!keyboardShown) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100.0, self.view.frame.size.width, 255 + 95.0)];
        backgroundView.frame = self.view.frame;
        [self.view bringSubviewToFront:backgroundView];
        [self.view bringSubviewToFront:imageView];
        if (mainScreenHeight != 568.0)
        {
            imageView.frame = CGRectMake(0, 100.0, self.view.frame.size.width, 255.0);
        }
        
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(1, 2);
        imageView.layer.shadowOpacity = 1;
        imageView.layer.shadowRadius = 10.0;
        imageView.clipsToBounds = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (image.size.height < image.size.width) {
            if (mainScreenHeight == 568.0)
            {
                imageView.frame = CGRectMake(0, 135.0 + 50.0, self.view.frame.size.width, 165.0 + 40.0);
            }
            else
            {
                imageView.frame = CGRectMake(0, 135.0, self.view.frame.size.width, 165.0);
            }
        }
        [imageView setImage:image];
        [self.view addSubview:imageView];
        
        imageView.hidden = YES;
        
        imageView.alpha = 0.0;
        imageView.hidden = NO;
        imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        
        backgroundView.hidden = NO;
        
        [UIView animateWithDuration:0.36 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{imageView.alpha = 1.0;
            backgroundView.alpha = 0.6;
            imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }
    
    else if (keyboardShown)
    {
        backgroundView.alpha = 0.0;
        backgroundView.frame = self.view.frame;
        
        if (mainScreenHeight == 568.0)
        {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20.0 + 60.0, self.view.frame.size.width, 200.0+50.0)];
        }
        else {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20.0 + 50.0, self.view.frame.size.width, 180.0)];
        }
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(1, 2);
        imageView.layer.shadowOpacity = 1;
        imageView.layer.shadowRadius = 10.0;
        imageView.clipsToBounds = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (image.size.height < image.size.width) {
            if (mainScreenHeight == 568.0)
            {
                imageView.frame = CGRectMake(0, 80.0 + 15.0, self.view.frame.size.width, 120.0 + 45.0);
            }
            else {
                imageView.frame = CGRectMake(0, 80.0, self.view.frame.size.width, 120.0);
            }
            
        }
        [imageView setImage:image];
        [self.view addSubview:imageView];
        
        imageView.hidden = YES;
        
        imageView.alpha = 0.0;
        imageView.hidden = NO;
        imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        
        backgroundView.hidden = NO;
        
        [UIView animateWithDuration:0.36 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{imageView.alpha = 1.0;
            backgroundView.alpha = 0.9;
            imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }
    
}

- (void)removeViewWithVocImage
{
    if (!locked) {
        [UIView animateWithDuration:0.36 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
            imageView.alpha = 0.0;
            backgroundView.alpha = 0.0;
            imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        } completion:^(BOOL finished){ backgroundView.hidden = YES;}];
        if (keyboardShown) {
            CGRect frame = self.keyboardToolbar.frame;
            frame.origin.y = self.view.frame.size.height - (210.0+48.0);
            self.keyboardToolbar.frame = frame;
        }
        removed = YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // gets the coordinats of the touch with respect to the specified view.
    if (!introduction) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        if (keyboardShown) {
            if (mainScreenHeight == 568.0) {
                if (point.y < 250.0 + 80.0) {
                    [self removeViewWithVocImage];
                }
            }
            else {
                if (point.y < 250.0) {
                    [self removeViewWithVocImage];
                }
            }
        }
        else if (!keyboardShown)
        {
            [self removeViewWithVocImage];
        }
    }
    
}

- (void)animateImageWhenKeyboardHides
{
    removed = NO;
    backgroundView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{backgroundView.alpha = 0.7;
        if (imageView.image.size.height < imageView.image.size.width) {
            if (mainScreenHeight == 568.00) {
                imageView.frame = CGRectMake(0, 135 + 50.0, self.view.frame.size.width, 165 + 40.0);
            }
            else {
                imageView.frame = CGRectMake(0, 135.0, self.view.frame.size.width, 165.0);
            }
        }
        else {
            if (mainScreenHeight == 568.00) {
                imageView.frame = CGRectMake(0, 100, self.view.frame.size.width, 255 + 95.0);
            }
            else {
                imageView.frame = CGRectMake(0, 100, self.view.frame.size.width, 255 + 95.0);
            }
        }
        CGRect rect = backgroundView.frame;
        rect.origin.y = backgroundView.frame.origin.y + 44.0;
        backgroundView.frame = rect;
    } completion:nil];
}

@end
