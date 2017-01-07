//
//  AddVocViewController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 17.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "AddVocViewController.h"
#import "VocListViewController.h"
#import "AddLabel.h"
#import "Vokabel.h"
#import "Kategorie.h"
#import "CustomButton.h"
#import "AddBackgroundVocView.h"
#import "QuartzCore/CALayer.h"

NSMutableArray* kategorieArray;
int globalIndex;
BOOL sortingChanged;
CGFloat mainScreenHeight;

@implementation AddVocViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.canceled = NO;
//        addLabel = [[AddLabel alloc] initWithFrame:CGRectMake(60.0, 30.0, 200, 100)];
//        [self.view addSubview:addLabel];
//        addLabel.hidden = YES;
//        locked = NO;
//        AddBackgroundVocView *backgroundView = [[AddBackgroundVocView alloc] initWithFrame:[self.view bounds]];
//        if (mainScreenHeight == 568.0) {
//            backgroundView.frame = CGRectMake(0, 0, 320.0, 568.0);
//        }
//        [self.view addSubview:backgroundView];
//        [self.view sendSubviewToBack:backgroundView];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)pushNext:(id)sender
{
    locked = YES;
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            if (secondField && !thirdField) {
                secondField = NO;
                thirdField = NO;
                [foreignField resignFirstResponder];
                [germanField becomeFirstResponder];
                break;
            }
            if (!secondField && thirdField)
            {
                secondField = YES;
                thirdField = NO;
                [reminderField resignFirstResponder];
                [foreignField becomeFirstResponder];
                break;
            }
            if (!secondField && !thirdField) {
                break;
            }
            
        case 1:
            if (!secondField && !thirdField) {
                secondField = YES;
                thirdField = NO;
                [germanField resignFirstResponder];
                [foreignField becomeFirstResponder];
                break;
            }
            if (secondField && !thirdField) {
                secondField = NO;
                thirdField = YES;
                [foreignField resignFirstResponder];
                [reminderField becomeFirstResponder];
                break;
            }
            if (thirdField && !secondField) {
                locked = NO;
                [self textFieldShouldReturn:reminderField];
                break;
            }
        default:
            break;
            
    }
    locked = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == reminderField)
    {
        secondField = NO;
        thirdField = YES;
    }
    if (textField == germanField) {
        secondField = NO;
        thirdField = NO;
    }
    if (textField == foreignField) {
        secondField = YES;
        thirdField = NO;
    }
}

