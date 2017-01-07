//
//  CollectionViewController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 01.09.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCollectionViewController.h"


@interface CollectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *tableView;
    AddCollectionViewController *addController;
    int currentCount;
    int currentIndex;
    BOOL fromAddCollection;
}

- (void)pushAdd:(id)sender;

@end
