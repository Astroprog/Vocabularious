//
//  VocInfoViewController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 17.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "VocInfoViewController.h"
#import "Vokabel.h"
#import "VocInfoBackgroundView.h"
#import "VocInfoAddView.h"
#import "Kategorie.h"
#import "QuartzCore/CALayer.h"
#import "Sammlung.h"
#import "BlurView.h"

int globalIndex;
NSMutableArray *kategorieArray;
BOOL imageSet;
CGFloat mainScreenHeight;
NSMutableArray *collectionArray;

@implementation VocInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       

    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    
    self.germanLabel.text = self.viewedVoc.homeString;
    self.foreignLabel.text = self.viewedVoc.foreignString;
    
    rightTitleLabel.text = NSLocalizedString(@"Richtig:", nil);
    falseTitleLabel.text = NSLocalizedString(@"Falsch:", nil);
    
    rightLabel.text = [NSString stringWithFormat:@"%d", self.viewedVoc.rightGesamt];
    falseLabel.text = [NSString stringWithFormat:@"%d", self.viewedVoc.falseGesamt];
    foreignLanguageLabel.text = [NSString stringWithFormat:@"%@:", self.viewedVoc.foreignLanguage];
    homeLanguageLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"homeLanguage"] stringByAppendingString:@":"];
    self.reminderLabel.text = self.viewedVoc.reminder;
    
    [self.foreignLabel sizeToFit];
    foreignScrollView.contentSize = CGSizeMake(self.foreignLabel.frame.size.width + 30, 20);
    foreignScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [foreignScrollView flashScrollIndicators];
    
    [self.germanLabel sizeToFit];
    homeScrollView.contentSize = CGSizeMake(self.germanLabel.frame.size.width + 30, 20);
        NSLog(@"%f",homeScrollView.contentSize.width);
    homeScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [homeScrollView flashScrollIndicators];
    
    [self.reminderLabel sizeToFit];
    reminderScrollView.contentSize = CGSizeMake(self.reminderLabel.frame.size.width + 30, 20);
    reminderScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [reminderScrollView flashScrollIndicators];

    removed = YES;
    
    if (self.viewedVoc.image && !pickedImage) {
        imageSet = YES;
        vocImage = self.viewedVoc.image;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 272 + 35.0, self.view.frame.size.width, 123.0 + 45.0)];
        if (mainScreenHeight != 568.0)
        {
            imageView.frame = CGRectMake(0, 272.0, self.view.frame.size.width, 123.0);
        }
        imageView.layer.shadowColor = [UIColor whiteColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(1, 2);
        imageView.layer.shadowOpacity = 1;
        imageView.layer.shadowRadius = 10.0;
        imageView.clipsToBounds = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (vocImage.size.height < vocImage.size.width) {
            if (mainScreenHeight == 568.0) {
                imageView.frame = CGRectMake(0, 220.0 + 50.0, self.view.frame.size.width, 165.0 + 15.0);
            }
            else
            {
                imageView.frame = CGRectMake(0, 220.0, self.view.frame.size.width, 165.0);
            }
        }
        [imageView setImage:vocImage];
        [self.view addSubview:imageView];
        imageView.userInteractionEnabled = YES;
    }

    else if (pickedImage) {
        imageSet = YES;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 272 + 35.0, self.view.frame.size.width, 123 + 45.0)];
        
        if (mainScreenHeight != 568.0)
        {
            imageView.frame = CGRectMake(0, 272.0, self.view.frame.size.width, 123.0);
        }
        imageView.layer.shadowColor = [UIColor whiteColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(1, 2);
        imageView.layer.shadowOpacity = 1;
        imageView.layer.shadowRadius = 10.0;
        imageView.clipsToBounds = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        vocImage = [self scaleImage:vocImage];
        if (vocImage.size.height < vocImage.size.width) {
            if (mainScreenHeight == 568.0) {
                imageView.frame = CGRectMake(0, 220.0 + 50.0, self.view.frame.size.width, 165.0 + 15.0);
            }
            else {
            imageView.frame = CGRectMake(0, 220.0, self.view.frame.size.width, 165.0);
            }
        }
        Vokabel *oldVoc = [self.viewedVoc copy];
        self.viewedVoc.image = vocImage;
        
        if (!self.fromCollectionViewController)
        {
            [self exchangeVocInCollectionWithOldVoc:oldVoc andNewVoc:self.viewedVoc];
        }
        else if (self.fromCollectionViewController)
        {
            [self exchangeVocInCollectionWithOldVoc:oldVoc andNewVoc:self.viewedVoc];
            [self exchangeVocInKategorieWithOldVoc:oldVoc andNewVoc:self.viewedVoc];
        }
        vocImage = self.viewedVoc.image;
        [imageView setImage:vocImage];
        [self.view addSubview:imageView];
        pickedImage = NO;
        imageView.userInteractionEnabled = YES;
        oldVoc = nil;
    }
    else {
        imageSet = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*VocInfoBackgroundView *background = [[VocInfoBackgroundView alloc] initWithFrame:self.view.bounds];
    if (mainScreenHeight == 568.0) {
        background.frame = CGRectMake(0, 0, 320.0, 568.0);
    }
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];*/
    addView = [[VocInfoAddView alloc] initWithFrame:CGRectMake(10, 10, 300, 250)];
    [self.view addSubview:addView];
    addView.hidden = YES;
    self.title = NSLocalizedString(@"Vokabel", nil);
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(textFieldDidReturn) name:@"return" object:nil];
    [nc addObserver:self selector:@selector(pushAddPicture:) name:@"editPicture" object:nil];
    
    cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (cameraAvailable)
    {
        cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    vocImage = [[UIImage alloc] init];
    pickedImage = NO;
    
    /*
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, mainScreenHeight)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0;
    [self.view addSubview:backgroundView];*/

}

 
- (void)textFieldDidReturn
{
    self.germanLabel.text = addView.germanField.text;
    self.foreignLabel.text = addView.foreignField.text;
    self.reminderLabel.text = addView.reminderField.text;
    //Multiline Label!
    
    if (!self.fromCollectionViewController)
    {
        Vokabel *oldVoc = [self.viewedVoc copy];
        self.viewedVoc.homeString = self.germanLabel.text;
        self.viewedVoc.foreignString = self.foreignLabel.text;
        self.viewedVoc.reminder = self.reminderLabel.text;
        
        long indexOfViewedVoc = [[[kategorieArray objectAtIndex:globalIndex] vocArray] indexOfObject:self.viewedVoc];
        [[[kategorieArray objectAtIndex:globalIndex] vocArray] replaceObjectAtIndex:indexOfViewedVoc withObject:self.viewedVoc];
        
        if ([collectionArray count])
        {
            [self exchangeVocInCollectionWithOldVoc:oldVoc andNewVoc:self.viewedVoc];
        }
        oldVoc = nil;
    }
    else if (self.fromCollectionViewController)
    {
        Vokabel *oldVoc = [self.viewedVoc copy];
        self.viewedVoc.homeString = self.germanLabel.text;
        self.viewedVoc.foreignString = self.foreignLabel.text;
        self.viewedVoc.reminder = self.reminderLabel.text;
        
        [self exchangeVocInCollectionWithOldVoc:oldVoc andNewVoc:self.viewedVoc];
        [self exchangeVocInKategorieWithOldVoc:oldVoc andNewVoc:self.viewedVoc];
    }
    
    [UIView animateWithDuration:0.18 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{addView.alpha = 0.0;
        blurView.alpha = 0.0;
        addView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        blurView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished){
        addView.hidden = YES;
        blurView.hidden = YES;
    }]; 
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
    
    [self.foreignLabel sizeToFit];
    foreignScrollView.contentSize = CGSizeMake(self.foreignLabel.frame.size.width + 30, 20);
    foreignScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [foreignScrollView flashScrollIndicators];
    
    [self.germanLabel sizeToFit];
    homeScrollView.contentSize = CGSizeMake(self.germanLabel.frame.size.width + 30, 20);
    homeScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [homeScrollView flashScrollIndicators];
    
    [self.reminderLabel sizeToFit];
    reminderScrollView.contentSize = CGSizeMake(self.reminderLabel.frame.size.width + 30, 20);
    reminderScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [reminderScrollView flashScrollIndicators];
}



