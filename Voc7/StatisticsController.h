//
//  StatisticsController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 18.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
@class DiagramView;
@class Kategorie;
@class Sammlung;
@class SelectKategorieViewController;
@class GraphView;

extern Kategorie *statisticsKategorie;
extern Sammlung *statisticsCollection;


@interface StatisticsController : UIViewController <UIScrollViewDelegate, SWRevealViewControllerDelegate>
{
    DiagramView *diagramView;
    GraphView *graphView;
    SelectKategorieViewController *selectKategorieViewController;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    BOOL toggle;
}

- (IBAction)changePage;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sidebarButton;

@end
