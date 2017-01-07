//
//  StatisticsController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 18.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "StatisticsController.h"
#import "DiagramView.h"
#import "GraphView.h"
#import "Sammlung.h"
#import "Kategorie.h"
#import "SWRevealViewController.h"

Kategorie *statisticsKategorie;
Sammlung *statisticsCollection;
NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;
CGFloat mainScreenHeight;

BOOL selectedCollection;
int globalIndex;
int globalCollectionIndex;

@implementation StatisticsController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
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
    self.navigationController.title = NSLocalizedString(@"Statistik", nil);
    self.title = NSLocalizedString(@"Statistik", nil);
    _sidebarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = _sidebarButton;
    self.revealViewController.delegate = self;
    CGRect bounds = [self.view bounds];
    
    diagramView = [[DiagramView alloc] initWithFrame:bounds];
    CGRect frame = CGRectMake(bounds.origin.x + 320, bounds.origin.y, bounds.size.width, bounds.size.height);
    graphView = [[GraphView alloc] initWithFrame:frame];
    [scrollView addSubview:diagramView];
    [scrollView addSubview:graphView];
    scrollView.contentSize = CGSizeMake(bounds.size.width + 320.0, 0);
    [self.view bringSubviewToFront:pageControl];
    
    
    if (mainScreenHeight == 568.0) {
        pageControl.frame = CGRectMake(0, 410.0, 320.0, 36.0);
    }
    
    self.navigationItem.leftBarButtonItem = self.sidebarButton;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    if(position == FrontViewPositionLeft) {
        scrollView.scrollEnabled = YES;
    }
    else if (position == FrontViewPositionRight) {
        scrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    int pageWidth = scrollView.frame.size.width;
    int rest = abs((int)(scrollView.contentOffset.x - pageWidth) % pageWidth);
    if (rest == 0) {
        int page = round((scrollView.contentOffset.x - pageWidth) / pageWidth) + 1;
        pageControl.currentPage = page;
    }
}

- (IBAction)changePage
{
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * pageControl.currentPage, 0) animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    if (selectedCollection) {
        if ([collectionArray count] > 0) {
            statisticsCollection = [collectionArray objectAtIndex:globalCollectionIndex];
        }
    } else {
        if ([kategorieArray count] > 0) {
            statisticsKategorie = [kategorieArray objectAtIndex:globalIndex];
        }
    }
    
    [diagramView setNeedsDisplay];
    [graphView setNeedsDisplay];
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

@end