- (void)exchangeVocInCollectionWithOldVoc:(Vokabel *)oldVoc andNewVoc:(Vokabel *)newVoc
{
    for (Sammlung *collection in collectionArray)
    {
        for (int i = 0; i < [collection.vocArray count]; i++)
        {
            Vokabel *voc = [collection.vocArray objectAtIndex:i];
            
            if ([oldVoc.homeString isEqualToString:voc.homeString] && [oldVoc.foreignString isEqualToString:voc.foreignString] && [oldVoc.homeLanguage isEqualToString:voc.homeLanguage] && oldVoc.rightCount == voc.rightCount && oldVoc.falseGesamt == voc.falseGesamt && oldVoc.rightGesamt == voc.rightGesamt && [oldVoc.reminder isEqualToString:voc.reminder])
            {
                [[collection vocArray] replaceObjectAtIndex:i withObject:self.viewedVoc];
            }
        }
    }
    oldVoc = nil;
    newVoc = nil;
}

- (void)exchangeVocInKategorieWithOldVoc:(Vokabel *)oldVoc andNewVoc:(Vokabel *)newVoc
{
    for (Kategorie *kategorie in kategorieArray)
    {
        for (int i = 0; i < [kategorie.vocArray count]; i++)
        {
            Vokabel *voc = [kategorie.vocArray objectAtIndex:i];
            
            if ([oldVoc.homeString isEqualToString:voc.homeString] && [oldVoc.foreignString isEqualToString:voc.foreignString] && [oldVoc.homeLanguage isEqualToString:voc.homeLanguage] && oldVoc.rightCount == voc.rightCount && oldVoc.falseGesamt == voc.falseGesamt && oldVoc.rightGesamt == voc.rightGesamt && [oldVoc.reminder isEqualToString:voc.reminder])
            {
                [[kategorie vocArray] replaceObjectAtIndex:i withObject:self.viewedVoc];
            }
        }
    }
    oldVoc = nil;
    newVoc = nil;

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (editing) {
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pushDone:)];
        [self.navigationItem setRightBarButtonItem:cancelItem animated:YES];
        blurView = [[BlurView alloc] initWithFrame:self.view.frame];
        blurView.radius = 2.0;
        [self.view addSubview:blurView];
        [blurView setViewToBlur:self.view];
        CGRect frame = blurView.frame;
        frame.origin.y = 0.0;
        blurView.frame = frame;
        blurView.alpha = 0.0;
        addView.alpha = 0.0;
        addView.hidden = NO;
        addView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        blurView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [addView reloadTextFieldsWithGermanString:self.germanLabel.text andForeignString:self.foreignLabel.text andReminderString:self.reminderLabel.text];
        addView.foreignLabel.text = foreignLanguageLabel.text;
        [UIView animateWithDuration:0.18 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{addView.alpha = 1.0;
            addView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            blurView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            blurView.alpha = 1.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.07 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
                addView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.07 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
                    addView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished){}];  

            }];  
        }]; 

        
    } else {
        addView.hidden = YES;
        blurView.hidden = YES;
        [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
        [self.navigationItem setLeftBarButtonItem:nil animated:YES]; 
    }
    [self.view bringSubviewToFront:addView];
}