- (void)changeTextFieldNotification:(id)selector
{
    BOOL spaceGerman = [[germanField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    BOOL spaceForeign = [[foreignField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];

    if (spaceForeign && spaceGerman) {
        addVocButton.enabled = YES;
        pushButton.enabled = YES;
    }
    else 
    {
        addVocButton.enabled = NO;
        pushButton.enabled = NO;
    }
}

- (void)startEditingTextFieldNotification:(id)selector {
    BOOL spaceGerman = [[germanField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    BOOL spaceForeign = [[foreignField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    
    if (spaceForeign && spaceGerman) {
        addVocButton.enabled = YES;
        pushButton.enabled = YES;
        
    }
    else
    {
        addVocButton.enabled = NO;
        pushButton.enabled = NO;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!locked) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
       
        CGRect frame = self.keyboardToolbar.frame;
        frame.origin.y = self.view.frame.size.height - 260.0;
        self.keyboardToolbar.frame = frame;
        
        frame = imageView.frame;
        frame.origin.y = imageView.frame.origin.y + 100;
        imageView.frame = frame;
            
        [UIView commitAnimations];
    }
   
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!locked) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        
        CGRect frame = self.keyboardToolbar.frame;
        frame.origin.y = self.view.frame.size.height;
        self.keyboardToolbar.frame = frame;
        
        frame = imageView.frame;
        frame.origin.y = imageView.frame.origin.y - 100;
        imageView.frame = frame;
        
        [UIView commitAnimations];
    }
}


- (void)cancelView:(id)sender
{
    self.canceled = NO;
    germanField.text = @"";
    foreignField.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneView:(id)sender{
    BOOL spaceGerman = [[germanField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    BOOL spaceForeign = [[foreignField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    if (spaceForeign && spaceGerman) {
        addVoc = [[Vokabel alloc] init];
        addVoc.homeString = germanField.text;
        addVoc.foreignString = foreignField.text;
        addVoc.reminder = reminderField.text;
        addVoc.foreignLanguage = self.foreignLanguage;
        addVoc.homeLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeLanguage"];
        if (pickedImage)
        {
            addVoc.image = vocImage;
        }
        [self.addVocs addObject:addVoc];
        germanField.text = @"";
        foreignField.text = @"";
        reminderField.text = @"";
        pickedImage = NO;
        self.canceled = YES;
    }
    sortingChanged = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushAddVoc:(id)sender
{
    BOOL spaceGerman = [[germanField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    BOOL spaceForeign = [[foreignField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    if (spaceGerman && spaceForeign) {
        addVoc = [[Vokabel alloc] init];
        addVoc.homeString = germanField.text;
        addVoc.foreignString = foreignField.text;
        addVoc.reminder = reminderField.text;
        addVoc.foreignLanguage = self.foreignLanguage;
        addVoc.homeLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeLanguage"];
        if (pickedImage)
        {
            addVoc.image = vocImage;
        }
        [self.addVocs addObject:addVoc];
        NSLog(@"count %d", [self.addVocs count]);
        germanField.text = @"";
        foreignField.text = @"";
        reminderField.text = @"";
        pickedImage = NO;
        addPictureButton.hidden = NO;
        [imageView removeFromSuperview];
        self.canceled = YES;
        
        addLabel.hidden = NO;
        addLabel.alpha = 0.0;
    
        addLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        [UIView animateWithDuration:0.3 delay:0.0 options:(int)UIViewAnimationCurveEaseOut animations:^{addLabel.alpha = 1.0;
            addLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 delay:0.5 options:(int)UIViewAnimationCurveEaseOut animations:^{addLabel.alpha = 0.0;
                addLabel.transform = CGAffineTransformMakeScale(0.7, 0.7);
            } completion:^(BOOL finished){}];  
        }]; 
    
        
        [germanField becomeFirstResponder];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneView:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.title = NSLocalizedString(@"Neue Vokabel", nil);
    [pushButton setTitle:NSLocalizedString(@"Vokabel hinzufügen", nil)];
    
    foreignField.clearButtonMode = UITextFieldViewModeWhileEditing;
    germanField.clearButtonMode = UITextFieldViewModeWhileEditing;
    reminderField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    foreignField.delegate = self;
    germanField.delegate = self;
    
    cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (cameraAvailable)
    {
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    pickedImage = NO;
    
    addPictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addPictureButton.frame = CGRectMake(20.0, 189.0 + 68.8, 280.0, 37.0);
    [addPictureButton setTitle:NSLocalizedString(@"Bild hinzufügen", nil) forState:UIControlStateNormal];
    [addPictureButton addTarget:self action:@selector(pushAddPicture:) forControlEvents:UIControlEventTouchUpInside];
    [addPictureButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:addPictureButton];
    [self.view sendSubviewToBack:addPictureButton];
    
    addVocButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addVocButton.frame = CGRectMake(20.0, 360.0 + 68.0, 280.0, 37.0);
    [addVocButton setTitle:NSLocalizedString(@"Vokabel hinzufügen", nil) forState:UIControlStateNormal];
    [addVocButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [addVocButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:255.0/255.0 alpha:0.3] forState:UIControlStateDisabled];
    [addVocButton addTarget:self action:@selector(pushAddVoc:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:addVocButton];
    
    CGRect addButtonFrame = addPictureButton.frame;
    CGRect vocButtonFrame = addVocButton.frame;
    if (mainScreenHeight == 568.0) {
        addButtonFrame.origin.y = addButtonFrame.origin.y - 8.0;
        addPictureButton.frame = addButtonFrame;
        vocButtonFrame.origin.y = vocButtonFrame.origin.y + 88.0;
        addVocButton.frame = vocButtonFrame;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextFieldNotification:) name:UITextFieldTextDidChangeNotification object:foreignField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextFieldNotification:) name:UITextFieldTextDidChangeNotification object:germanField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditingTextFieldNotification:) name:UITextFieldTextDidBeginEditingNotification
                                               object:germanField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditingTextFieldNotification:) name:UITextFieldTextDidBeginEditingNotification
                                               object:foreignField];
    
    self.canceled = NO;
    addLabel = [[AddLabel alloc] initWithFrame:CGRectMake(60.0, 30.0 + 65.0, 200, 100)];
    [self.view addSubview:addLabel];
    addLabel.hidden = YES;
    locked = NO;

}


- (void)viewWillAppear:(BOOL)animated
{
    addPictureButton.hidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    if (!pickedImage) {
        self.addVocs = [[NSMutableArray alloc] init];
    }
    secondField = NO;
    thirdField = NO;
    foreignLanguageLabel.text = [[[kategorieArray objectAtIndex:globalIndex] foreignLanguage] stringByAppendingString:@":"];
    homeLanguageLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"homeLanguage"] stringByAppendingString:@":"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
    if (pickedImage) {
        addPictureButton.hidden = YES;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 165)];
        if (mainScreenHeight == 568.0) {
            imageView.frame = CGRectMake(0, 180 + 85.0, self.view.frame.size.width, 165.0);
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
                imageView.frame = CGRectMake(0, 150 + 80.0, self.view.frame.size.width, 165);
            }
            else {
                imageView.frame = CGRectMake(0, 150, self.view.frame.size.width, 165);
            }
        }
        [imageView setImage:vocImage];
        [self.view addSubview:imageView];
    }
    [self changeTextFieldNotification:germanField];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    pickedImage = NO;
    [imageView removeFromSuperview];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark ---PICTURES---

#pragma mark Accessing
- (void)pushAddPicture:(id)sender
{
    if (cameraAvailable) {
        UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Abbrechen", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Aus Album auswählen", nil),NSLocalizedString(@"Foto aufnehmen", nil), nil];
        [photoActionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [photoActionSheet  showInView:self.view];
        addPictureButton.hidden = YES;
    }
    else {
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self startMediaBrowserFromViewController:self usingDelegate:self];
        addPictureButton.hidden = NO;
    }
    if (buttonIndex == 1) {
        [self startCameraControllerFromViewController:self usingDelegate:self];
        addPictureButton.hidden = NO;
    }
    addPictureButton.hidden = NO;
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

- (BOOL)startMediaBrowserFromViewController: (UIViewController*) controller
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
        vocImage = nil;
        vocImage = [[UIImage alloc] init];
        vocImage = originalImage;
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
    /*float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    if(height < width)
        rect.origin.y = height / 3;
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    
    UIImage *smallImage =
    [UIImage imageWithCGImage:[image CGImage]
                        scale:(image.scale * 0.3)
                  orientation:(image.imageOrientation)];
    
    return smallImage;
}



@end