- (void)pushDone:(id)sender
{

    
    addView.germanField.text = @"";
    addView.foreignField.text = @"";
    addView.reminderField.text = @"";
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
    
    [UIView animateWithDuration:0.18 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
        addView.alpha = 0.0;
        blurView.alpha = 0.0;
        addView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished){
        addView.hidden = YES;
        blurView.hidden = YES;
    }]; 
    
    [addView.germanField resignFirstResponder];
    [addView.foreignField resignFirstResponder];
    [addView.reminderField resignFirstResponder];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    imageSet = NO;
    pickedImage = NO;
    [imageView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self removeViewWithVocImage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [addView keyboardWillShow];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [addView keyboardWillHide];
}


#pragma mark ---PICTURES---

#pragma mark Accessing
- (void)pushAddPicture:(id)selector
{
    [self pushDone:self];
    if (imageSet) {
        UIActionSheet *editActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Bearbeiten", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen", nil) destructiveButtonTitle:NSLocalizedString(@"Foto löschen", nil) otherButtonTitles:NSLocalizedString(@"Neues Foto auswählen",nil), nil];
        [editActionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [editActionSheet showInView:self.view];
        editActionSheet = nil;
    }
    else if (!imageSet){
        if (cameraAvailable) {
            UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Bild hinzufügen",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Aus Album auswählen",nil),NSLocalizedString(@"Foto aufnehmen",nil), nil];
            [photoActionSheet setActionSheetStyle:UIActionSheetStyleDefault];
            [photoActionSheet showInView:self.view];
            photoActionSheet = nil;
        }
        else [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:NSLocalizedString(@"Bild hinzufügen", nil)]) {
        if (buttonIndex == 0) {
            [self startMediaBrowserFromViewController:self usingDelegate:self];
            }
        if (buttonIndex == 1) {
            [self startCameraControllerFromViewController:self usingDelegate:self];
            }  
    }
    else if ([actionSheet.title isEqualToString:NSLocalizedString(@"Bearbeiten", nil)])
    {
        if (buttonIndex == 0)
        {
            self.viewedVoc.image = nil;
            [imageView removeFromSuperview];
            imageSet = NO;
            pickedImage = NO;
        }
        else if (buttonIndex == 1) {
            if (cameraAvailable) {
            UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Bild hinzufügen", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Aus Album auswählen", nil),NSLocalizedString(@"Foto aufnehmen", nil), nil];
            [photoActionSheet setActionSheetStyle:UIActionSheetStyleDefault];
            [photoActionSheet  showInView:self.view];
            photoActionSheet = nil;
        }
        else [self startMediaBrowserFromViewController:self usingDelegate:self];
        }
    }
    
}


#pragma mark Delegates
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [controller presentViewController:cameraUI animated: YES completion:nil];
    return YES;
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController: mediaUI animated: YES completion:nil];
    return YES;
}



// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker dismissViewControllerAnimated: YES completion:nil];
    picker = nil;
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) CFBridgingRetain(mediaType), kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        vocImage = imageToSave;
        // Save the new image (original or edited) to the Camera Roll
        //        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    }
    CFRelease((__bridge CFTypeRef)(mediaType));
    pickedImage = YES;
    imageToSave = nil;
    originalImage = nil;
    editedImage = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

#pragma mark Size
-(UIImage *)scaleImage:(UIImage *)image {
//    
//    float width = newSize.width;
//    float height = newSize.height;
//    
//    UIGraphicsBeginImageContext(newSize);
//    CGRect rect = CGRectMake(0, 0, width, height);
//    
//    float widthRatio = image.size.width / width;
//    float heightRatio = image.size.height / height;
//    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
//    
//    width = image.size.width / divisor;
//    height = image.size.height / divisor;
//    
//    rect.size.width  = width;
//    rect.size.height = height;
//    
//    if(height < width)
//        rect.origin.y = height / 3;
//    [image drawInRect: rect];
//    
//    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    UIImage *smallImage =
    [UIImage imageWithCGImage:[image CGImage]
                        scale:(image.scale * 0.3)
                  orientation:(image.imageOrientation)];
    
    return smallImage;
}

- (void)removeViewWithVocImage
{
    //NSLog(@"remove");
    [UIView animateWithDuration:0.36 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{
        if (imageView.image.size.height < imageView.image.size.width) {
            if (mainScreenHeight == 568.0) {
                imageView.frame = CGRectMake(0, 220.0 + 50.0, self.view.frame.size.width, 165.0 + 15.0);
            }
            else {
            imageView.frame = CGRectMake(0, 220.0, self.view.frame.size.width, 165.0); // CHECK
            }
        }
        else {
            if (mainScreenHeight == 568.0) {
                imageView.frame = CGRectMake(0, 272 + 35.0, self.view.frame.size.width, 123.0 + 45.0);
            }
            else {
                imageView.frame = CGRectMake(0, 272.0, self.view.frame.size.width, 123.0);  //CHECK
            }
        }
        backgroundView.alpha = 0.0;
    } completion:nil];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // gets the coordinats of the touch with respect to the specified view.
    //NSLog(@"began");
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    //NSLog(@"Point -- x: %f - y: %f", point.x,point.y);
    //CGRect imageRect = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
    
    //NSLog(@"Imageview Rect: %f, %f, %f, %f,", imageRect.origin.x, imageRect.origin.y, imageRect.size.width, imageRect.size.height);
    //NSLog(@"bool: %d",[touch view] == imageView);
    
    CGSize imageSize = imageView.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(imageView.bounds)/imageSize.width, CGRectGetHeight(imageView.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    //NSLog(@"Scale: %f, %f", scaledImageSize.width, scaledImageSize.height);
    
    CGFloat distanceToBorder = (self.view.bounds.size.width - scaledImageSize.width)/2;
    if (!removed)
    {
        [self removeViewWithVocImage];
        removed = YES;
        return;
    }
    else if (mainScreenHeight == 568.00 && removed) {
        if (removed && point.y >= imageView.frame.origin.y && point.x > distanceToBorder && point.x < distanceToBorder + scaledImageSize.width && point.y <= 451.0 && imageView.image.size.width > imageView.image.size.height && self.viewedVoc.image) // Bild quer
        {
            [self showViewWithVocImage:self.viewedVoc.image];
        }
        else if (removed && point.y >= 308.0 && point.x > distanceToBorder && point.x < distanceToBorder + scaledImageSize.width && point.y <= 476.0 && imageView.image.size.height > imageView.image.size.width && self.viewedVoc.image)    // Bild hoch
        {
            [self showViewWithVocImage:self.viewedVoc.image];
        }
    }
    
    else if (mainScreenHeight != 568.0 && removed)
    {
        if (removed && point.y >= imageView.frame.origin.y && point.x > distanceToBorder && point.x < distanceToBorder + scaledImageSize.width && point.y <= 386.0 && imageView.image.size.width > imageView.image.size.height && self.viewedVoc.image) // Bild quer
            {
                [self showViewWithVocImage:self.viewedVoc.image];
            }
        else if (removed && point.y >= 273.0 && point.x > distanceToBorder && point.x < distanceToBorder + scaledImageSize.width && point.y <= 397.5 && imageView.image.size.height > imageView.image.size.width && self.viewedVoc.image)    // Bild hoch
            {
                [self showViewWithVocImage:self.viewedVoc.image];
            }
    
    }
    
}

- (void)showViewWithVocImage:(UIImage *)image
{
    removed = NO;
        [UIView animateWithDuration:0.36 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{;
            if (image.size.height < image.size.width) {
                if (mainScreenHeight == 568.0) {
                    imageView.frame = CGRectMake(0, 115.0, self.view.frame.size.width, 165.0 + 40.0);
                }
                else
                {
                    imageView.frame = CGRectMake(0, 100.0, self.view.frame.size.width, 165.0);
                }
            }
            else
            {
                if (mainScreenHeight == 568.0) {
                    imageView.frame = CGRectMake(0, 85.0, self.view.frame.size.width, 255 + 95.0);
                }
                else
                {
                    imageView.frame = CGRectMake(0, 85, self.view.frame.size.width, 255);
                }
            }
            self.navigationItem.rightBarButtonItem.enabled = NO;
            backgroundView.alpha = 0.8;
        } completion:nil];
}




@end
